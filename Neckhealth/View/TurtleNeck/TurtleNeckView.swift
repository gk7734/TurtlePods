import SwiftUI

struct TurtleNeckView: View {
    @StateObject private var motionManager = HeadphoneMotionManager()
    
    var statusType: StatusType {
        let adjustedPitch = motionManager.pitch - motionManager.baselinePitch
        if adjustedPitch > -0.1 {
            return .safe
        } else if adjustedPitch >= -0.18 {
            return .caution
        } else {
            return .turtle
        }
    }
    
    var statusMessage: String {
        let status = motionManager.neckStatus
        switch status {
        case "안정적인 자세": return "Stable Posture!"
        case "자세를 조정하세요": return "Adjust your Posture!"
        case "거북목 주의!": return "Beware of Tech Neck!"
        default: return "Check your Posture!"
        }
    }
    
    var statusSubMessage: String {
        let status = motionManager.neckStatus
        switch status {
        case "안정적인 자세": return "Please Maintain Posture for your Neck Health."
        case "자세를 조정하세요": return "Please Change Posture for your Neck Health."
        case "거북목 주의!": return "Please Change Posture Immediately for your Neck Health."
        default: return "Please Check Posture for your Neck Health."
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            // 수평계 뷰
            ZStack {
                ForEach(1...3, id: \.self) { index in
                    Circle()
                        .stroke(Color.black.opacity(0.5), lineWidth: 2)
                        .frame(width: CGFloat(80 * index), height: CGFloat(80 * index))
                }
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 30, height: 30)
                    .offset(
                        x: CGFloat(min(max(motionManager.roll * 200, -100), 100)),
                        y: CGFloat(min(max((motionManager.pitch - motionManager.baselinePitch) * -200, -100), 100))
                    )
                    .animation(.easeOut(duration: 0.2), value: motionManager.pitch)
            }
            .frame(width: 240, height: 240)
            
            // 상태 카드
            StatusCard(
                type: statusType,
                message: statusMessage,
                subMessage: statusSubMessage
            )
            .padding(.horizontal)
            
            // 영점 조절 버튼
            Button(action: {
                motionManager.calibrate()
            }) {
                Text("Adjust Zero Point")
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentColor"))
                    .cornerRadius(20)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            motionManager.startMonitoring()
        }
        .onDisappear {
            motionManager.stopMonitoring()
        }
    }
}
