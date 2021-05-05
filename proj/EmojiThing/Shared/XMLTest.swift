import Foundation
import SwiftyXMLParser

class XMLTest {

    init() {
        let fileURL = Bundle.url(forResource: "annotations_en", withExtension: "xml", subdirectory: ".", in: Bundle.main.bundleURL)
        let xmlData = try! Data(contentsOf: fileURL!)
        let string = String(decoding: xmlData, as: UTF8.self)
        let xml = try! XML.parse(string)
        print(xml)
    }
}
