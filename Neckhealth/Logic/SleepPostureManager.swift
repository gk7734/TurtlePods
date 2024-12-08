import SwiftUI
import CoreMotion
import Combine

class SleepPostureManager: ObservableObject {
    private var motionManager = CMHeadphoneMotionManager()
    private var timer: Timer?
    
    @Published var currentPosture: SleepPosture = .unknown
    @Published var postureHistory: [PostureRecord] = []
    @Published var isMonitoring: Bool = false
    @Published var postureChangeCount: Int = 0
    
    struct PostureRecord: Identifiable {
        let id = UUID()
        let posture: SleepPosture
        let timestamp: Date
        let duration: TimeInterval
    }
    
    enum SleepPosture: Hashable {
        case supine
        case leftSide
        case rightSide
        case prone
        case unknown
        
        var description: String {
            switch self {
            case .supine: return "Supine Position"
            case .leftSide: return "Lying on Left Side"
            case .rightSide: return "Lying on Right Side"
            case .prone: return "Prone Position"
            case .unknown: return "Analyzing Position..."
            }
        }
        
        var recommendation: String {
            switch self {
                case .supine: return "This is a comfortable posture.\nIt is better to use a thin pillow under your neck."
                case .leftSide: return "This is good posture.\nYou may find it more comfortable to place a pillow between your Knees."
                case .rightSide: return "This is good posture.\nYou may find it more comfortable to place a pillow between your Knees."
                case .prone: return "This position can put strain on your neck and back.\nWe recommend changing your posture."
                case .unknown: return "Analyzing Position..."
            }
        }
    }
        
    
    init() {
        setupMotionManager()
    }
    
    private func setupMotionManager() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Headphone motion is not available")
            return
        }
    }
    
    func startMonitoring() {
        isMonitoring = true
        postureChangeCount = 0 // 초기화
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] motion, error in
            guard let self = self,
                  let motion = motion,
                  error == nil else {
                return
            }
            
            self.analyzePosture(motion: motion)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.recordCurrentPosture()
        }
    }
    
    private func analyzePosture(motion: CMDeviceMotion) {
        let pitch = motion.attitude.pitch
        let roll = motion.attitude.roll
        
        let newPosture: SleepPosture = {
            if abs(pitch) < 0.3 && abs(roll) < 0.3 {
                return .supine
            } else if roll > 1.0 {
                return .rightSide
            } else if roll < -1.0 {
                return .leftSide
            } else if abs(pitch) > 1.3 {
                return .prone
            }
            return .unknown
        }()
        
        if newPosture != currentPosture {
            currentPosture = newPosture
            postureChangeCount += 1
            if newPosture == .prone {
                print("..")
            }
        }
    }
    
    private func recordCurrentPosture() {
        let record = PostureRecord(
            posture: currentPosture,
            timestamp: Date(),
            duration: 300
        )
        postureHistory.append(record)
    }
    
    func stopMonitoring() {
        isMonitoring = false
        motionManager.stopDeviceMotionUpdates()
        timer?.invalidate()
        timer = nil
    }
    
    func generateSleepReport() -> SleepReport {
        let totalDuration = postureHistory.reduce(0) { $0 + $1.duration }
        let posturePercentages = Dictionary(grouping: postureHistory, by: { $0.posture })
            .mapValues { records in
                let postureDuration = records.reduce(0) { $0 + $1.duration }
                return (postureDuration / totalDuration) * 100
            }
        
        return SleepReport(
            date: Date(),
            totalSleepDuration: totalDuration,
            posturePercentages: posturePercentages,
            recommendations: generateRecommendations(from: posturePercentages),
            sleepQuality: evaluateSleepQuality(totalDuration: totalDuration, percentages: posturePercentages)
        )
    }
    
    private func generateRecommendations(from percentages: [SleepPosture: Double]) -> [String] {
        var recommendations: [String] = []
        
        if let pronePercentage = percentages[.prone], pronePercentage > 20 {
            recommendations.append("I spend a lot of time sleeping on my stomach. To keep your neck healthy, lie down on your back or on your side.")
        }
        
        if let supinePercentage = percentages[.supine], supinePercentage < 30 {
            recommendations.append("Try increasing the time you spend sleeping on your back.")
        }
        
        return recommendations
    }
    
    private func evaluateSleepQuality(totalDuration: TimeInterval, percentages: [SleepPosture: Double]) -> String {
        let proneTime = (percentages[.prone] ?? 0) * totalDuration / 100
        let proneThreshold = totalDuration * 0.2 // 엎드린 자세가 20%를 초과할 경우
        
        let score: Int = {
            var points = 100
            
            // 자세 변경 횟수 점수
            switch postureChangeCount {
            case 0...10: points -= 0
            case 11...20: points -= 10
            case 21...30: points -= 20
            default: points -= 30
            }
            
            // 엎드린 시간 점수
            if proneTime > proneThreshold {
                points -= 20
            }
            
            // 수면 시간 점수
            if totalDuration < 6 * 60 * 60 { // 6시간 미만
                points -= 20
            } else if totalDuration < 8 * 60 * 60 { // 6~8시간
                points -= 10
            }
            
            return points
        }()
        
        // 점수 기반 수면 품질 평가
        switch score {
        case 80...100: return "Very GOOOODD"
        case 60..<80: return "Good"
        case 40..<60: return "Just Okay"
        case 20..<40: return "Bad"
        default: return "Very BADDD"
        }
    }
}
