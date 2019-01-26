import Foundation
@testable import VelvetRoom

class MockGroup:Group {
    var onShare:(() -> Void)?
    
    func share(_ boards:[Board]) {
        onShare?()
    }
}
