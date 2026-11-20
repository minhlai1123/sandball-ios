import Foundation

public protocol LevelRepository {
    func getLevel(levelId: Int) -> SandAdventureLevel
    func getAvailableLevelCount() -> Int
}

public class BundleLevelRepository: LevelRepository {
    public init() {}

    public func getLevel(levelId: Int) -> SandAdventureLevel {
        let fileName = "level_\(levelId)"
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json", subdirectory: "Levels") ??
                     Bundle.main.url(forResource: fileName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let level = try? JSONDecoder().decode(SandAdventureLevel.self, from: data) {
            return level
        }
        return getFallbackLevel(levelId: levelId)
    }

    public func getAvailableLevelCount() -> Int {
        return 100
    }

    private func getFallbackLevel(levelId: Int) -> SandAdventureLevel {
        return SandAdventureLevel(
            levelId: levelId,
            worldId: 1,
            title: "Level \(levelId)",
            quota: 10,
            totalInitialBalls: 20,
            bounds: Bounds(width: 1000.0, height: 1800.0),
            sandRegions: [SandRegion(x: 0, y: 300, width: 1000, height: 1200, carvable: true)],
            ballSpawners: [BallSpawner(x: 500, y: 1650, count: 20, type: "colored", spreadRadius: 120)],
            obstacles: [
                ObstacleDef(id: "funnel_left", type: "funnel_bumper", x: 250, y: 260, width: 240, height: 40, rotationDegrees: -25),
                ObstacleDef(id: "funnel_right", type: "funnel_bumper", x: 750, y: 260, width: 240, height: 40, rotationDegrees: 25)
            ],
            collectibles: [],
            truck: TruckDef(x: 500, y: 120, width: 320, height: 150, quota: 10)
        )
    }
}
