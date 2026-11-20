import Foundation
import SwiftUI
import SpriteKit

public struct WorldTheme {
    public let worldId: Int
    public let name: String
    public let emoji: String
    public let sandColorHex: String
    public let bgTopColorHex: String
    public let bgBottomColorHex: String
    public let obstacleColorHex: String
    public let bgmName: String

    public var sandColor: SKColor {
        SKColor(hex: sandColorHex)
    }

    public var obstacleColor: SKColor {
        SKColor(hex: obstacleColorHex)
    }

    public var bgTopColor: Color {
        Color(hex: bgTopColorHex)
    }

    public var bgBottomColor: Color {
        Color(hex: bgBottomColorHex)
    }
}

public func getWorldTheme(for worldId: Int) -> WorldTheme {
    switch worldId {
    case 1:
        return WorldTheme(
            worldId: 1,
            name: "Sunny Beach",
            emoji: "🏖️",
            sandColorHex: "#F1C40F",
            bgTopColorHex: "#38BDF8",
            bgBottomColorHex: "#FFF9C4",
            obstacleColorHex: "#FF4757",
            bgmName: "bgm_gameplay_kids.wav"
        )
    case 2:
        return WorldTheme(
            worldId: 2,
            name: "Candy Dunes",
            emoji: "🍬",
            sandColorHex: "#FF6B81",
            bgTopColorHex: "#F3E8FF",
            bgBottomColorHex: "#FCE7F3",
            obstacleColorHex: "#2ED573",
            bgmName: "bgm_candy_world.wav"
        )
    case 3:
        return WorldTheme(
            worldId: 3,
            name: "Emerald Meadow",
            emoji: "🌿",
            sandColorHex: "#2ED573",
            bgTopColorHex: "#E0F2FE",
            bgBottomColorHex: "#D1FAE5",
            obstacleColorHex: "#FFA502",
            bgmName: "bgm_jungle_fun.wav"
        )
    case 4:
        return WorldTheme(
            worldId: 4,
            name: "Ice Cream Peak",
            emoji: "🍧",
            sandColorHex: "#70A1FF",
            bgTopColorHex: "#E0F2FE",
            bgBottomColorHex: "#F1F2F6",
            obstacleColorHex: "#FF6348",
            bgmName: "bgm_icecream_waltz.wav"
        )
    case 5:
        return WorldTheme(
            worldId: 5,
            name: "Rainbow Canyon",
            emoji: "🌈",
            sandColorHex: "#E67E22",
            bgTopColorHex: "#F3E8FF",
            bgBottomColorHex: "#FEF3C7",
            obstacleColorHex: "#9B59B6",
            bgmName: "bgm_candy_world.wav"
        )
    case 6:
        return WorldTheme(
            worldId: 6,
            name: "TNT Quarry",
            emoji: "💣",
            sandColorHex: "#D35400",
            bgTopColorHex: "#FEE2E2",
            bgBottomColorHex: "#FEF3C7",
            obstacleColorHex: "#E74C3C",
            bgmName: "bgm_jungle_fun.wav"
        )
    case 7:
        return WorldTheme(
            worldId: 7,
            name: "Carnival Park",
            emoji: "🎡",
            sandColorHex: "#F39C12",
            bgTopColorHex: "#FEF08A",
            bgBottomColorHex: "#BAE6FD",
            obstacleColorHex: "#1ABC9C",
            bgmName: "bgm_candy_world.wav"
        )
    case 8:
        return WorldTheme(
            worldId: 8,
            name: "Sand Castle",
            emoji: "🏰",
            sandColorHex: "#E59866",
            bgTopColorHex: "#E2E8F0",
            bgBottomColorHex: "#FEF3C7",
            obstacleColorHex: "#2980B9",
            bgmName: "bgm_gameplay_kids.wav"
        )
    case 9:
        return WorldTheme(
            worldId: 9,
            name: "Space Portals",
            emoji: "🌌",
            sandColorHex: "#8E44AD",
            bgTopColorHex: "#E0E7FF",
            bgBottomColorHex: "#C7D2FE",
            obstacleColorHex: "#00CEC9",
            bgmName: "bgm_icecream_waltz.wav"
        )
    default:
        return WorldTheme(
            worldId: 10,
            name: "Master Island",
            emoji: "👑",
            sandColorHex: "#F59E0B",
            bgTopColorHex: "#FEF08A",
            bgBottomColorHex: "#FEF9C3",
            obstacleColorHex: "#8E44AD",
            bgmName: "bgm_candy_world.wav"
        )
    }
}

extension SKColor {
    convenience init(hex: String) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

extension Color {
    init(hex: String) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
