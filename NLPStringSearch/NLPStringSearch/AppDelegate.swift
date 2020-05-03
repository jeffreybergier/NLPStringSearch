//
//  AppDelegate.swift
//  NLPStringSearch
//
//  Created by Jeffrey Bergier on 2020/05/02.
//  Copyright © 2020 Jeffrey Bergier. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var japaneseWC: NSWindowController = JapaneseSearchWindowController.newWC()
    private var latinWC: NSWindowController = LatinSearchWindowController.newWC()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.japaneseWC.showWindow(nil)
        self.latinWC.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

