import Foundation

public enum Exception:LocalizedError {
    case accountNotFound
    case noColumns
    case invalidQRCode
    case noIcloudToken
    case failedLoadingFromIcloud
    case errorWhileLoadingFromIcloud
    case unableToSaveToIcloud
    case unknown
}
