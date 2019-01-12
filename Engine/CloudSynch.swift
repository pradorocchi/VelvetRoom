import Foundation
import CloudKit
import Network

class CloudSynch:Synch {
    var notification:(([String:TimeInterval]) -> Void)!
    var loaded:((Board) -> Void)!
    var error:((Error) -> Void)!
    private var started = false
    private var network = true
    private var monitor:Any?
    
    func start() {
        LocalStorage.queue.async {
            self.register()
            if #available(iOS 12.0, *) {
                if #available(OSX 10.14, *) {
                    let monitor = NWPathMonitor()
                    monitor.start(queue:LocalStorage.queue)
                    monitor.pathUpdateHandler = {
                        self.network = $0.status == .satisfied
                    }
                    self.monitor = monitor
                }
            }
        }
    }
    
    func load(_ id:String) {
        LocalStorage.queue.async {
            CKContainer(identifier:"iCloud.VelvetRoom").publicCloudDatabase.fetch(withRecordID:.init(recordName:id))
            { record, error in
                if error != nil {
                    self.error(Exception.failedLoadingFromIcloud)
                } else if let json = record?["json"] as? CKAsset,
                    let data = try? Data(contentsOf:json.fileURL),
                    let board = try? JSONDecoder().decode(Board.self, from:data) {
                    self.loaded(board)
                } else {
                    self.error(Exception.errorWhileLoadingFromIcloud)
                }
            }
        }
    }
    
    func save(_ account:[String:TimeInterval]) {
        if started {
            LocalStorage.queue.async {
                NSUbiquitousKeyValueStore.default.set(account, forKey:"velvetroom.boards")
                NSUbiquitousKeyValueStore.default.synchronize()
            }
        }
    }
    
    func save(_ board:Board) {
        if started && network {
            LocalStorage.queue.async {
                let record = CKRecord(recordType:"Board", recordID:.init(recordName:board.id))
                record["json"] = CKAsset(fileURL:LocalStorage.url(board.id))
                let operation = CKModifyRecordsOperation(recordsToSave:[record])
                operation.savePolicy = .allKeys
                operation.perRecordCompletionBlock = { _, error in
                    if error != nil {
                        self.error(Exception.unableToSaveToIcloud)
                    }
                }
                CKContainer(identifier:"iCloud.VelvetRoom").publicCloudDatabase.add(operation)
            }
        }
    }
    
    private func register() {
        NotificationCenter.default.addObserver(forName:NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object:nil, queue:OperationQueue()) { _ in self.fetch() }
        started = NSUbiquitousKeyValueStore.default.synchronize()
        if started && FileManager.default.ubiquityIdentityToken == nil {
            started = false
            error(Exception.noIcloudToken)
        }
    }
    
    private func fetch() {
        if let account = NSUbiquitousKeyValueStore.default.dictionary(
            forKey:"velvetroom.boards") as? [String:TimeInterval] {
            notification(account)
        }
    }
}
