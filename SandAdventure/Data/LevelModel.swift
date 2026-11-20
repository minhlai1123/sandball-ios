import Foundation

public struct Bounds: Codable {
    public let width: Double
    public let height: Double

    public init(width: Double = 1000.0, height: Double = 1800.0) {
        self.width = width
        self.height = height
    }
}

public struct SandRegion: Codable {
    public let x: Double
    public let y: Double
    public let width: Double
    public let height: Double
    public let carvable: Bool

    public init(x: Double, y: Double, width: Double, height: Double, carvable: Bool = true) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.carvable = carvable
    }
}

public struct BallSpawner: Codable {
    public let x: Double
    public let y: Double
    public let count: Int
    public let type: String // "colored" or "dormant_white"
    public let spreadRadius: Double

    public init(x: Double, y: Double, count: Int, type: String = "colored", spreadRadius: Double = 100.0) {
        self.x = x
        self.y = y
        self.count = count
        self.type = type
        self.spreadRadius = spreadRadius
    }
}

public struct ObstacleDef: Codable {
    public let id: String
    public let type: String // "static_beam", "rotating_paddle", "funnel_bumper", "multiplier_gate", "portal_pair", "bouncy_bumper", "tnt_crate"
    public let x: Double
    public let y: Double
    public let width: Double?
    public let height: Double?
    public let rotationDegrees: Double?
    public let motorSpeed: Double?
    public let restitution: Double?
    public let multiplier: Int?
    public let exitX: Double?
    public let exitY: Double?

    public var safeWidth: Double { width ?? 0.0 }
    public var safeHeight: Double { height ?? 0.0 }
    public var safeRotation: Double { rotationDegrees ?? 0.0 }
    public var safeMotorSpeed: Double { motorSpeed ?? 0.0 }
    public var safeRestitution: Double { restitution ?? 0.3 }
    public var safeMultiplier: Int { multiplier ?? 2 }
    public var safeExitX: Double { exitX ?? 500.0 }
    public var safeExitY: Double { exitY ?? 500.0 }

    public init(
        id: String,
        type: String,
        x: Double,
        y: Double,
        width: Double? = 0.0,
        height: Double? = 0.0,
        rotationDegrees: Double? = 0.0,
        motorSpeed: Double? = 0.0,
        restitution: Double? = 0.3,
        multiplier: Int? = 2,
        exitX: Double? = 500.0,
        exitY: Double? = 500.0
    ) {
        self.id = id
        self.type = type
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotationDegrees = rotationDegrees
        self.motorSpeed = motorSpeed
        self.restitution = restitution
        self.multiplier = multiplier
        self.exitX = exitX
        self.exitY = exitY
    }
}

public struct CollectibleDef: Codable {
    public let id: String
    public let type: String // "gold_key"
    public let x: Double
    public let y: Double

    public init(id: String, type: String = "gold_key", x: Double, y: Double) {
        self.id = id
        self.type = type
        self.x = x
        self.y = y
    }
}

public struct TruckDef: Codable {
    public let x: Double
    public let y: Double
    public let width: Double
    public let height: Double
    public let quota: Int

    public init(x: Double, y: Double, width: Double = 320.0, height: Double = 150.0, quota: Int) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.quota = quota
    }
}

public struct SandAdventureLevel: Codable {
    public let levelId: Int
    public let worldId: Int
    public let title: String
    public let quota: Int
    public let totalInitialBalls: Int
    public let bounds: Bounds
    public let sandRegions: [SandRegion]
    public let ballSpawners: [BallSpawner]
    public let obstacles: [ObstacleDef]
    public let collectibles: [CollectibleDef]
    public let truck: TruckDef

    public static func from(jsonString: String) throws -> SandAdventureLevel {
        guard let data = jsonString.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Invalid UTF-8"))
        }
        return try JSONDecoder().decode(SandAdventureLevel.self, from: data)
    }
}
