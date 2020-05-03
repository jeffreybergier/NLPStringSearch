//
//  StringRangeTrie.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

class StringRangeTrie {
    typealias Marker = Range<String.Index>
    private let trie = Trie<Character, Marker>(headValue: "•")
    func insert(_ values: String, marker: Marker) {
        self.trie.insert(Array(values), marker: marker)
    }
    func markers(for search: String) -> Set<Marker> {
        return self.trie.markers(for: Array(search))
    }
}
