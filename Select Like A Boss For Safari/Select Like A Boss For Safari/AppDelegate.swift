//
//  AppDelegate.swift
//  Select Like A Boss For Safari
//
//  Created by Sergey Armodin on 24.09.2018.
//  Copyright © 2018 Sergei Armodin. All rights reserved.
//

import Cocoa

@main
@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
	private var mainWindowController: WindowController?
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		mainWindowController = NSApp.windows.first?.windowController as? WindowController
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	func registerMainWindowController(_ windowController: WindowController) {
		mainWindowController = windowController
	}
	
	@IBAction func showMainWindow(_ sender: Any?) {
		guard let windowController = resolveMainWindowController() else {
			return
		}
		NSApp.activate(ignoringOtherApps: true)
		windowController.showWindow(sender)
		windowController.window?.makeKeyAndOrderFront(sender)
	}

	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if flag {
			return false
		}
		showMainWindow(nil)
		return true
	}
	
	private func resolveMainWindowController() -> WindowController? {
		if let windowController = mainWindowController {
			return windowController
		}
		if let existingWindowController = NSApp.windows.compactMap({ $0.windowController as? WindowController }).first {
			mainWindowController = existingWindowController
			return existingWindowController
		}
		if let createdWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "WindowController") as? WindowController {
			mainWindowController = createdWindowController
			return createdWindowController
		}
		return nil
	}
}
