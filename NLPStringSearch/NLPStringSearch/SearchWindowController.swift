//
//  SearchWindowController.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import AppKit

class SearchWindowController: NSWindowController {

    @IBOutlet private weak var textView: NSTextView!

    var searchedTextTrie = StringRangeTrie()
    var searchableTextTrie = StringRangeTrie()
    var searchableText: String { "" }

    class func newWC() -> NSWindowController {
        return SearchWindowController(windowNibName: NSNib.Name(stringLiteral: "SearchWindow"))
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.update()
    }

    @IBAction func searchChanged(_ sender: NSSearchField) {
        self.update()
    }

    private func update() {
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
        let searchTerms = searchedTextTrie.allInsertions
        for searchTerm in searchTerms {
            let markers = self.searchableTextTrie.markers(for: searchTerm)
            for range in markers {
                text.setAttributes(searchedAttribs, range: NSRange(range, in: self.searchableText))
            }
        }
    }
}

class JapaneseSearchWindowController: SearchWindowController {

    override var searchableText: String { japanese1 }

    override class func newWC() -> NSWindowController {
        return JapaneseSearchWindowController(windowNibName: NSNib.Name(stringLiteral: "SearchWindow"))
    }

    override func windowDidLoad() {
        self.searchableTextTrie = SearchNormalizer.japanese(text: self.searchableText)
        super.windowDidLoad()
        self.window!.title = "日本語"
        self.window!.identifier = NSUserInterfaceItemIdentifier(rawValue: "日本語")
    }

    override func searchChanged(_ sender: NSSearchField) {
        self.searchedTextTrie = SearchNormalizer.japanese(text: sender.stringValue)
        super.searchChanged(sender)
    }
}

class LatinSearchWindowController: SearchWindowController {

    // Article Text: https://www.bbc.co.uk/news/uk-52517996
    override var searchableText: String { """
        Boris Johnson has revealed "contingency plans" were made while he was seriously ill in hospital with coronavirus.
        In an interview with the Sun on Sunday, the PM says he was given "litres and litres of oxygen" to keep him alive.
        He says his week in London's St Thomas' Hospital left him driven by a desire to both stop others suffering and to get the UK "back on its feet".
        Earlier, his fiancée, Carrie Symonds, revealed they had named their baby boy Wilfred Lawrie Nicholas Johnson.
        The names are a tribute to their grandfathers and two doctors who treated Mr Johnson while he was in hospital with coronavirus, Ms Symonds wrote in an Instagram post.
        The boy was born on Wednesday, just weeks after Mr Johnson's discharge from intensive care.
        In his newspaper interview, the prime minister describes being wired up to monitors and finding the "indicators kept going in the wrong direction".
        "It was a tough old moment, I won't deny it," he's quoted as saying, adding that he kept asking himself: "How am I going to get out of this?"
        """
    }

    override class func newWC() -> NSWindowController {
        return LatinSearchWindowController(windowNibName: NSNib.Name(stringLiteral: "SearchWindow"))
    }

    override func windowDidLoad() {
        self.searchableTextTrie = SearchNormalizer.latin(text: self.searchableText)
        super.windowDidLoad()
        self.window!.title = "Latin"
        self.window!.identifier = NSUserInterfaceItemIdentifier(rawValue: "Latin")
    }

    override func searchChanged(_ sender: NSSearchField) {
        self.searchedTextTrie = SearchNormalizer.latin(text: sender.stringValue)
        super.searchChanged(sender)
    }
}
