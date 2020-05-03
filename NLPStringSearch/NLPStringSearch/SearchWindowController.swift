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

    // Article Text: https://www3.nhk.or.jp/news/html/20200501/k10012415011000.html
    override var searchableText: String { """
        関西電力は、福井県にある大飯原子力発電所３号機の定期検査の作業開始を新型コロナウイルスの感染防止のため２か月から３か月程度、延ばすことを決めました。

        およそ年１回の頻度で実施することが決まっている原発の定期検査では全国から作業員が集まります。

        福井県にある大飯原発３号機でも今月８日からの検査に県外から900人前後の作業員が集まる見通しで、福井県の杉本知事は先月、新型コロナウイルスの感染防止のため、福井に来る前に作業員は２週間の自宅待機を関西電力に求めるなどしていました。

        これに関して、大飯原発の文能一成所長が１日、地元の福井県おおい町を訪れ、定期検査の作業開始を２か月から３か月程度延ばす方針を伝えました。

        理由は、感染の拡大を防ぐためとしています。

        関西電力では、定期検査の開始時期については、今後、作業を請け負う協力会社などと調整したうえで決めるとしています。
        """
    }

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
