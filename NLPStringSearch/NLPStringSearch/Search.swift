//
//  Search.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/02.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import NaturalLanguage
import Foundation

struct Search {

    static func japaneseToKatakana(_ input: String) -> String {
        let input = input as NSString
        return self.japaneseConvert(input: input, transform: kCFStringTransformLatinKatakana)
    }

    static func japaneseToLatin(_ input: String) -> String {
        let input = input as NSString
        return self.japaneseConvert(input: input, transform: kCFStringTransformToLatin)
    }

    private static func japaneseConvert(input: NSString, transform: CFString) -> String {
        let range = CFRange(location: 0, length: input.length)
        let locale = CFLocaleCreate(kCFAllocatorDefault, CFLocaleIdentifier("ja_JP" as CFString))!
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault,
                                                input as CFString,
                                                range,
                                                kCFStringTokenizerUnitWordBoundary,
                                                locale)
        var result = ""
        var tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)
        while tokenType.rawValue != 0 {
            let transcribed = CFStringTokenizerCopyCurrentTokenAttribute(
                tokenizer,
                kCFStringTokenizerAttributeLatinTranscription
                ) as? NSMutableString
            if let transcribed = transcribed {
                CFStringTransform(transcribed, nil, transform, false)
                result += transcribed as String
            } else {
                let _currentRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
                let currentRange = NSRange(location: _currentRange.location, length: _currentRange.length)
                let originalString = input.substring(with: currentRange)
                result += originalString
            }
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        return result
    }

    // Using NL Framework
    // Not needed because Tokenizer does two jobs in one
    /*
    static func words(from input: String) {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = input
        tokenizer.enumerateTokens(in: input.startIndex ..< input.endIndex)
        { (range, flags) -> Bool in
            print(input[range])
            return true
        }
    }
    */
}
