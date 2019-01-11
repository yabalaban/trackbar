//
//  ApplicationTracker.swift
//  time-tracker
//
//  Created by Alexander Balaban on 10/01/2019.
//  Copyright © 2019 Balaban. All rights reserved.
//

import Cocoa

protocol ApplicationTimeTrackerDelegate: AnyObject {
    func timeTracker(_ tracker: ApplicationTimeTracker, didUpdateFrontmostApplication: Application, withTotalSeconds: UInt)
    func timeTracker(_ tracker: ApplicationTimeTracker, didFinishTrackingApplication: Application, withTotalSeconds: UInt)
}

class ApplicationTimeTracker: NSObject {
    private var trackings: [BundleIdentifier: Tracking] = [:]
    private var applications: [String: Application] = [:]
    private var observation: NSKeyValueObservation?
    private weak var delegate: ApplicationTimeTrackerDelegate?
    
    init(delegate: ApplicationTimeTrackerDelegate, workspace: NSWorkspace = NSWorkspace.shared) {
        self.delegate = delegate
        super.init()
        self.observation = workspace.observe(\.frontmostApplication, options: [.old, .new]) { [weak self] (workspace, change) in
            let oldApp = change.oldValue ?? nil
            let newApp = change.newValue ?? nil
            self?.switchTracking(from: oldApp, to: newApp)
        }
    }
}

extension ApplicationTimeTracker {
    private func switchTracking(from oldApp: NSRunningApplication?, to newApp: NSRunningApplication?) {
        if let oldApp = oldApp {
            self.updateTracking(for: oldApp, started: false)
        }
        if let newApp = newApp {
            self.updateTracking(for: newApp, started: true)
        }
    }
    
    private func updateTracking(for app: NSRunningApplication, started: Bool) {
        guard let bundleIdentifier = app.bundleIdentifier else { print("Nothing to do here ¯\\_(ツ)_/¯"); return }
        let app = applications[bundleIdentifier] ?? Application(id: bundleIdentifier, icon: app.icon!, name: app.localizedName ?? "🥴")
        var tracking: Tracking
        if started {
            tracking = trackings[bundleIdentifier] ?? Tracking(startTs: Date().timeIntervalSince1970, totalSeconds: 0)
            tracking.startTs = Date().timeIntervalSince1970
            defer {
                self.delegate?.timeTracker(self, didUpdateFrontmostApplication: app, withTotalSeconds: tracking.totalSeconds)
            }
        } else {
            guard let appTracking = trackings[bundleIdentifier] else { print("What are you doing here?"); return }
            tracking = appTracking
            tracking.totalSeconds += max(1, UInt(round(Date().timeIntervalSince1970 - tracking.startTs)))
            defer {
                self.delegate?.timeTracker(self, didFinishTrackingApplication: app, withTotalSeconds: tracking.totalSeconds)
            }
        }
        self.trackings[bundleIdentifier] = tracking
        self.applications[bundleIdentifier] = app
    }
}
