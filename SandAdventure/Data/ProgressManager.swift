import Foundation

public class ProgressManager: ObservableObject {
    public static let shared = ProgressManager()

    private let defaults = UserDefaults.standard
    private let keyHighestUnlocked = "sand_adventure_highest_unlocked"
    private let keySoundEnabled = "sand_adventure_sound_enabled"
    private let keyMusicEnabled = "sand_adventure_music_enabled"
    private let keyHapticsEnabled = "sand_adventure_haptics_enabled"
    private let prefixStars = "sand_adventure_stars_level_"

    @Published public var highestUnlockedLevel: Int {
        didSet {
            defaults.set(highestUnlockedLevel, forKey: keyHighestUnlocked)
        }
    }

    @Published public var soundEnabled: Bool {
        didSet {
            defaults.set(soundEnabled, forKey: keySoundEnabled)
        }
    }

    @Published public var musicEnabled: Bool {
        didSet {
            defaults.set(musicEnabled, forKey: keyMusicEnabled)
        }
    }

    @Published public var hapticsEnabled: Bool {
        didSet {
            defaults.set(hapticsEnabled, forKey: keyHapticsEnabled)
        }
    }

    public init() {
        let storedUnlocked = defaults.integer(forKey: keyHighestUnlocked)
        self.highestUnlockedLevel = storedUnlocked > 0 ? storedUnlocked : 1
        self.soundEnabled = defaults.object(forKey: keySoundEnabled) as? Bool ?? true
        self.musicEnabled = defaults.object(forKey: keyMusicEnabled) as? Bool ?? true
        self.hapticsEnabled = defaults.object(forKey: keyHapticsEnabled) as? Bool ?? true
    }

    public func getStars(for levelId: Int) -> Int {
        return defaults.integer(forKey: prefixStars + "\(levelId)")
    }

    public func setStars(for levelId: Int, stars: Int) {
        let current = getStars(for: levelId)
        if stars > current {
            defaults.set(min(max(stars, 1), 3), forKey: prefixStars + "\(levelId)")
        }
        if levelId >= highestUnlockedLevel && levelId < 100 {
            highestUnlockedLevel = levelId + 1
        }
    }

    public func getTotalStars() -> Int {
        var total = 0
        for i in 1...100 {
            total += getStars(for: i)
        }
        return total
    }

    public func resetProgress() {
        defaults.removeObject(forKey: keyHighestUnlocked)
        for i in 1...100 {
            defaults.removeObject(forKey: prefixStars + "\(i)")
        }
        highestUnlockedLevel = 1
    }
}
