//
//  PostureHistoryRow.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct PostureHistoryRow: View {
    let record: SleepPostureManager.PostureRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(record.posture.description)
                    .font(.headline)
                Text(formatDate(record.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(Int(record.duration / 60))분")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
