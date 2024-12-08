//
//  SleepMonitoringView.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//


import SwiftUI

struct SleepMonitoringView: View {
    @StateObject private var postureManager = SleepPostureManager()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 현재 수면 자세 상태 카드
                CurrentPostureCard(postureManager: postureManager)
                
                SleepQualityCard(postureManager: postureManager)
                
                // 모니터링 컨트롤
                MonitoringControlPanel(postureManager: postureManager)
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
    }
}
