//
//  CustomTabBar.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var namespace
    private let HapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                TabItem(
                    systemName: tab.systemImage,
                    title: tab.rawValue,
                    isSelected: selectedTab == tab,
                    namespace: namespace
                )
                .onTapGesture {
                    setHapticIntensity(.heavy)
                    guard selectedTab != tab else {
                        return
                    }
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    func setHapticIntensity(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
            HapticFeedback.impactOccurred(intensity: style == .light ? 0.3 : style == .medium ? 0.6 : 1.0)
    }
    
}
