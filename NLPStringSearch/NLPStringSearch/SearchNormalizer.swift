//
//  SearchNormalizer.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import NaturalLanguage

enum SearchNormalizer {
    
    private static func normalize<S: StringProtocol>(_ input: S) -> String {
        return input
            .lowercased()
            .trimmingCharacters(in: .punctuationCharacters)
            .applyingTransform(.stripDiacritics, reverse: false)!
            .applyingTransform(.fullwidthToHalfwidth, reverse: true)!
    }

    static func populatedTree(from input: String) -> StringRangeTrie {
        let trie = StringRangeTrie()
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = input
        tokenizer.enumerateTokens(in: input.startIndex..<input.endIndex)
        { (range, _) -> Bool in
            let word = input[range]
            let normalized = self.normalize(word)
            trie.insert(normalized, marker: range)
            return true
        }
        return trie
    }
}
