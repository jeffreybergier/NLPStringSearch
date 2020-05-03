//
//  SearchWindowController.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/03.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import AppKit

class SearchWindowController: NSWindowController {

    class func newWC() -> SearchWindowController {
        return SearchWindowController(windowNibName: NSNib.Name(stringLiteral: "SearchWindow"))
    }

}
