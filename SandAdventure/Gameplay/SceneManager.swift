import Foundation

public enum GameState {
    case menu
    case levelSelect
    case playing
    case levelComplete
    case levelFailed
    case settings
}

public class SceneManager: ObservableObject {
    @Published public var currentState: GameState = .menu
    @Published public var currentLevelId: Int = 1

    public init() {}

    public func startLevel(_ levelId: Int) {
        currentLevelId = levelId
        currentState = .playing
    }

    public func completeLevel() {
        currentState = .levelComplete
    }

    public func failLevel() {
        currentState = .levelFailed
    }

    public func openMenu() {
        currentState = .menu
    }

    public func openLevelSelect() {
        currentState = .levelSelect
    }

    public func openSettings() {
        currentState = .settings
    }
}
