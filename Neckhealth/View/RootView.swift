import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .turtleNeck
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                
                TurtleNeckView()
                    .tag(Tab.turtleNeck)
                
                SleepMonitoringView()
                    .tag(Tab.sleep)
                
                StressView()
                    .tag(Tab.stress)
                
                AirpodsTimeView()
                    .tag(Tab.airpodstime)
                
            }
            .animation(nil, value: selectedTab)
            
            CustomTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 20)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
