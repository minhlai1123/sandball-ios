import Foundation
import AVFoundation

public class AudioManager {
    public static let shared = AudioManager()

    private var bgmPlayer: AVAudioPlayer?
    private var sfxPlayers = [String: AVAudioPlayer]()
    private var digPlayer: AVAudioPlayer?

    private init() {}

    public func playBgm(named name: String, loop: Bool = true) {
        guard ProgressManager.shared.musicEnabled else {
            stopBgm()
            return
        }

        let base = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension.isEmpty ? "wav" : (name as NSString).pathExtension

        guard let url = Bundle.main.url(forResource: base, withExtension: ext, subdirectory: "Audio") ??
                        Bundle.main.url(forResource: base, withExtension: ext) else {
            return
        }

        do {
            bgmPlayer?.stop()
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loop ? -1 : 0
            player.volume = 0.65
            player.prepareToPlay()
            player.play()
            bgmPlayer = player
        } catch {
        }
    }

    public func stopBgm() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }

    public func playSfx(named name: String, volume: Float = 1.0) {
        guard ProgressManager.shared.soundEnabled else { return }

        let base = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension.isEmpty ? "wav" : (name as NSString).pathExtension

        guard let url = Bundle.main.url(forResource: base, withExtension: ext, subdirectory: "Audio") ??
                        Bundle.main.url(forResource: base, withExtension: ext) else {
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            player.play()
            sfxPlayers[name] = player
        } catch {
        }
    }

    public func playVictory() {
        playSfx(named: "sfx_victory_fanfare.wav", volume: 1.0)
    }

    public func playTruckHorn() {
        playSfx(named: "sfx_truck_horn.wav", volume: 0.9)
    }

    public func playBallPop() {
        playSfx(named: "sfx_ball_pop.wav", volume: 0.8)
    }

    public func playTruckDrop() {
        playSfx(named: "sfx_truck_drop.wav", volume: 0.75)
    }

    public func playBoing() {
        playSfx(named: "sfx_boing.wav", volume: 0.85)
    }

    public func playMultiplier() {
        playSfx(named: "sfx_multiplier.wav", volume: 0.9)
    }

    public func playPortal() {
        playSfx(named: "sfx_portal.wav", volume: 0.85)
    }

    public func playTntBlast() {
        playSfx(named: "sfx_tnt_boom.wav", volume: 1.0)
    }

    public func playKidsCheer() {
        playSfx(named: "sfx_cheer_kids.wav", volume: 0.95)
    }

    public func playWorldBgm(for worldId: Int) {
        let theme = getWorldTheme(for: worldId)
        playBgm(named: theme.bgmName, loop: true)
    }

    public func playButtonTap() {
        playSfx(named: "sfx_btn_tap.wav", volume: 0.7)
    }
}
