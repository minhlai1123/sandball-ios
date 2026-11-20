import SwiftUI
import SpriteKit

public struct GameView: View {
    @ObservedObject public var sceneManager: SceneManager
    @ObservedObject public var progressManager: ProgressManager

    @State private var remainingQuota: Int = 10
    @State private var isVictory: Bool = false
    @State private var earnedStars: Int = 0
    @State private var gameScene: GameScene?

    public init(sceneManager: SceneManager, progressManager: ProgressManager = ProgressManager.shared) {
        self.sceneManager = sceneManager
        self.progressManager = progressManager
    }

    public var body: some View {
        ZStack {
            if let scene = gameScene {
                SpriteView(scene: scene)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }

            GameHUDView(
                title: "⭐ LEVEL \(sceneManager.currentLevelId) ⭐",
                remainingQuota: remainingQuota,
                isVictory: isVictory,
                earnedStars: earnedStars,
                onRestart: {
                    restartCurrentLevel()
                },
                onMenu: {
                    sceneManager.openMenu()
                },
                onNextLevel: {
                    let next = sceneManager.currentLevelId + 1
                    if next <= 100 {
                        sceneManager.startLevel(next)
                        setupScene(for: next)
                    } else {
                        sceneManager.openLevelSelect()
                    }
                }
            )
        }
        .onAppear {
            setupScene(for: sceneManager.currentLevelId)
        }
    }

    private func setupScene(for levelId: Int) {
        let scene = GameScene(size: CGSize(width: 1000, height: 1800), levelId: levelId, progressManager: progressManager)
        scene.scaleMode = .aspectFill
        scene.onQuotaUpdated = { quota in
            self.remainingQuota = quota
        }
        scene.onVictory = { stars in
            self.earnedStars = stars
            self.isVictory = true
        }
        scene.onLevelChanged = { newId in
            self.sceneManager.currentLevelId = newId
            self.isVictory = false
        }
        self.remainingQuota = 10
        self.isVictory = false
        self.gameScene = scene
    }

    private func restartCurrentLevel() {
        isVictory = false
        setupScene(for: sceneManager.currentLevelId)
    }
}
