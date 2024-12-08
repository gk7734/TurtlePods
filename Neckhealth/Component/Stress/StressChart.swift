//
//  StressChartView.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI
import Charts

struct StressChart: View {
        let stressHistory: [StressData]
        
        var body: some View {
            Chart(stressHistory) { data in
                AreaMark(
                    x: .value("Time", data.date),
                    y: .value("Stress", data.level)
                )
                .foregroundStyle(
                    .linearGradient(
                        colors: [.mint.opacity(0.3), .mint.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(
                    x: .value("Time", data.date),
                    y: .value("Stress", data.level)
                )
                .foregroundStyle(.mint)
            }
            .chartYScale(domain: 0...10)
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
        }
}
