import Foundation
import SwiftyXMLParser

class XMLTest {

    init() {
        let fileURL = Bundle.url(forResource: "annotations_en", withExtension: "xml", subdirectory: ".", in: Bundle.main.bundleURL)
        let xmlData = try! Data(contentsOf: fileURL!)
        let string = String(decoding: xmlData, as: UTF8.self)
        let xml = try! XML.parse(string)
        let iterator = xml.ldml.annotations.annotation.makeIterator()
        var termMap = [String: [String]]()
        for annotation in iterator {
            let emoji = annotation.attributes["cp"]!
            let tags = annotation.text!.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }.flatMap { $0.split(separator: " ").map{ String($0) }
            }
            termMap[emoji] = (termMap[emoji] ?? []) + tags
        }
        var invertedMap = [String: [String]]()
        for (key, val) in termMap {
            let emoji = key
            let vals = Set(val)
            for val in vals {
                invertedMap[val] = (invertedMap[val] ?? []) + [emoji]
            }
        }
        print(invertedMap)
    }
}
