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
        for searchTerm in self.searchedTextTrie.allInsertions {
            for range in self.searchableTextTrie.markers(for: searchTerm) {
                text.addAttributes(searchedAttribs, range: NSRange(range, in: self.searchableText))
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
        self.searchableTextTrie = SearchNormalizer.ja_populatedTree(from: self.searchableText)
        super.windowDidLoad()
        self.window!.title = "日本語"
        self.window!.identifier = NSUserInterfaceItemIdentifier(rawValue: "日本語")
    }

    override func searchChanged(_ sender: NSSearchField) {
        self.searchedTextTrie = SearchNormalizer.ja_populatedTree(from: sender.stringValue)
        super.searchChanged(sender)
    }
}

class LatinSearchWindowController: SearchWindowController {

    override var searchableText: String { latin1 }

    override class func newWC() -> NSWindowController {
        return LatinSearchWindowController(windowNibName: NSNib.Name(stringLiteral: "SearchWindow"))
    }

    override func windowDidLoad() {
        self.searchableTextTrie = SearchNormalizer.populatedTree(from: self.searchableText)
        super.windowDidLoad()
        self.window!.title = "Latin"
        self.window!.identifier = NSUserInterfaceItemIdentifier(rawValue: "Latin")
    }

    override func searchChanged(_ sender: NSSearchField) {
        self.searchedTextTrie = SearchNormalizer.populatedTree(from: sender.stringValue)
        super.searchChanged(sender)
    }
}
