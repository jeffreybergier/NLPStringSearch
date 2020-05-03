//
//  TrieTests.swift
//  NLPStringSearchTests
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import XCTest
@testable import NLPStringSearch

class TrieTests: XCTestCase {

    let trie = Trie<Character, Int>(headValue: "•")

    override func setUp() {
        self.trie.insert(["h","e","l","l","o"], marker: 1)
        self.trie.insert(["h","e","l","l","o"], marker: 2)
        self.trie.insert(["h","e","l","p"], marker: 3)
        self.trie.insert(["g","o","o","g","l","e"], marker: 4)
        self.trie.insert(["カ","ン","サ","イ"], marker: 5)
        self.trie.insert(["カ","ン","パ","イ"], marker: 6)
    }

    func test_search() {
        _ = {
            let search = self.trie.markers(for: ["h"])
            XCTAssertEqual(search, Set([1, 2, 3]))
        }()
        _ = {
            let search = self.trie.markers(for: ["h","e","l"])
            XCTAssertEqual(search, Set([1, 2, 3]))
        }()
        _ = {
            let search = self.trie.markers(for: ["h","e","l", "p"])
            XCTAssertEqual(search, Set([3]))
        }()
        _ = {
            let search = self.trie.markers(for: ["h","e","l","l","o"])
            XCTAssertEqual(search, Set([1,2]))
        }()
        _ = {
            let search = self.trie.markers(for: ["g"])
            XCTAssertEqual(search, Set([4]))
        }()
        _ = {
            let search = self.trie.markers(for: ["g","o","o","g","l","e"])
            XCTAssertEqual(search, Set([4]))
        }()
        _ = {
            let search = self.trie.markers(for: ["カ"])
            XCTAssertEqual(search, Set([5,6]))
        }()
        _ = {
            let search = self.trie.markers(for: ["カ","ン","サ"])
            XCTAssertEqual(search, Set([5]))
        }()
        _ = {
            let search = self.trie.markers(for: ["カ","ン","パ"])
            XCTAssertEqual(search, Set([6]))
        }()
        _ = {
            let search = self.trie.markers(for: ["g","a","o","g","l","e"])
            XCTAssertTrue(search.isEmpty)
        }()
        _ = {
            let search = self.trie.markers(for: ["z"])
            XCTAssertTrue(search.isEmpty)
        }()
    }

}
