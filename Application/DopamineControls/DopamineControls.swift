//
//  DopamineControls.swift
//  DopamineControls
//
//  Control Center controls (iOS 18+). They run the same App Intents as the Shortcuts
//  actions (DopamineIntents.swift is compiled into this target too); the intents
//  have openAppWhenRun = true, so the system runs them inside the app.
//

import WidgetKit
import SwiftUI
import AppIntents

struct DopamineJailbreakControl: ControlWidget {
    static let kind = "com.opa334.Dopamine.control.jailbreak"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: DopamineJailbreakIntent()) {
                Label("Jailbreak", systemImage: "bolt.fill")
            }
        }
        .displayName("Jailbreak")
        .description("Starts the jailbreak in Dopamine.")
    }
}

struct DopamineRespringControl: ControlWidget {
    static let kind = "com.opa334.Dopamine.control.respring"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: DopamineRespringIntent()) {
                Label("Respring", systemImage: "arrow.clockwise")
            }
        }
        .displayName("Respring")
        .description("Restarts SpringBoard.")
    }
}

struct DopamineRebootUserspaceControl: ControlWidget {
    static let kind = "com.opa334.Dopamine.control.reboot-userspace"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: DopamineRebootUserspaceIntent()) {
                Label("Reboot Userspace", systemImage: "arrow.clockwise.circle")
            }
        }
        .displayName("Reboot Userspace")
        .description("Reboots userspace.")
    }
}

@main
struct DopamineControlsBundle: WidgetBundle {
    var body: some Widget {
        DopamineJailbreakControl()
        DopamineRespringControl()
        DopamineRebootUserspaceControl()
    }
}
