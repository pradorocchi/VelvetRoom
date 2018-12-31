import Foundation
import CloudKit

class CloudSynch:Synch {
    var notification:(([String:TimeInterval]) -> Void)!
    var loaded:((Board) -> Void)!
    private var started = false
    
    func start() {
        DispatchQueue.global(qos:.background).async {
            self.register()
            self.fetch()
        }
    }
    
    func load(_ id:String) {
        DispatchQueue.global(qos:.background).async {
            CKContainer(identifier:"iCloud.VelvetRoom").publicCloudDatabase.fetch(withRecordID:.init(recordName:id))
            { record, _ in
                if let json = record?["json"] as? CKAsset,
                    let data = try? Data(contentsOf:json.fileURL),
                    let board = try? JSONDecoder().decode(Board.self, from:data) {
                    self.loaded(board)
                }
            }
        }
    }
    
    func save(_ account:[String:TimeInterval]) {
        if started {
            DispatchQueue.global(qos:.background).async {
                NSUbiquitousKeyValueStore.default.set(account, forKey:"velvetroom.boards")
                NSUbiquitousKeyValueStore.default.synchronize()
            }
        }
    }
    
    func save(_ board:Board) {
        if started {
            DispatchQueue.global(qos:.background).async {
                let record = CKRecord(recordType:"Board", recordID:.init(recordName:board.id))
                record["json"] = CKAsset(fileURL:LocalStorage.url(board.id))
                let operation = CKModifyRecordsOperation(recordsToSave:[record])
                operation.savePolicy = .allKeys
                CKContainer(identifier:"iCloud.VelvetRoom").publicCloudDatabase.add(operation)
            }
        }
    }
    
    private func register() {
        NotificationCenter.default.addObserver(forName:NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object:nil, queue:OperationQueue()) { _ in self.fetch() }
        started = NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    private func fetch() {
        if let account = NSUbiquitousKeyValueStore.default.dictionary(
            forKey:"velvetroom.boards") as? [String:TimeInterval] {
            notification(account)
        }
    }
}
