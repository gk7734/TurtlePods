//
//  PostureHistoryList.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct PostureHistoryList: View {
    let history: [SleepPostureManager.PostureRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("자세 기록")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(history.reversed()) { record in
                        PostureHistoryRow(record: record)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
