//
//  CalendarView.swift
//  Neckhealth
//
//  Created by 4rNe5 on 11/23/24.
//
import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @State private var currentMonth = Date()

    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text(dateFormatter.string(from: currentMonth))
                    .font(.headline)

                Spacer()

                Button(action: { moveMonth(-1) }) {
                    Image(systemName: "chevron.left")
                }

                Button(action: { moveMonth(1) }) {
                    Image(systemName: "chevron.right")
                }
            }

            HStack {
                ForEach(["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(days, id: \.self) { date in
                    if let date = date {
                        Text("\(calendar.component(.day, from: date))")
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .fill(isSelected(date) ? Color.blue.opacity(0.3) : Color.clear)
                            )
                            .onTapGesture {
                                selectedDate = date
                            }
                    } else {
                        Text("")
                            .frame(maxWidth: .infinity, minHeight: 40)
                    }
                }
            }
        }
        .padding()
    }

    private var days: [Date?] {
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let range = calendar.range(of: .day, in: .month, for: start)!

        let firstWeekday = calendar.component(.weekday, from: start)
        let previousMonthDays = Array(repeating: nil as Date?, count: firstWeekday - 1)

        let monthDays = range.map { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: start)
        }

        return previousMonthDays + monthDays
    }

    private func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }

    private func moveMonth(_ value: Int) {
        currentMonth = calendar.date(byAdding: .month, value: value, to: currentMonth)!
    }
}
