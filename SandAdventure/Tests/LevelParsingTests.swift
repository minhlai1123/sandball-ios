import XCTest
@testable import SandAdventure

final class LevelParsingTests: XCTestCase {

    let sampleJson = """
    {
      "levelId": 1,
      "worldId": 1,
      "title": "First Dig",
      "quota": 10,
      "totalInitialBalls": 20,
      "bounds": { "width": 1000.0, "height": 1800.0 },
      "sandRegions": [
        { "x": 0.0, "y": 300.0, "width": 1000.0, "height": 1200.0, "carvable": true }
      ],
      "ballSpawners": [
        { "x": 500.0, "y": 1650.0, "count": 20, "type": "colored", "spreadRadius": 120.0 }
      ],
      "obstacles": [
        { "id": "funnel_left", "type": "funnel_bumper", "x": 250.0, "y": 260.0, "width": 240.0, "height": 40.0, "rotationDegrees": -25.0, "motorSpeed": 0.0, "restitution": 0.3 }
      ],
      "collectibles": [],
      "truck": { "x": 500.0, "y": 120.0, "width": 320.0, "height": 150.0, "quota": 10 }
    }
    """

    func testLevelParsingSuccess() throws {
        let level = try SandAdventureLevel.from(jsonString: sampleJson)
        XCTAssertEqual(level.levelId, 1)
        XCTAssertEqual(level.worldId, 1)
        XCTAssertEqual(level.title, "First Dig")
        XCTAssertEqual(level.quota, 10)
        XCTAssertEqual(level.totalInitialBalls, 20)
        XCTAssertEqual(level.bounds.width, 1000.0)
        XCTAssertEqual(level.bounds.height, 1800.0)
        XCTAssertEqual(level.sandRegions.count, 1)
        XCTAssertEqual(level.ballSpawners.count, 1)
        XCTAssertEqual(level.ballSpawners[0].count, 20)
        XCTAssertEqual(level.ballSpawners[0].type, "colored")
        XCTAssertEqual(level.obstacles.count, 1)
        XCTAssertEqual(level.truck.x, 500.0)
        XCTAssertEqual(level.truck.quota, 10)
    }

    func testLevelRepository100Count() {
        let repo = BundleLevelRepository()
        XCTAssertEqual(repo.getAvailableLevelCount(), 100)
    }

    func testAll100LevelsIntegrity() {
        for i in 1...100 {
            let path = "ios/SandAdventure/Resources/Levels/level_\(i).json"
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                do {
                    let level = try JSONDecoder().decode(SandAdventureLevel.self, from: data)
                    XCTAssertEqual(level.levelId, i)
                    XCTAssertTrue(level.quota > 0)
                    XCTAssertTrue(level.totalInitialBalls >= level.quota)
                    XCTAssertFalse(level.ballSpawners.isEmpty)
                } catch {
                    XCTFail("Failed to decode level_\(i).json: \(error)")
                }
            }
        }
    }
}
