//
//  StatusType.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

enum StatusType {
    case safe
    case caution
    case turtle
        
    var icon: String {
        switch self {
            case .safe: return "checkmark"
            case .caution: return "exclamationmark.triangle"
            case .turtle: return "xmark.circle"
        }
    }
        
    var title: String {
        switch self {
            case .safe: return "Safe"
            case .caution: return "Caution"
            case .turtle: return "Turtle"
        }
    }
        
    var color: Color {
        switch self {
            case .safe: return .green
            case .caution: return .yellow
            case .turtle: return .red
        }
    }
}
