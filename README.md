# Use NLP to Master Search in Japanese (and all other languages)

In this workshop we'll cover many of the complexities that make string search in Japanese so difficult. 
In the process you'll learn how to use the NLP (Natural Language Processing) features of the iOS SDK
to make impressive search algorithms, not only in Japanese, but any language.

### Basic Demo Video
[Demo Video](DemoVideo.mov)

## Stage 0

Class Discussion: How might we accomplish the demo video above? Lets brainstorm.

## What Makes String Search So Complex?

The computer is very strict when it comes to character matching. Swift does a lot of the work for us. So as long as a character looks the same on the screen (Glyph) then it will match. However, even thats too strict for us. For example humans would probably expect a search for `fiancee` to return a match for `fiancée`. However, that won't work with a normal substring search in Swift.

With Japanese, the complexity goes up enormously. The abstract from ["The Challenges of Intelligent Japanese Searching (知的日本語検索の諸課題)" by Jack Halpern](http://www.cjk.org/cjk/joa/joapaper.htm):
> The Japanese language, which is written in a mixture of four scripts, is said to have the most complex writing system in the world. Such factors as the lack of a standard orthography, the presence of numerous orthographic variants, and the morphological complexity of the language pose formidable challenges to the building of an intelligent Japanese search engine...

- [Typical Japanese article using all 4 writing systems](https://www6.nhk.or.jp/nhkpr/post/original.html?i=18855)
- [Rōmaji (ローマ字)](https://en.wikipedia.org/wiki/Romanization_of_Japanese)
- [Hiragana (ひらがな)](https://en.wikipedia.org/wiki/Hiragana)
- [Katakana (カタカナ)](https://en.wikipedia.org/wiki/Katakana)
- [Kanji (漢字)](https://en.wikipedia.org/wiki/Kanji)

A simple example of one type of complexity: Two totally different words with the same phoenetic spelling but different Kanjis is fairly common.
- Rain is `ame` in Rōmaji, `あめ` in Hiragana, `アメ` in Katakana, and `雨` in Kanji.
    - The "standard" form is the Kanji version at the end.
- Candy is `ame` in Rōmaji, `あめ` in Hiragana, `アメ` in Katakana, and `飴` in Kanji.
    - The "standard" form is the Kanji version at the end.

## Stage 1

The simplest way of doing search. We will just ask Swift to give us the range for a matching substring and then highlight it in the text.

``` swift
let normalAttribs: [NSAttributedString.Key : Any] = [
    .font : NSFont.systemFont(ofSize: 16)
]
let searchedAttribs: [NSAttributedString.Key : Any] = [
    .backgroundColor : NSColor.yellow,
    .font : NSFont.boldSystemFont(ofSize: 16)
]
let text = NSMutableAttributedString(string: self.searchableText, attributes: normalAttribs)
defer {
    self.textView.textStorage!.setAttributedString(text)
}
if let range = self.searchableText.range(of: self.searchedText) {
    text.addAttributes(searchedAttribs, range: NSRange(range, in: self.searchableText))
}
```
This works but has many problems. 
- It requires an exact string match
- It gives us only the first match

In order to improve it, we need to normalize it some way. The problem is that after normalizing it, the normalized version may be a different length than the original version. This means that getting a range from the normalized text will no longer match the same word in the original text. So we need a new data structure to keep track of this. 

## Stage 2

### The [Trie](https://en.wikipedia.org/wiki/Trie) Data Structure

This is a basic data structure that is great for string searching algorithms. For example, if you are building an autocomplete algorithm, you probably want to use Tries.

``` swift
class Node {
    var value: T // Character
    var markers: Set<U> // Set of Ranges
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
```
Normally a `BOOL` or a special character is used, as a marker, to indicate the end of a word. But in this case I'm using a `Set<U>` so that we can use any type to indicate the end of a word. In our app we will use `Swift.Range<String.Index>` so that we can keep track of where in the original string our word was that is represented by this word in the trie.

Also the Trie I implented is totally generic. So its API is not ideal for Strings. I wrote a little wrapper called `StringRangeTrie` that improves the API for Strings while still maintains a totally flexible Trie data structure for other uses.

Lets take a look at the implementations to together. Specifically inserting and retrieving words. Insertion is fairly simple, but retrieving words is a little trickier. Especially because this is an "autocomplete" style search where we want to dive past the input given by the user and see all possible options that match the given query prefix.

Also, right now we have a problem. We need to break up our original strings into words so we can feed the Trie structure. This is where we get into the exciting world of NLP. We'll do that next.

## Stage 3

### [Natural Language](https://developer.apple.com/documentation/naturallanguage) Framework and [NLTokenizer](https://developer.apple.com/documentation/naturallanguage/nltokenizer)

This framework is Apple's latest and greatest framework for doing natural language processing. You may remember `NSLinguisticTagger`. That API still works but has been fully replaced by `NLTokenizer` and `NLTagger`.

`NLTokenizer` is going to break up text into words for us. Later we'll use `NLTagger` to do more complex things like get the "lemma" of a word to make our search better.

``` swift
import NaturalLanguage

enum SearchNormalizer {
    static func populatedTree(from input: String) -> StringRangeTrie {
        let trie = StringRangeTrie()
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = input
        tokenizer.enumerateTokens(in: input.startIndex..<input.endIndex)
        { (range, _) -> Bool in
            let word = input[range]
            trie.insert(word, marker: range)
            return true
        }
        return trie
    }
}
```
Then in our Window Controller class we can update things a little bit. Take a look at the [diff](https://github.com/jeffreybergier/NLPStringSearch/commit/deb838669e82bb017c1e4985ad4c256ab7a416a3). They break down into the following:

1. On Window Load we build a tree of the Searchable Text.
    1. This is important because this building step is slow with the NLP because we might have a lot of text to process, but once its built, search is super fast because of the trie data structure
1. When the user searches we build a new trie just with the searched words
    1. Because the amount of text in the search is small, this is fast.
1. Then we use feed the `allInsertions` into the `markersFor:` function of the trie to retrieve our results and add color to our attributed string.

Now run the app. This is pretty convincing and it works in Japanese and all other supported languages. However, we still have an issue where we need to normalize our search. Right now, the case, accents, kanji, etc all matter. We want to remove those restrictions.

## Stage 4

In our previous stage we had search working but it was too restrictive. We had found the words in our text but we had not normalized everything into a regular form that made searching "fuzzier." Some examples of normalization below:

- Case
    - Tom Cruise → tom cruise
- Diacritic Marks
    - Café → Cafe
    - die Löwen → die Lowen / die Loewen
- Japanese Romanization
    - 関西 → kansai
    - エレベーター → erebētā
- Kana Width
    - ｶﾀｶﾅ → カタカナ
    
    Its important to remember that these are not translations and they are not even "correct." We won't show this to the user. This is just an internal representation for our algorithms. It makes searching more flexible for the user. The important thing isn't accuracy, its that we run both the Search term and the Searchable text through the same normalization algorithm. Thats one reason we use the same `SearchNormalizer` function for both sets of text.
    
``` swift
enum SearchNormalizer {
    private static func normalize<S: StringProtocol>(_ input: S) -> String {
        return input
            .lowercased()
            .trimmingCharacters(in: .punctuationCharacters)
            .applyingTransform(.stripDiacritics, reverse: false)!
            .applyingTransform(.fullwidthToHalfwidth, reverse: true)!
    }
}
```

Now this doesn't solve the hardest problem we have with Japanese, romanization. Right now, to search in Japanese we have to type the exact correct kanjis and other characters. I originally thought that the `.toLatin` transform above would transform Japanese but it seems to interpret the kanjis as Chinese characters and convert to a Chinese romanization which is not helpful. To do it in Japanese, I had to switch to older ways of tokenizing... all the way back to Core Foundation. So lets do it.
    
## Stage 5 (Current Stage)

Unfortunately there are no new API's from Apple that allow us to Romanize Japanese text. Also, the feature of iOS that does the romanization also does the tokenization. So for Japanese we end up not using the Natural Language framework at all. Basically we're going to use Core Foundation API's to tokenize and romanize the words in Japanese all at once. Sorry, this is a lot of code, but its doing essentially the same thing as before but with an older API.

``` swift
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
}
```

Note that I inserted both the original term and the romanized term into the trie in this one. One of the coolest things about the trie is it hides all the complexity from the user. As long as we think the search term is related, we can insert it into the trie and use it to help the user find things. Now in this case, this search might almost be too flexible. Returning erroneous results. For example I searched 天 (ten) (heaven) and it matches テニス (tenisu) (tennis). The amount of flexibility depends on our implementation. We can turn it up and down by modifying our normalization techniques.
