//
//  SearchNormalizerTests.swift
//  NLPStringSearchTests
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import XCTest
@testable import NLPStringSearch

class EnglishNormalizerTests: XCTestCase {

    // Article Text: https://www.bbc.co.uk/news/uk-52517996
    let inputString = """
        Boris Johnson has revealed "contingency plans" were made while he was seriously ill in hospital with coronavirus.
        In an interview with the Sun on Sunday, the PM says he was given "litres and litres of oxygen" to keep him alive.
        He says his week in London's St Thomas' Hospital left him driven by a desire to both stop others suffering and to get the UK "back on its feet".
        Earlier, his fiancée, Carrie Symonds, revealed they had named their baby boy Wilfred Lawrie Nicholas Johnson.
        The names are a tribute to their grandfathers and two doctors who treated Mr Johnson while he was in hospital with coronavirus, Ms Symonds wrote in an Instagram post.
        The boy was born on Wednesday, just weeks after Mr Johnson's discharge from intensive care.
        In his newspaper interview, the prime minister describes being wired up to monitors and finding the "indicators kept going in the wrong direction".
        "It was a tough old moment, I won't deny it," he's quoted as saying, adding that he kept asking himself: "How am I going to get out of this?"
        """

    lazy var trie: StringRangeTrie = SearchNormalizer.latin(text: inputString)

    func test_borisSearch() {
        _ = {
            let search = self.trie.markers(for: "boris johnson")
            XCTAssertEqual(search.count, 1)
            XCTAssertEqual(inputString[search.first!], "Boris Johnson")
        }()
        _ = {
            let search = self.trie.markers(for: "fiancee")
            XCTAssertEqual(search.count, 1)
            XCTAssertEqual(inputString[search.first!], "fiancée")
        }()

        _ = {
            let search = self.trie.markers(for: "the")
            XCTAssertEqual(search.count, 11)
        }()
    }

}
