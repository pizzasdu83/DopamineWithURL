//
//  DopamineControls.swift
//  DopamineControls
//
//  Control Center controls (iOS 18+). Each one opens the Dopamine app through
//  its URL scheme; DOSceneDelegate then performs the action.
//

import WidgetKit
import SwiftUI
import AppIntents

struct DopamineJailbreakControl: ControlWidget {
    static let kind = "com.opa334.Dopamine.control.jailbreak"

    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: Self.kind) {
            ControlWidgetButton(action: OpenURLIntent(URL(string: "dopamine://jailbreak")!)) {
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
            ControlWidgetButton(action: OpenURLIntent(URL(string: "dopamine://respring")!)) {
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
            ControlWidgetButton(action: OpenURLIntent(URL(string: "dopamine://reboot-userspace")!)) {
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
