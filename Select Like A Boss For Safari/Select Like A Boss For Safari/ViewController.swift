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
	@IBOutlet private weak var openPreferencesButton: NSButton!
	
	private let extensionIdentifier = "me.spaceinbox.Select-Like-A-Boss-For-Safari.Select-Like-A-Boss"
	private let enableInstructionsText = NSLocalizedString(
		"host.instructions.enable",
		tableName: nil,
		bundle: .main,
		value: "Enable in Safari:\n1. Open Safari -> Preferences -> Extensions\n2. Turn on Select Like A Boss",
		comment: "Instructions shown when Safari extension is not enabled."
	)
	private let extensionEnabledText = NSLocalizedString(
		"host.instructions.enabled",
		tableName: nil,
		bundle: .main,
		value: "Safari extension is enabled. You are all set.",
		comment: "Confirmation shown when Safari extension is enabled."
	)
	private let openExtensionsButtonTitle = NSLocalizedString(
		"host.button.openExtensions",
		tableName: nil,
		bundle: .main,
		value: "Open Safari Extensions",
		comment: "Button title that opens Safari extension preferences."
	)

	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(appDidBecomeActive),
			name: NSApplication.didBecomeActiveNotification,
			object: nil
		)
		openPreferencesButton.title = openExtensionsButtonTitle
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
					self.instructionsLabel.stringValue = self.enableInstructionsText
					return
				}
				
				if state?.isEnabled == true {
					self.instructionsLabel.stringValue = self.extensionEnabledText
				} else {
					self.instructionsLabel.stringValue = self.enableInstructionsText
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
