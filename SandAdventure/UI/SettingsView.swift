import SwiftUI

public struct SettingsView: View {
    @ObservedObject public var sceneManager: SceneManager
    @ObservedObject public var progressManager: ProgressManager
    @State private var showingResetAlert = false

    public var body: some View {
        ZStack {
            // Sunny pastel gradient
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

            VStack(alignment: .leading, spacing: 20) {
                // Top Header
                HStack {
                    Button(action: {
                        sceneManager.openMenu()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#0F172A"))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }

                    Spacer()

                    Text("⚙️ SETTINGS")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "#0F172A"))

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.top, 44)

                // Audio & Controls Card
                VStack(spacing: 16) {
                    Toggle("🔊 Sound Effects", isOn: $progressManager.soundEnabled)
                        .foregroundColor(Color(hex: "#1E293B"))
                        .font(.system(size: 17, weight: .bold, design: .rounded))

                    Divider()

                    Toggle("🎵 Background Music", isOn: $progressManager.musicEnabled)
                        .foregroundColor(Color(hex: "#1E293B"))
                        .font(.system(size: 17, weight: .bold, design: .rounded))

                    Divider()

                    Toggle("📳 Haptic Vibrations", isOn: $progressManager.hapticsEnabled)
                        .foregroundColor(Color(hex: "#1E293B"))
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(22)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                .padding(.horizontal, 16)

                // Kid Safety Card
                VStack(alignment: .leading, spacing: 6) {
                    Text("🛡️ 100% KID SAFE & ZERO ADS")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "#047857"))

                    Text("Sand Adventure is completely free, runs 100% offline, and contains zero advertising SDKs, tracking IDs, or in-app purchases. Pure safe fun for kids and family!")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "#065F46"))
                        .lineSpacing(3)
                }
                .padding(18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "#ECFDF5"))
                .cornerRadius(22)
                .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color(hex: "#A7F3D0"), lineWidth: 2))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 16)

                Spacer()

                // Reset Data Button
                Button(action: {
                    showingResetAlert = true
                }) {
                    Text("🗑️ Reset All Progress")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "#DC2626"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "#FEE2E2"))
                        .cornerRadius(25)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color(hex: "#FCA5A5"), lineWidth: 1.5))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
        }
        .alert(isPresented: $showingResetAlert) {
            Alert(
                title: Text("Reset Progress?"),
                message: Text("All unlocked levels and stars will be permanently reset."),
                primaryButton: .destructive(Text("Reset")) {
                    progressManager.resetProgress()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
