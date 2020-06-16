//
//  Event.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 12/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation

class Event<T> {

    var content: T
    private var hasBeenHandled = false
    
    init(content: T) {
        self.content = content
    }

    /**
     * Returns the content and prevents its use again.
     */
    func getContentIfNotHandled() -> T? {
        if (hasBeenHandled) {
            return nil
        } else {
            self.hasBeenHandled = true
            return content
        }
    }
}
