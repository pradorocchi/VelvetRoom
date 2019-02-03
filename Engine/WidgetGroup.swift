import Foundation

class WidgetGroup:Group {
    func share(_ boards:[Board]) {
        Repository.queue.async {
            Widget.items = boards.reduce(into:[String:[WidgetItem]]()) {
                $0[$1.name] = $1.chart.map { WidgetItem(name:$0.0, percent:$0.1) }
            }
        }
    }
}
