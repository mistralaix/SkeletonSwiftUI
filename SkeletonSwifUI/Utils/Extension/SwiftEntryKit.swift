//
//  SwiftEntryKit.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 16/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation
import SwiftEntryKit

extension SwiftEntryKit {
    
    static func showAlertMessage(message: String, duration: Double? = nil) {
        
        DispatchQueue.main.async {
            
            var attributes = EKAttributes.topNote
            
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = .none
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: .standardBackground)
            attributes.shadow = .active(with: .init(opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            
            if let duration = duration {
                attributes.displayDuration = duration
            }
            
            let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 15), color: .standardContent, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: message, style: style)
            
            let contentView = EKNoteMessageView(with: labelContent)
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    static func showSuccessMessage(message: String) {
        DispatchQueue.main.async {
            
            var attributes = EKAttributes.topNote
            
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = .success
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: .init(UIColor(red:0.315, green:0.783, blue:0.473, alpha:1.000)))
            attributes.shadow = .active(with: .init(opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            
            let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 15), color: .white, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: message, style: style)
            
            let contentView = EKNoteMessageView(with: labelContent)
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    static func showErrorMessage(message: String) {
        DispatchQueue.main.async {
            
            var attributes = EKAttributes.topNote
            
            attributes.name = "Top Note"
            attributes.hapticFeedbackType = EKAttributes.NotificationHapticFeedback.error
            attributes.popBehavior = .animated(animation: .translation)
            attributes.entryBackground = .color(color: .init(UIColor(red:0.998, green:0.390, blue:0.280, alpha:1.000)))
            attributes.shadow = .active(with: .init(opacity: 0.5, radius: 2))
            attributes.statusBar = .light
            
            let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 15), color: .white, alignment: .center)
            let labelContent = EKProperty.LabelContent(text: message, style: style)
            
            let contentView = EKNoteMessageView(with: labelContent)
            
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
}
