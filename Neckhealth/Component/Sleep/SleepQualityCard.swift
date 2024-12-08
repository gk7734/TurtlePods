//
//  SleepQualityCard.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//

import SwiftUI
import RiveRuntime

struct SleepQualityCard: View {
    @ObservedObject var postureManager: SleepPostureManager
    
    var body: some View {
        HStack(spacing: 20) { // 간격을 조금 더 넓힘
            // 수면 점수와 평가
            VStack(spacing: 12) {
                Text("Sleep Quality")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text(evaluateSleepScore())
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(scoreColor())
                
                Text("Comment : \(postureManager.generateSleepReport().sleepQuality)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 150, maxWidth: .infinity) // 최소/최대 너비 설정
            
            Divider()
            
            // 자세 변경 횟수와 추천 사항
            VStack(alignment: .leading, spacing: 12) {
                Text("Number of posture changes")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Text("\(postureManager.postureChangeCount)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommend : ")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    ForEach(postureManager.generateSleepReport().recommendations, id: \.self) { recommendation in
                        Text("• \(recommendation)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .frame(minWidth: 150, maxWidth: .infinity) // 최소/최대 너비 설정
        }
        .padding()
        .frame(minWidth: 350) // 카드 자체의 기본 너비 설정
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal) // 전체 화면의 좌우 여백
    }
    
    // 수면 점수를 텍스트로 반환
    private func evaluateSleepScore() -> String {
        let score = postureManager.generateSleepReport().sleepQuality
        switch score {
        case "Very GOOOODD": return "100"
        case "Good": return "80"
        case "Just Okay": return "60"
        case "Bad": return "40"
        default: return "20"
        }
    }
    
    // 점수에 따른 색상 반환
    private func scoreColor() -> Color {
        let score = evaluateSleepScore()
        switch score {
        case "100": return Color("AccentColor")
        case "80": return .blue
        case "60": return .yellow
        case "40": return .orange
        default: return .red
        }
    }
}
