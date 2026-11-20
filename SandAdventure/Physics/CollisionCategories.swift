import Foundation

public struct CollisionCategory {
    public static let none: UInt32           = 0
    public static let sandBoundary: UInt32   = 1 << 0 // 1
    public static let ballColored: UInt32    = 1 << 1 // 2
    public static let ballWhite: UInt32      = 1 << 2 // 4
    public static let obstacle: UInt32       = 1 << 3 // 8
    public static let truckBed: UInt32       = 1 << 4 // 16
    public static let collectible: UInt32    = 1 << 5 // 32
    public static let multiplierGate: UInt32 = 1 << 6 // 64
    public static let portal: UInt32         = 1 << 7 // 128
    public static let bumper: UInt32         = 1 << 8 // 256
    public static let tnt: UInt32            = 1 << 9 // 512
}
