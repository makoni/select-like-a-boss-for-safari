//
//  WindowController.swift
//  Select Like A Boss For Safari
//
//  Created by Sergei Armodin on 15.11.2021.
//  Copyright © 2021 Sergei Armodin. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.tabbingMode = .disallowed
        (NSApp.delegate as? AppDelegate)?.registerMainWindowController(self)
    }


}
