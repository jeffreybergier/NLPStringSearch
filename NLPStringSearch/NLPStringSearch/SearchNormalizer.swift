//
//  SearchNormalizer.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import NaturalLanguage

enum SearchNormalizer {

    static func ja_populatedTree(from _input: String) -> StringRangeTrie {
        let input = _input as NSString
        let locale = CFLocaleCreate(kCFAllocatorDefault,
                                    CFLocaleIdentifier("ja_JP" as CFString))!
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault,
                                                input as CFString,
                                                CFRange(location: 0, length: input.length),
                                                kCFStringTokenizerUnitWord,
                                                locale)
        let trie = StringRangeTrie()
        var tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)
        while tokenType.rawValue != 0 {
            defer {
                tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
            }
            let cfRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let objcRange = NSRange(location: cfRange.location, length: cfRange.length)
            // this can be NIL for complex Emojis and other characters
            guard let swiftRange = Range(objcRange, in: _input) else { continue }
            let original = input.substring(with: objcRange)
            let romanized = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription) as? String
            trie.insert(self.normalize(original), marker: swiftRange)
            if let romanized = romanized {
                trie.insert(self.normalize(romanized), marker: swiftRange)
            }
        }
        return trie
    }
    
    private static func normalize<S: StringProtocol>(_ input: S) -> String {
        return input
            .lowercased()
            .trimmingCharacters(in: .punctuationCharacters)
            .applyingTransform(.stripDiacritics, reverse: false)!
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
