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

    typealias NormalizedLookup = (String, Range<String.Index>)

    static func japaneseToKatakana(_ input: String) -> [NormalizedLookup] {
        return self.japaneseConvert(input: input, transform: kCFStringTransformLatinKatakana)
    }

    static func japaneseToLatin(_ input: String) -> [NormalizedLookup] {
        return self.japaneseConvert(input: input, transform: kCFStringTransformToLatin)
    }

    private static func japaneseConvert(input _input: String, transform: CFString) -> [NormalizedLookup] {
        let input = _input as NSString
        let range = CFRange(location: 0, length: input.length)
        let locale = CFLocaleCreate(kCFAllocatorDefault, CFLocaleIdentifier("ja_JP" as CFString))!
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault,
                                                input as CFString,
                                                range,
                                                kCFStringTokenizerUnitWord,
                                                locale)
        var result: [NormalizedLookup] = []
        var tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)
        while tokenType.rawValue != 0 {
            // this range code is dangerous because NSString and Swift.String
            // have different concepts of what a character is.
            // Refer to: https://talk.objc.io/episodes/S01E80-swift-string-vs-nsstring
            let _cr = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let objcRange = NSRange(location: _cr.location, length: _cr.length)
            let swiftRange = Range(objcRange, in: _input)!
            let transcribed = CFStringTokenizerCopyCurrentTokenAttribute(
                tokenizer,
                kCFStringTokenizerAttributeLatinTranscription
                ) as? NSMutableString
            if let transcribed = transcribed {
                CFStringTransform(transcribed, nil, transform, false)
                let lookup = ((transcribed as String), swiftRange)
                result.append(lookup)
            } else {
                let originalString = input.substring(with: objcRange)
                let lookup = (originalString, swiftRange)
                result.append(lookup)
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
