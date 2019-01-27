import Foundation

class WidgetGroup:Group {
    private let queue = DispatchQueue(label:String(), qos:.background, target:.global(qos:.background))
    
    func share(_ boards:[Board]) {
        
    }
}
