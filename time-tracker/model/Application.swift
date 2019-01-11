//
//  Application.swift
//  time-tracker
//
//  Created by Alexander Balaban on 10/01/2019.
//  Copyright © 2019 Balaban. All rights reserved.
//

import AppKit

typealias BundleIdentifier = String

struct Application {
    let id: BundleIdentifier
    let icon: NSImage
    let name: String
}

extension Application: Hashable {
    var hashValue: Int {
        return id.hashValue
    }
}
