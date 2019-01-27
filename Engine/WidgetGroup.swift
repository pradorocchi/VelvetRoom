import Foundation

class WidgetGroup:Group {
    func share(_ boards:[Board]) {
        Repository.queue.async {
            Widget.items = boards.map { Widget(name:$0.name, columns:$0.chart.map { $0.1 } ) }
        }
    }
}
