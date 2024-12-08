//
//  SleepReport.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import Foundation

struct SleepReport {
    let date: Date
    let totalSleepDuration: TimeInterval
    let posturePercentages: [SleepPostureManager.SleepPosture: Double]
    let recommendations: [String]
    let sleepQuality: String
}
