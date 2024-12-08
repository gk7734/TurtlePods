//
//  MonitoringControlPanel.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct MonitoringControlPanel: View {
    @ObservedObject var postureManager: SleepPostureManager
    
    var body: some View {
        Button(action: {
            if postureManager.isMonitoring {
                postureManager.stopMonitoring()
            } else {
                postureManager.startMonitoring()
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: postureManager.isMonitoring ? "stop.circle.fill" : "play.circle.fill")
                Text(postureManager.isMonitoring ? "Stop Monitoring" : "Start Monitoring")
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(postureManager.isMonitoring ? Color.red : Color("AccentColor"))
            .cornerRadius(20)
        }
        .padding(.horizontal)
    }
}
