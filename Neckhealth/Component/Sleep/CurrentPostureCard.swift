//
//  CurrentPostureCard.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI
import RiveRuntime

struct CurrentPostureCard: View {
    @ObservedObject var postureManager: SleepPostureManager
    
    var body: some View {
        VStack(spacing: 12) {
                Text("What is Current Sleeping Position?")
                    .font(.system(size: 20))
                    .fontWeight(.light)
                    .padding(.top, 15)
            
            RiveViewRepresentable(viewModel: RiveViewModel(fileName: "sleeping_green", artboardName: "Artboard"))
                .frame(height: 160) // 높이 제한
            
            Text(postureManager.currentPosture.description)
                .font(.system(size: 28))
                .fontWeight(.bold)
            
            Text(postureManager.currentPosture.recommendation)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 2)
                .padding(.bottom, 13)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
