//
//  TabItem.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct TabItem: View {
    let systemName: String
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemName)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .white : .gray)
            
            Text(title)
                .font(.caption)
                .foregroundColor(isSelected ? .white : .gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("AccentColor"))
                        .matchedGeometryEffect(id: "TAB", in: namespace)
                }
            }
        )
        .frame(maxWidth: .infinity)
    }
}
