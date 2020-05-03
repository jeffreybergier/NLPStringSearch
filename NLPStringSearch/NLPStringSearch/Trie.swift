//
//  Trie.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

class Trie {
    func populate(word: String, endOfWordMarker: [Range<String.Index>]) {

    }
    func markers(forStringPrefix: String) -> [Range<String.Index>] {
        return []
    }
}

extension Trie {
    class Node<T: Hashable, U> {
        let value: T
        let endOfWordMarker: U?
        private(set) var children: [T:Node] = [:]
        init(value: T, endOfWordMarker: U? = nil) {
            self.value = value
            self.endOfWordMarker = endOfWordMarker
        }
        subscript(char: T) -> Node? {
            get { return self.children[char] }
            set { self.children[char] = newValue }
        }
    }
}
