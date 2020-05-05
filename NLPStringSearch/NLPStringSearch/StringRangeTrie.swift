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
    func insert<S: StringProtocol>(_ values: S, marker: Marker) {
        self.trie.insert(Array(values), marker: marker)
    }
    func markers<S: StringProtocol>(for search: S) -> Set<Marker> {
        return self.trie.markers(for: Array(search))
    }
    var allInsertions: LazyMapSequence<LazySequence<[[Character]]>.Elements, String> {
        return self.trie.allInsertions.lazy.map({ String($0) })
    }
}
