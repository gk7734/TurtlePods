//
//  Tab.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//


// 탭 아이템 모델
enum Tab: String, CaseIterable {
    case turtleNeck = "Neck Diag"
    case sleep = "Sleep Diag"
    case stress = "Stress"
    case airpodstime = "Using time"
    
    var systemImage: String {
        switch self {
            case .turtleNeck: return "figure.seated.side.right.air.distribution.middle"
            case .stress: return "heart.text.square"
            case .sleep: return "moon.zzz"
            case .airpodstime: return "airpods.pro"
        }
    }
}
