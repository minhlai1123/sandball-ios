import SwiftUI

public struct LevelSelectView: View {
    @ObservedObject public var sceneManager: SceneManager
    @ObservedObject public var progressManager: ProgressManager

    @State private var selectedWorld: Int = 0

    private let worldNames = [
        "🏖️ 1. Beach",
        "🍬 2. Candy",
        "🌿 3. Meadow",
        "🍧 4. Ice Cream",
        "🌈 5. Rainbow",
        "💣 6. TNT Quarry",
        "🎡 7. Carnival",
        "🏰 8. Castle",
        "🌌 9. Portals",
        "👑 10. Master"
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

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

            VStack(alignment: .leading, spacing: 14) {
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

                    Text("🗺️ SELECT LEVEL")
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "#0F172A"))

                    Spacer()

                    HStack(spacing: 4) {
                        Text("⭐")
                        Text("\(progressManager.getTotalStars())")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "#B45309"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#F59E0B"), lineWidth: 1.5))
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                }
                .padding(.horizontal, 16)
                .padding(.top, 44)

                // World Tabs ScrollView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(0..<worldNames.count, id: \.self) { wIdx in
                            let isSelected = wIdx == selectedWorld
                            let worldFirstLevel = wIdx * 10 + 1
                            let isWorldUnlocked = progressManager.highestUnlockedLevel >= worldFirstLevel

                            Button(action: {
                                selectedWorld = wIdx
                            }) {
                                Text(worldNames[wIdx])
                                    .font(.system(size: 13, weight: isSelected ? .black : .bold, design: .rounded))
                                    .foregroundColor(isSelected ? .white : (isWorldUnlocked ? Color(hex: "#1E293B") : Color(hex: "#94A3B8")))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(isSelected ? Color(hex: "#10B981") : (isWorldUnlocked ? Color.white : Color.white.opacity(0.4)))
                                    .cornerRadius(18)
                                    .shadow(color: Color.black.opacity(isSelected ? 0.15 : 0.05), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Level Grid for Selected World
                let startLevel = selectedWorld * 10 + 1

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(0..<10, id: \.self) { offset in
                            let levelId = startLevel + offset
                            let isUnlocked = levelId <= progressManager.highestUnlockedLevel
                            let isCurrent = levelId == progressManager.highestUnlockedLevel
                            let stars = progressManager.getStars(for: levelId)

                            Button(action: {
                                if isUnlocked {
                                    sceneManager.startLevel(levelId)
                                }
                            }) {
                                VStack(spacing: 6) {
                                    if isUnlocked {
                                        Text("\(levelId)")
                                            .font(.system(size: 24, weight: .black, design: .rounded))
                                            .foregroundColor(isCurrent ? Color(hex: "#D97706") : Color(hex: "#1E293B"))

                                        HStack(spacing: 2) {
                                            ForEach(1...3, id: \.self) { s in
                                                Image(systemName: s <= stars ? "star.fill" : "star")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(s <= stars ? Color(hex: "#F59E0B") : Color(hex: "#CBD5E1"))
                                            }
                                        }
                                    } else {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(Color(hex: "#94A3B8"))
                                        Text("\(levelId)")
                                            .font(.system(size: 13, weight: .bold, design: .rounded))
                                            .foregroundColor(Color(hex: "#94A3B8"))
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 84)
                                .background(isCurrent ? Color(hex: "#FEF3C7") : (isUnlocked ? Color.white : Color.white.opacity(0.4)))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(isCurrent ? Color(hex: "#F59E0B") : (isUnlocked ? Color(hex: "#E2E8F0") : Color.clear), lineWidth: isCurrent ? 2.5 : 1)
                                )
                                .shadow(color: Color.black.opacity(isUnlocked ? 0.08 : 0.02), radius: 6, x: 0, y: 3)
                            }
                            .disabled(!isUnlocked)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .onAppear {
            selectedWorld = min(max((progressManager.highestUnlockedLevel - 1) / 10, 0), 9)
        }
    }
}
