import SwiftUI
import Charts

struct StressView: View {
    @State private var stressLevel: Int? = nil
    @State private var stressHistory: [StressData] = []
    @State private var isMeasuring = false
    @State private var isBlurred = true
    
    private let stressURL = "http://211.186.4.119:5000/predict_stress"
    
    var body: some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                Text("My\nStress Level")
                    .font(.system(size: 24))
                    .bold()
                    .lineSpacing(4)
                    .padding(.leading, 10)
                Spacer()
                Button(action: measureStress) {
                    Text(isMeasuring ? "Measuring..." : (stressLevel == nil ? "Measure" : "Re:Measure"))
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(isMeasuring ? Color(.systemGray4) : Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(27)
                }
                .padding(.trailing, 5)
            }
            .padding()
            .padding(.top, 10)
            
            // 메인 카드
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                
                VStack(alignment: .leading, spacing: 24) {
                    if let stressLevel = stressLevel {
                        VStack(alignment: .leading, spacing: 24) {
                            // 스트레스 바
                            StressBar(stressLevel: stressLevel)
                            
                            // 현재 스트레스 수치
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Stress Level")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("Lv. \(stressLevel)")
                                    .font(.title2)
                                    .bold()
                            }
                            
                            // 차트
                            StressChart(stressHistory: stressHistory)
                                .frame(height: 200)
                                .padding(.bottom, -15)
                        }
                    } else {
                        Text("Please Measure First.")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(24)
                .blur(radius: isBlurred ? 5 : 0)
                .overlay(
                    isBlurred ? Text("Please Measure First.")
                        .font(.headline)
                        .padding()
                        .background(Color(.systemGray6).opacity(0.8))
                        .cornerRadius(10) : nil
                )
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
        )
        .onAppear {
            stressHistory = loadStressHistory()
        }
        .frame(height: 400)
        .frame(maxWidth: 340)
    }
    
    private func measureStress() {
            guard !isMeasuring else { return }
            isMeasuring = true
            isBlurred = false
            
            let roll = Double.random(in: 0...10)
            let pitch = Double.random(in: 0...10)
            
            let payload = ["rolling": roll, "pitching": pitch]
            guard let url = URL(string: stressURL) else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: payload)
            } catch {
                print("JSON serialization failed: \(error)")
                isMeasuring = false
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                defer { isMeasuring = false }
                
                if let error = error {
                    print("Request error: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No response data")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let stressLevel = json["stress_level"] as? Double {
                        let roundedStress = Int(stressLevel.rounded())
                        
                        DispatchQueue.main.async {
                            self.stressLevel = roundedStress
                            let newData = StressData(date: Date(), level: Double(roundedStress))
                            self.stressHistory.append(newData)
                            saveStressHistory(self.stressHistory)
                        }
                    }
                } catch {
                    print("JSON parsing error: \(error)")
                }
            }.resume()
        }
        
        private func saveStressHistory(_ history: [StressData]) {
            if let encoded = try? JSONEncoder().encode(history) {
                UserDefaults.standard.set(encoded, forKey: "stressHistory")
            }
        }
        
        private func loadStressHistory() -> [StressData] {
            if let data = UserDefaults.standard.data(forKey: "stressHistory"),
               let history = try? JSONDecoder().decode([StressData].self, from: data) {
                return history
            }
            return []
        }
    }

