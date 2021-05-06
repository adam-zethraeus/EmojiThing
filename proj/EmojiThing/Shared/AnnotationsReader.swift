import Foundation
import SwiftyXMLParser


class TrieNode: Codable {
    let c: String
    init(char: String) {
        self.c = char
    }
    var e = [String]()
    var n = [String: TrieNode]()
}

class AnnotationsReader {

    let termMap: [String: [String]]
    init() {
        let fileURL = Bundle.url(forResource: "annotations_en", withExtension: "xml", subdirectory: ".", in: Bundle.main.bundleURL)
        let xmlData = try! Data(contentsOf: fileURL!)
        let string = String(decoding: xmlData, as: UTF8.self)
        let xml = try! XML.parse(string)
        let iterator = xml.ldml.annotations.annotation.makeIterator()
        var termMap = [String: [String]]()
        for annotation in iterator {
            let emoji = annotation.attributes["cp"]!
            let tags = annotation.text!.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }.flatMap { $0.split(separator: " ").map{ $0.lowercased() }
            }
            termMap[emoji] = (termMap[emoji] ?? []) + tags
        }
        self.termMap = termMap
    }

    func trie() -> TrieNode {
        func buildTrie(on parent: inout TrieNode, string: String, emoji: String) {
            guard string.count > 0 else { return }
            var tail = string
            let head = String(tail.removeFirst())
            var node = parent.n[head] ?? TrieNode(char: head)
            parent.n[head]  = node
            if tail.count == 0 {
                node.e.append(emoji)
                return
            }
            buildTrie(on: &node, string: tail, emoji: emoji)
        }

        var root = TrieNode(char: "*")

        for (key, val) in termMap {
            let emoji = key
            let vals = Set(val)
            for val in vals {
                buildTrie(on: &root, string: val, emoji: emoji)
            }
        }
        return root
    }

    func invertedMap() -> [String: [String]]{
        var invertedMap = [String: [String]]()
        for (key, val) in termMap {
            let emoji = key
            let vals = Set(val)
            for val in vals {
                invertedMap[val] = (invertedMap[val] ?? []) + [emoji]
            }
        }
        return invertedMap
    }
}
