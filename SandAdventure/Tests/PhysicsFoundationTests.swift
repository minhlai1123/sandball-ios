import XCTest
@testable import SandAdventure

final class PhysicsFoundationTests: XCTestCase {

    func testSpatialGrid100BallsInsertionAndCandidates() {
        let grid = SpatialGrid(worldWidth: 1000.0, worldHeight: 1800.0, cellSize: 50.0)

        for i in 1...100 {
            let x = CGFloat(i * 9 % 1000)
            let y = CGFloat(i * 17 % 1800)
            grid.insert(id: i, x: x, y: y)
        }

        let pairs = grid.getCandidatePairs()
        XCTAssertTrue(pairs.count < 4950, "Spatial grid should prune collision pairs significantly below N*(N-1)/2")

        grid.clear()
        let postClearPairs = grid.getCandidatePairs()
        XCTAssertEqual(postClearPairs.count, 0)
    }

    func testDormantBallActivation() {
        let dormantBall = BallNode(ballId: 1, radius: 14.0, isDormant: true)
        XCTAssertTrue(dormantBall.isDormant)
        XCTAssertEqual(dormantBall.physicsBody?.categoryBitMask, CollisionCategory.ballWhite)

        dormantBall.activateAndColorize()

        XCTAssertFalse(dormantBall.isDormant)
        XCTAssertEqual(dormantBall.physicsBody?.categoryBitMask, CollisionCategory.ballColored)
        XCTAssertTrue(dormantBall.physicsBody?.isDynamic == true)
    }

    func testSandTerrainGridOccupancyAndCarving() {
        let grid = SandTerrainGrid(worldWidth: 1000.0, worldHeight: 1800.0, cellSize: 20.0)
        grid.reset(sandBottom: 260.0, sandTop: 1750.0)

        XCTAssertTrue(grid.isSolidAt(x: 500.0, y: 1000.0), "Sand should be solid before carving")
        XCTAssertFalse(grid.isSolidAt(x: 500.0, y: 100.0), "Bottom region should be open for truck")

        // Carve trench
        grid.carveCapsule(from: CGPoint(x: 500.0, y: 1000.0), to: CGPoint(x: 500.0, y: 900.0), radius: 45.0)

        XCTAssertFalse(grid.isSolidAt(x: 500.0, y: 1000.0), "Carved position should be empty")
        XCTAssertFalse(grid.isSolidAt(x: 500.0, y: 950.0), "Intermediate capsule point should be empty")
    }
}
