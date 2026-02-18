//
//  SafariExtensionHandler.swift
//  Select Like A Boss
//
//  Created by Sergey Armodin on 24.09.2018.
//  Copyright © 2018 Sergei Armodin. All rights reserved.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem
        let message: Any?
        if #available(iOS 15.0, macOS 11.0, *) {
            message = request?.userInfo?[SFExtensionMessageKey]
        } else {
            message = request?.userInfo?["message"]
        }
        
        os_log(.default, "Received native message: %@", String(describing: message))
        
        let response = NSExtensionItem()
        if #available(iOS 15.0, macOS 11.0, *) {
            response.userInfo = [SFExtensionMessageKey: ["echo": message as Any]]
        } else {
            response.userInfo = ["message": ["echo": message as Any]]
        }
        
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}
