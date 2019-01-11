//
//  TrackingScrubberItemView.swift
//  time-tracker
//
//  Created by Alexander Balaban on 11/01/2019.
//  Copyright © 2019 Balaban. All rights reserved.
//

import Cocoa

extension NSUserInterfaceItemIdentifier {
    static let trackingScrubberItem = NSUserInterfaceItemIdentifier(rawValue: "keep.it.simple.time-tracker.scrubber-tracking-item")
}

class TrackingScrubberItemView: NSScrubberItemView {
    struct Layout {
        static let imageSize: CGSize = .init(width: 30.0, height: 30.0)
        static let textViewSize: CGSize = .init(width: 80.0, height: 15.0)
        static var itemViewSize: CGSize {
            return CGSize(width: imageSize.width + textViewSize.width, height: imageSize.height)
        }
    }
    
    var applicationIconImageView: NSImageView
    var timingTextView: NSTextView
    var applicationNameTextView: NSTextView
    
    override init(frame frameRect: NSRect) {
        let applicationIconImageRect = NSRect(origin: .zero, size: Layout.imageSize)
        self.applicationIconImageView = NSImageView(frame: applicationIconImageRect)
        
        let timingTextViewRect = NSRect(origin: CGPoint(x: 30.0, y: 0.0), size: Layout.textViewSize)
        self.timingTextView = NSTextView(frame: timingTextViewRect)
        self.timingTextView.alignment = .natural
        
        let applicationNameTextViewRect = NSRect(origin: CGPoint(x: 30.0, y: 15.0), size: Layout.textViewSize)
        self.applicationNameTextView = NSTextView(frame: applicationNameTextViewRect)
        self.applicationNameTextView.alignment = .natural
        self.applicationNameTextView.textContainer?.maximumNumberOfLines = 1
        self.applicationNameTextView.textContainer?.lineBreakMode = .byTruncatingTail
        
        super.init(frame: NSRect(origin: .zero, size: Layout.itemViewSize))
        
        self.addSubview(applicationIconImageView)
        self.addSubview(timingTextView)
        self.addSubview(applicationNameTextView)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
