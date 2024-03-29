//
//  AppDelegate.swift
//  Select Like A Boss For Safari
//
//  Created by Sergey Armodin on 24.09.2018.
//  Copyright © 2018 Sergei Armodin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if let windowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "WindowController") as? WindowController {
			windowController.window?.makeKeyAndOrderFront(nil)
			return true
		}
		return false
	}
}

