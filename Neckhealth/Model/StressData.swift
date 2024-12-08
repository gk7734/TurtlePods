//
//  StressData.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import Foundation

struct StressData: Identifiable, Codable {
        let id = UUID()
        let date: Date
        let level: Double
}
