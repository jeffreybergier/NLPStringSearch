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

    static func japanese(text _input: String) -> StringRangeTrie {
        let input = _input as NSString
        let range = CFRange(location: 0, length: input.length)
        let locale = CFLocaleCreate(kCFAllocatorDefault, CFLocaleIdentifier("ja_JP" as CFString))!
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault,
                                                input as CFString,
                                                range,
                                                kCFStringTokenizerUnitWord,
                                                locale)
        let trie = StringRangeTrie()
        var tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)
        while tokenType.rawValue != 0 {
            defer {
                tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
            }
            // this range code is dangerous because NSString and Swift.String
            // have different concepts of what a character is.
            // Refer to: https://talk.objc.io/episodes/S01E80-swift-string-vs-nsstring
            let _cr = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let objcRange = NSRange(location: _cr.location, length: _cr.length)
            guard let swiftRange = Range(objcRange, in: _input) else { continue }
            let romanized = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription) as? String
            let insert = romanized ?? input.substring(with: objcRange)
            trie.insert(insert, marker: swiftRange)
        }
        return trie
    }

    static func latin(text input: String) -> StringRangeTrie {
        let trie = StringRangeTrie()
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .nameType])
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames, .omitOther]
        tagger.string = input
        tagger.enumerateTags(in: input.startIndex..<input.endIndex,
                             unit: .word, scheme: .lexicalClass,
                             options: options)
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
