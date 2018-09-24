//
//  SafariExtensionViewController.swift
//  Select Like A Boss
//
//  Created by Sergey Armodin on 24.09.2018.
//  Copyright © 2018 Sergei Armodin. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
