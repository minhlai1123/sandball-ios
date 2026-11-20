import SwiftUI

public struct GameHUDView: View {
    public let title: String
    public let remainingQuota: Int
    public let isVictory: Bool
    public let earnedStars: Int
    public let onRestart: () -> Void
    public let onMenu: () -> Void
    public let onNextLevel: () -> Void

    public var body: some View {
        ZStack {
            // Top Bar
            VStack {
                HStack {
                    Button(action: onMenu) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#0F172A"))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 2)
                    }

                    Spacer()

                    Text(title)
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(Color(hex: "#D97706"))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(22)
                        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color(hex: "#F59E0B"), lineWidth: 2))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)

                    Spacer()

                    Button(action: onRestart) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#0F172A"))
                            .frame(width: 44, height: 44)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 44)

                Spacer()
            }

            // Victory Dialog
            if isVictory {
                ZStack {
                    Color.black.opacity(0.45).edgesIgnoringSafeArea(.all)

                    VStack(spacing: 18) {
                        Text("🎉 VICTORY! 🎉")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "#EA580C"))

                        HStack(spacing: 12) {
                            ForEach(1...3, id: \.self) { star in
                                Image(systemName: star <= earnedStars ? "star.fill" : "star")
                                    .font(.system(size: 46))
                                    .foregroundColor(star <= earnedStars ? Color(hex: "#F59E0B") : Color(hex: "#E2E8F0"))
                                    .shadow(color: star <= earnedStars ? Color(hex: "#F59E0B").opacity(0.5) : Color.clear, radius: 4)
                            }
                        }

                        Button(action: onNextLevel) {
                            Text("NEXT LEVEL ➔")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color(hex: "#10B981"))
                                .cornerRadius(27)
                                .overlay(RoundedRectangle(cornerRadius: 27).stroke(Color(hex: "#6EE7B7"), lineWidth: 2))
                                .shadow(color: Color(hex: "#10B981").opacity(0.4), radius: 6, x: 0, y: 3)
                        }
                        .padding(.horizontal, 16)

                        Button(action: onRestart) {
                            Text("Replay Level")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .foregroundColor(Color(hex: "#64748B"))
                        }
                    }
                    .padding(26)
                    .background(Color.white)
                    .cornerRadius(28)
                    .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color(hex: "#FBBF24"), lineWidth: 3.5))
                    .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 6)
                    .padding(.horizontal, 28)
                }
            }
        }
    }
}
