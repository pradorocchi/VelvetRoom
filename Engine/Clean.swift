import Foundation

protocol Clean { }

extension Clean {
    func clean(_ string:String) -> String {
        var string = string
        while let last = string.last,
            last == " " || last == "\n" || last == "\r" || last == "\t" {
                string = String(string.dropLast())
        }
        return string
    }
}
