//
//  StatusCard.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct StatusCard: View {
    let type: StatusType
    let message: String
    let subMessage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: type.icon)
                    .foregroundColor(type.color)
                    .frame(width: 30, height: 30)
                Text(type.title)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                Spacer()
            }
            .padding(.bottom, 8)
            
            Text(message)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding(.bottom, 7)
            
            Text(subMessage)
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
        )
    }
}
