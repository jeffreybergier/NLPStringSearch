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

## Stage 2 (Current Stage)

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


