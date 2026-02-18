//
//  ViewController.swift
//  Select Like A Boss For Safari
//
//  Created by Sergey Armodin on 24.09.2018.
//  Copyright © 2018 Sergei Armodin. All rights reserved.
//

import Cocoa
import SafariServices

class ViewController: NSViewController {
	@IBOutlet private weak var instructionsLabel: NSTextField!
	
	private let extensionIdentifier = "me.spaceinbox.Select-Like-A-Boss-For-Safari.Select-Like-A-Boss"

	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(appDidBecomeActive),
			name: NSApplication.didBecomeActiveNotification,
			object: nil
		)
		updateInstructionsFromExtensionState()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc private func appDidBecomeActive() {
		updateInstructionsFromExtensionState()
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	
	private func updateInstructionsFromExtensionState() {
		SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionIdentifier) { [weak self] state, error in
			DispatchQueue.main.async {
				guard let self else { return }
				if error != nil {
					self.instructionsLabel.stringValue = """
					Enable in Safari:
					1. Open Safari -> Preferences -> Extensions
					2. Turn on Select Like A Boss
					"""
					return
				}
				
				if state?.isEnabled == true {
					self.instructionsLabel.stringValue = "Safari extension is enabled. You are all set."
				} else {
					self.instructionsLabel.stringValue = """
					Enable in Safari:
					1. Open Safari -> Preferences -> Extensions
					2. Turn on Select Like A Boss
					"""
				}
			}
		}
	}
	
	@IBAction func goToPreferenciesButtonTouched(_ sender: Any) {
		SFSafariApplication.showPreferencesForExtension(withIdentifier: extensionIdentifier) { [weak self] (error) in
			if let error = error {
				print(error.localizedDescription)
			}
			self?.updateInstructionsFromExtensionState()
		}
	}
	

}
