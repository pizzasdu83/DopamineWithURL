//
//  DopamineIntents.swift
//  Dopamine
//
//  App Intents so the Shortcuts app can trigger Dopamine actions.
//  Each intent simply opens the matching dopamine:// URL, which is handled
//  by DOSceneDelegate (so cold launch and warm launch share the same path).
//

import AppIntents
import UIKit

@available(iOS 16.0, *)
@MainActor
enum DopamineIntentRouter {
    static func open(_ host: String) {
        guard let url = URL(string: "dopamine://\(host)") else { return }
        // Give the scene a moment to become active (cold launch via Shortcuts).
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            UIApplication.shared.open(url)
        }
    }
}

@available(iOS 16.0, *)
struct DopamineJailbreakIntent: AppIntent {
    static var title: LocalizedStringResource = "Jailbreak"
    static var description = IntentDescription("Starts the jailbreak in Dopamine.")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        DopamineIntentRouter.open("jailbreak")
        return .result()
    }
}

@available(iOS 16.0, *)
struct DopamineRespringIntent: AppIntent {
    static var title: LocalizedStringResource = "Respring"
    static var description = IntentDescription("Restarts SpringBoard (requires an active jailbreak).")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        DopamineIntentRouter.open("respring")
        return .result()
    }
}

@available(iOS 16.0, *)
struct DopamineRebootUserspaceIntent: AppIntent {
    static var title: LocalizedStringResource = "Reboot Userspace"
    static var description = IntentDescription("Reboots userspace (requires an active jailbreak).")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        DopamineIntentRouter.open("reboot-userspace")
        return .result()
    }
}

@available(iOS 16.4, *)
struct DopamineShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: DopamineJailbreakIntent(),
                    phrases: ["Jailbreak with \(.applicationName)"],
                    shortTitle: "Jailbreak",
                    systemImageName: "bolt.fill")
        AppShortcut(intent: DopamineRespringIntent(),
                    phrases: ["Respring with \(.applicationName)"],
                    shortTitle: "Respring",
                    systemImageName: "arrow.clockwise")
        AppShortcut(intent: DopamineRebootUserspaceIntent(),
                    phrases: ["Reboot userspace with \(.applicationName)"],
                    shortTitle: "Reboot Userspace",
                    systemImageName: "arrow.clockwise.circle")
    }
}
