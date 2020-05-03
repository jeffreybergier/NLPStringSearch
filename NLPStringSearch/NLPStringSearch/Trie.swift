//
//  Trie.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

class Trie<T: Hashable, U: Hashable> {
    private let head: Node
    init(headValue: T) {
        self.head = Node(value: headValue)
    }
}

extension Trie {
    class Node {
        var value: T
        var markers: Set<U>
        private(set) var children: [T:Node] = [:]
        init(value: T) {
            self.value = value
            self.markers = []
        }
        subscript(char: T) -> Node? {
            get { return self.children[char] }
            set { self.children[char] = newValue }
        }
    }
}

extension Trie {
    
    func insert(_ values: [T], marker: U) {
        var current = self.head
        for value in values {
            var next = current[value]
            if next == nil {
                next = Node(value: value)
                current[value] = next
            }
            current = next!
        }
        current.markers.insert(marker)
    }

    func markers(for search: [T]) -> Set<U> {
        // deep dive: finds remaining options after reaching end of string
        func dd(_ search: [T], _ node: Node) -> Set<U> {
            // base case, if there are no children, just return the search
            guard !node.children.isEmpty else { return node.markers }
            // otherwise dive deeper
            var output: Set<U> = node.markers
            for (nextValue, nextNode) in node.children {
                let nextSearch = search + [nextValue]
                let result = dd(nextSearch, nextNode)
                output.formUnion(result)
            }
            return output
        }
        // nearest node: finds the deepest node possible given search
        func nn(_ search: [T]) -> Node? {
            var node = self.head
            for value in search {
                // if we can't find a node for this char, we won't be able to go deeper
                guard let next = node[value] else { return nil }
                // otherwise keep going
                node = next
            }
            return node
        }

        guard let nearestNode = nn(search) else { return  [] }
        let options = dd(search, nearestNode)
        return options
    }
}
