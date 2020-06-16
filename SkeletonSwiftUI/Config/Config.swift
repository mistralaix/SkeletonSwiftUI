//
//  Config.swift
//  SkeletonSwifUI
//
//  Created by cyril chaillan on 16/06/2020.
//  Copyright © 2020 Devid. All rights reserved.
//

import Foundation

public enum Config {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let ROOT_URL = "ROOT_URL"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let ROOT_URL: String = {
        guard let rootURLstring = Config.infoDictionary[Keys.Plist.ROOT_URL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return rootURLstring
    }()
}
