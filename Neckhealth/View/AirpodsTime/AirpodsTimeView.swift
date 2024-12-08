//
//  AirpodsTimeView.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//

import SwiftUI
import CoreData
import HealthKit

struct AirpodsTimeView: View {
    @State private var selectedDate = Date()
    @State private var usageTime: TimeInterval?
    @State private var showingHealthKitPermission = false

    private let healthManager = HeadphoneUsageManager.shared
    private let coreDataManager = CoreDataManager.shared

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 5) {
                Text("My")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                Text("Airpods Usage Time")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 15)

            if let usage = usageTime {
                Text(formatDuration(usage))
                    .font(.system(size: 32, weight: .bold))
                    .frame(maxWidth: .infinity, minHeight: 70)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal)
            } else {
                Text("No Data Here.")
                    .font(.system(size: 36, weight: .bold))
                    .frame(maxWidth: .infinity, minHeight: 120)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal)
            }

            CalendarView(selectedDate: $selectedDate)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding()
                .onChange(of: selectedDate) { newDate in
                    loadUsageData(for: newDate)
                }
        }
        .onAppear {
            requestHealthKitPermission()
        }
        .alert("HealthKit permission required.", isPresented: $showingHealthKitPermission) {
            Button("Okay") {}
        } message: {
            Text("HealthKit permission is required to record AirPods usage time.")
        }
    }

    private func requestHealthKitPermission() {
        healthManager.requestAuthorization { success, error in
            if success {
                loadUsageData(for: selectedDate)
            } else {
                showingHealthKitPermission = true
            }
        }
    }

    private func loadUsageData(for date: Date) {
        if let savedUsage = coreDataManager.getUsage(for: date) {
            usageTime = savedUsage
        } else {
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

            healthManager.fetchHeadphoneUsageTime(start: startOfDay, end: endOfDay) { duration, error in
                if let duration = duration {
                    usageTime = duration
                    coreDataManager.saveUsage(date: date, duration: duration)
                } else {
                    usageTime = nil
                }
            }
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        return "\(hours)H \(minutes)M"
    }
}
