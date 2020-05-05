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

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
	@IBAction func goToPreferenciesButtonTouched(_ sender: Any) {
		SFSafariApplication.showPreferencesForExtension(withIdentifier: "me.spaceinbox.Select-Like-A-Boss-For-Safari.Select-Like-A-Boss") { (error) in
			if let error = error {
				print(error.localizedDescription)
			}
		}
	}
	

}

