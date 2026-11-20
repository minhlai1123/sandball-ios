import SwiftUI

public struct MainMenuView: View {
    @ObservedObject public var sceneManager: SceneManager
    @ObservedObject public var progressManager: ProgressManager

    @State private var pulseScale: CGFloat = 1.0
    @State private var mascotOffset: CGFloat = -5.0

    public var body: some View {
        ZStack {
            // Cheerful sunny sky & sand gradient
            LinearGradient(
                colors: [
                    Color(hex: "#38BDF8"),
                    Color(hex: "#BAE6FD"),
                    Color(hex: "#FEF08A"),
                    Color(hex: "#FDE047")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // TOP BAR: Stars & Kid-Safe Badge
                HStack {
                    Text("🎈 NO ADS • OFFLINE")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#0F766E"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)

                    Spacer()

                    HStack(spacing: 4) {
                        Text("⭐")
                        Text("\(progressManager.getTotalStars()) / 300")
                            .font(.system(size: 14, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "#B45309"))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#FEF3C7"))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#F59E0B"), lineWidth: 1.5))
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                // CENTER TITLE CARD: 3D Bubble Plaque
                VStack(spacing: 2) {
                    Text("🏖️ SAND")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "#EA580C"))
                        .tracking(2)

                    Text("ADVENTURE")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "#0284C7"))
                        .tracking(4)
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(28)
                .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color(hex: "#FBBF24"), lineWidth: 4))
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 6)

                // CUTE KAWAII MASCOT BALLS
                HStack(spacing: 16) {
                    // Red Ball
                    Circle()
                        .fill(Color(hex: "#FF4757"))
                        .frame(width: 64, height: 64)
                        .overlay(
                            VStack(spacing: 2) {
                                HStack(spacing: 8) {
                                    Circle().fill(Color.white).frame(width: 8, height: 8)
                                    Circle().fill(Color.white).frame(width: 8, height: 8)
                                }
                                Text("‿").font(.system(size: 16, weight: .bold)).foregroundColor(Color(hex: "#1E293B"))
                            }
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)

                    // Hero Golden Ball (Center, larger)
                    Circle()
                        .fill(Color(hex: "#FFA502"))
                        .frame(width: 76, height: 76)
                        .overlay(
                            VStack(spacing: 2) {
                                HStack(spacing: 10) {
                                    Circle().fill(Color.white).frame(width: 10, height: 10)
                                    Circle().fill(Color.white).frame(width: 10, height: 10)
                                }
                                Text("▽").font(.system(size: 12, weight: .bold)).foregroundColor(Color(hex: "#FF4757"))
                            }
                        )
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 5)

                    // Mint Happy Ball
                    Circle()
                        .fill(Color(hex: "#2ED573"))
                        .frame(width: 64, height: 64)
                        .overlay(
                            VStack(spacing: 2) {
                                HStack(spacing: 8) {
                                    Text("⌒").font(.system(size: 14, weight: .black)).foregroundColor(Color(hex: "#1E293B"))
                                    Text("⌒").font(.system(size: 14, weight: .black)).foregroundColor(Color(hex: "#1E293B"))
                                }
                                Text("‿").font(.system(size: 14, weight: .bold)).foregroundColor(Color(hex: "#1E293B"))
                            }
                        )
                        .shadow(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 4)
                }
                .offset(y: mascotOffset)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                        mascotOffset = 5.0
                    }
                }

                Spacer()

                // BUTTONS AREA
                VStack(spacing: 14) {
                    // GIANT GREEN PLAY BUTTON
                    Button(action: {
                        sceneManager.startLevel(progressManager.highestUnlockedLevel)
                    }) {
                        Text("▶  PLAY NOW!")
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 68)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#34D399"), Color(hex: "#059669")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(34)
                            .overlay(RoundedRectangle(cornerRadius: 34).stroke(Color(hex: "#6EE7B7"), lineWidth: 2.5))
                            .shadow(color: Color(hex: "#059669").opacity(0.4), radius: 10, x: 0, y: 5)
                            .scaleEffect(pulseScale)
                    }
                    .padding(.horizontal, 36)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                            pulseScale = 1.05
                        }
                    }

                    // ORANGE 100 LEVELS BUTTON
                    Button(action: {
                        sceneManager.openLevelSelect()
                    }) {
                        Text("🗺️  100 LEVELS")
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#FBBF24"), Color(hex: "#D97706")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(28)
                            .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color(hex: "#FDE68A"), lineWidth: 2))
                            .shadow(color: Color(hex: "#D97706").opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 36)

                    // BLUE SETTINGS BUTTON
                    Button(action: {
                        sceneManager.openSettings()
                    }) {
                        Text("⚙️  SETTINGS & SOUND")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#38BDF8"), Color(hex: "#0284C7")],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(26)
                            .overlay(RoundedRectangle(cornerRadius: 26).stroke(Color(hex: "#BAE6FD"), lineWidth: 2))
                            .shadow(color: Color(hex: "#0284C7").opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .padding(.horizontal, 36)
                }

                Spacer()

                Text("✨ 100 UNIQUE PUZZLES • FUN FOR ALL AGES ✨")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#78350F"))
                    .padding(.bottom, 20)
            }
        }
        .onAppear {
            AudioManager.shared.playBgm(named: "bgm_menu_kids.wav")
        }
    }
}
