//
//  SearchNormalizer.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import NaturalLanguage

enum SearchNormalizer { }

extension SearchNormalizer {
    static func latin(text input: String) -> StringRangeTrie {
        let trie = StringRangeTrie()
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .nameType])
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames, .omitOther]
        tagger.string = input
        tagger.enumerateTags(in: input.startIndex..<input.endIndex, unit: .word, scheme: .lexicalClass, options: options)
        { tag, range -> Bool in
            let word = input[range]
            let normalized = word.lowercased()
                .applyingTransform(.stripDiacritics, reverse: false)!
                .trimmingCharacters(in: .punctuationCharacters)
            trie.insert(normalized, marker: range)
            return true
        }
        return trie
    }
}
