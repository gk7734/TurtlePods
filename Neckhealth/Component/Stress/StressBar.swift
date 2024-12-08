//
//  StressBar.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct StressBar: View {
    let stressLevel: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 스트레스 바
            ZStack {
                // 배경 컨테이너
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    .background(Color.white)
                    .cornerRadius(12)
                    .frame(height: 36)
                
                // 컬러 그라데이션 바
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach(0..<8) { index in
                            Rectangle()
                                .fill(index < stressLevel ? colorForIndex(index) : Color.clear)
                                .frame(width: geometry.size.width / 8)
                        }
                    }
                    .cornerRadius(12)
                }
                .frame(height: 36)
                
                // 구분선
                HStack(spacing: 0) {
                    ForEach(0..<8) { index in
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 1)
                            .frame(maxHeight: .infinity)
                            .opacity(0.5)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 36)
            
            // 안정-심각 레이블
            HStack {
                Text("안정")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("심각")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func colorForIndex(_ index: Int) -> Color {
        let colors: [Color] = [
            .green,
            Color(red: 0.7, green: 0.9, blue: 0.3),
            Color(red: 0.8, green: 0.9, blue: 0.3),
            Color(red: 0.9, green: 0.8, blue: 0.3),
            Color(red: 1.0, green: 0.7, blue: 0.3),
            Color(red: 1.0, green: 0.6, blue: 0.2),
            Color(red: 1.0, green: 0.4, blue: 0.2),
            .red
        ]
        return colors[min(index, colors.count - 1)]
    }
}
