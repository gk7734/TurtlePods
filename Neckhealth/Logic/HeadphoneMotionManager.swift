import CoreMotion
import Combine

class HeadphoneMotionManager: ObservableObject {
    private var motionManager = CMHeadphoneMotionManager()
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var isAvailable: Bool = false
    @Published var baselinePitch: Double = 0.0 // 영점 보정용
    
    init() {
        checkAvailability()
    }
    
    private func checkAvailability() {
        isAvailable = motionManager.isDeviceMotionAvailable
    }
    
    func startMonitoring() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Headphone motion is not available")
            return
        }
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] motion, error in
            guard let self = self,
                  let motion = motion,
                  error == nil else {
                return
            }
            
            // 실시간으로 pitch, roll 업데이트
            self.pitch = motion.attitude.pitch
            self.roll = motion.attitude.roll
        }
    }
    
    func stopMonitoring() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func calibrate() {
        // 현재 pitch 값 기준 영점 보정
        baselinePitch = pitch
    }
    
    // TODO :: 민감도 프리셋을 이용한 조정
    var neckStatus: String {
        let adjustedPitch = pitch - baselinePitch
        
        // 목이 앞으로 내밀거나 아래로 내려가는 경우 거북목 주의
        if adjustedPitch < -0.18 {
            return "거북목 주의!"
        }
        // 목이 뒤로 젖혀진 경우 안정적인 자세
        else if adjustedPitch > -0.1 {
            return "안정적인 자세"
        }
        // 그 외 자세가 불안정한 경우
        else {
            return "자세를 조정하세요"
        }
    }
    
    deinit {
        stopMonitoring()
    }
}
