import SwiftUI

public struct ContentView: View {
    @StateObject private var sceneManager = SceneManager()
    @StateObject private var progressManager = ProgressManager.shared

    public init() {}

    public var body: some View {
        Group {
            switch sceneManager.currentState {
            case .menu:
                MainMenuView(sceneManager: sceneManager, progressManager: progressManager)
            case .levelSelect:
                LevelSelectView(sceneManager: sceneManager, progressManager: progressManager)
            case .settings:
                SettingsView(sceneManager: sceneManager, progressManager: progressManager)
            case .playing, .levelComplete, .levelFailed:
                GameView(sceneManager: sceneManager, progressManager: progressManager)
            }
        }
        .preferredColorScheme(.light)
    }
}
