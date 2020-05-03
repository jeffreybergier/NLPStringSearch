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

    private var searchWC: SearchWindowController = .newWC()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.searchWC.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

