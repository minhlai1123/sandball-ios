import SwiftUI
import SpriteKit

public struct WorldTheme {
    public let worldId: Int
    public let name: String
    public let emoji: String
    public let sandColorHex: String
    public let sandBorderColorHex: String
    public let bgTopColorHex: String
    public let bgBottomColorHex: String
    public let obstacleColorHex: String
    public let bgmName: String

    public var sandColor: SKColor {
        SKColor(hex: sandColorHex)
    }

    public var sandBorderColor: SKColor {
        SKColor(hex: sandBorderColorHex)
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

    public var sandBorderColorSwiftUI: Color {
        Color(hex: sandBorderColorHex)
    }
}

public func getWorldTheme(for worldId: Int) -> WorldTheme {
    switch worldId {
    case 1:
        return WorldTheme(
            worldId: 1,
            name: "Sunny Beach",
            emoji: "🏖️",
            sandColorHex: "#FFD152",
            sandBorderColorHex: "#F39C12",
            bgTopColorHex: "#FFF8E7",
            bgBottomColorHex: "#FFECC2",
            obstacleColorHex: "#FF4757",
            bgmName: "bgm_gameplay_kids.wav"
        )
    case 2:
        return WorldTheme(
            worldId: 2,
            name: "Candy Dunes",
            emoji: "🍬",
            sandColorHex: "#FF99C8",
            sandBorderColorHex: "#E056FD",
            bgTopColorHex: "#FFF0F5",
            bgBottomColorHex: "#FFE4E1",
            obstacleColorHex: "#00D2D3",
            bgmName: "bgm_candy_world.wav"
        )
    case 3:
        return WorldTheme(
            worldId: 3,
            name: "Emerald Meadow",
            emoji: "🌿",
            sandColorHex: "#7BED9F",
            sandBorderColorHex: "#2ED573",
            bgTopColorHex: "#F0FFF4",
            bgBottomColorHex: "#E6FFFA",
            obstacleColorHex: "#FFA502",
            bgmName: "bgm_jungle_fun.wav"
        )
    case 4:
        return WorldTheme(
            worldId: 4,
            name: "Ice Cream Peak",
            emoji: "🍧",
            sandColorHex: "#70A1FF",
            sandBorderColorHex: "#3742FA",
            bgTopColorHex: "#F0F8FF",
            bgBottomColorHex: "#E6F2FF",
            obstacleColorHex: "#FF6B81",
            bgmName: "bgm_icecream_waltz.wav"
        )
    case 5:
        return WorldTheme(
            worldId: 5,
            name: "Rainbow Canyon",
            emoji: "🌈",
            sandColorHex: "#FFA502",
            sandBorderColorHex: "#FF6348",
            bgTopColorHex: "#FAF5FF",
            bgBottomColorHex: "#F3E8FF",
            obstacleColorHex: "#9B59B6",
            bgmName: "bgm_candy_world.wav"
        )
    case 6:
        return WorldTheme(
            worldId: 6,
            name: "TNT Quarry",
            emoji: "💣",
            sandColorHex: "#E17055",
            sandBorderColorHex: "#D63031",
            bgTopColorHex: "#FFF5F5",
            bgBottomColorHex: "#FED7D7",
            obstacleColorHex: "#E67E22",
            bgmName: "bgm_jungle_fun.wav"
        )
    case 7:
        return WorldTheme(
            worldId: 7,
            name: "Carnival Park",
            emoji: "🎡",
            sandColorHex: "#F39C12",
            sandBorderColorHex: "#D35400",
            bgTopColorHex: "#FEF9C3",
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
            sandBorderColorHex: "#2980B9",
            bgTopColorHex: "#F1F5F9",
            bgBottomColorHex: "#FEF3C7",
            obstacleColorHex: "#3498DB",
            bgmName: "bgm_gameplay_kids.wav"
        )
    case 9:
        return WorldTheme(
            worldId: 9,
            name: "Space Portals",
            emoji: "🌌",
            sandColorHex: "#8E44AD",
            sandBorderColorHex: "#00CEC9",
            bgTopColorHex: "#EEF2FF",
            bgBottomColorHex: "#C7D2FE",
            obstacleColorHex: "#00D2D3",
            bgmName: "bgm_icecream_waltz.wav"
        )
    default:
        return WorldTheme(
            worldId: 10,
            name: "Master Island",
            emoji: "👑",
            sandColorHex: "#F59E0B",
            sandBorderColorHex: "#8E44AD",
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
