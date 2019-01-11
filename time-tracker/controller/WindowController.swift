//
//  WindowController.swift
//  time-tracker
//
//  Created by Alexander Balaban on 10/01/2019.
//  Copyright © 2019 Balaban. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    @IBOutlet weak var trackingsScrubber: NSScrubber!
    
    lazy var tracker = ApplicationTimeTracker(delegate: self)
    var timings: [Application: UInt] = [:]
    
    private var cachedApplications: [Application] = []
    var applications: [Application] {
        if self.cachedApplications.count == 0 {
            self.cachedApplications = timings.keys.sorted(by: { timings[$0]! > timings[$1]! })
        }
        return self.cachedApplications
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.trackingsScrubber.register(TrackingScrubberItemView.self, forItemIdentifier: .trackingScrubberItem)
        print(tracker)
    }
}

// MARK: - ApplicationTimeTrackerDelegate
extension WindowController: ApplicationTimeTrackerDelegate {
    func timeTracker(_ tracker: ApplicationTimeTracker, didUpdateFrontmostApplication application: Application, withTotalSeconds seconds: UInt) {
        self.timings[application] = seconds
        self.cachedApplications = []
        if application.id == NSRunningApplication.current.bundleIdentifier {
            self.trackingsScrubber.reloadData()
        }
    }
    
    func timeTracker(_ tracker: ApplicationTimeTracker, didFinishTrackingApplication application: Application, withTotalSeconds seconds: UInt) {
        self.timings[application] = seconds
    }
}

// MARK: - NSScrubberDataSource
extension WindowController: NSScrubberDataSource {
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return self.applications.count
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        guard let item = scrubber.makeItem(withIdentifier: .trackingScrubberItem, owner: self) as? TrackingScrubberItemView else { fatalError() }
        item.applicationNameTextView.string = applications[index].name
        item.applicationIconImageView.image = applications[index].icon
        if let seconds = timings[applications[index]], seconds > 0 {
            let hrs = seconds / 3600
            let ms = (seconds % 3600) / 60
            let scs = (seconds % 3600) % 60
            item.timingTextView.string = String(format: "%02d:%02d:%02d", hrs, ms, scs)
        } else {
            item.timingTextView.string = "¯\\_(ツ)_/¯"
        }
        return item
    }
}

// MARK: - NSScrubberFlowLayoutDelegate
extension WindowController: NSScrubberFlowLayoutDelegate {
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        return TrackingScrubberItemView.Layout.itemViewSize
    }
}
