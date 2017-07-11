//
//  MessagePresenter.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/10/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import Foundation
import SwiftMessages

class MessagePresenter {

    func showMessage(success: Bool, message: String) {
        let view = MessageView.viewFromNib(layout: .CardView)
        var config = SwiftMessages.Config()
        config.dimMode = .gray(interactive: true)
        config.duration = .seconds(seconds: 1.5)
        view.button?.isHidden = true
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        if (success) {
            // Theme message elements with the warning style.
            view.configureTheme(.success)
            let iconText = "✅"
            view.configureContent(title: "Success", body: message, iconText: iconText)
            // Specify one or more event listeners to respond to show and hide events.
        } else {
            // Theme message elements with the warning style.
            view.configureTheme(.error)
            let iconText = "❌"
            view.configureContent(title: "Error", body: message, iconText: iconText)
        }
        
        // Show the message.
        SwiftMessages.show(config: config, view: view)

    }
}
