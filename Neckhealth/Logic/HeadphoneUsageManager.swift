import HealthKit

class HeadphoneUsageManager {
    static let shared = HeadphoneUsageManager()
    private let healthStore = HKHealthStore()
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard let headphoneExposureType = HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure) else {
            completion(false, nil)
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [headphoneExposureType]) { success, error in
            completion(success, error)
        }
    }
    
    func fetchHeadphoneUsageTime(start: Date, end: Date, completion: @escaping (TimeInterval?, Error?) -> Void) {
        guard let headphoneType = HKObjectType.quantityType(forIdentifier: .headphoneAudioExposure) else {
            completion(nil, nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        
        // 샘플 쿼리 사용
        let query = HKSampleQuery(sampleType: headphoneType,
                                predicate: predicate,
                                limit: HKObjectQueryNoLimit,
                                sortDescriptors: nil) { (_, samples, error) in
            
            guard let samples = samples as? [HKQuantitySample], error == nil else {
                completion(nil, error)
                return
            }
            
            // 총 시간 계산
            var totalTime: TimeInterval = 0
            for sample in samples {
                let duration = sample.endDate.timeIntervalSince(sample.startDate)
                totalTime += duration
            }
            
            DispatchQueue.main.async {
                completion(totalTime, nil)
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayUsage(completion: @escaping (TimeInterval?, Error?) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        fetchHeadphoneUsageTime(start: startOfDay, end: now, completion: completion)
    }
    
    func fetchWeeklyUsage(completion: @escaping (TimeInterval?, Error?) -> Void) {
        let calendar = Calendar.current
        let now = Date()
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now) else {
            completion(nil, nil)
            return
        }
        
        fetchHeadphoneUsageTime(start: oneWeekAgo, end: now, completion: completion)
    }
    
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = Int(interval) / 60 % 60
        
        if hours > 0 {
            return "\(hours)시간 \(minutes)분"
        } else {
            return "\(minutes)분"
        }
    }
}
