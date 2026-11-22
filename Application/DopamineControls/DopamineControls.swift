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
                Label("Jailbreak", systemImage: "door.left.hand.open")
            }
        }
        .displayName("Jailbreak")
        .description("Gift some dopamine to your phone.")
    }
}

struct DopamineRespringControl: ControlWidget {
    static let kind = "com.opa334.Dopamine.control.respring"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: DopamineRespringIntent()) {
                Label("Respring", systemImage: "sun.haze")
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
                Label("Reboot Userspace", systemImage: "wake")
            }
        }
        .displayName("Reboot Userspace")
        .description("Reboots your phone, but without removing the jailbreak.")
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
