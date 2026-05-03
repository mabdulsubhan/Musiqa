import SwiftUI

struct ContentView: View {
    
    @StateObject private var engine = AudioEngine()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VisualizerView(amplitudes: engine.amplitudes)
                    .frame(height: 200)
                
                Button("Play Audio") {
                    if let url = Bundle.main.url(forResource: "sample", withExtension: "mp3") {
                        engine.play(url: url)
                    }
                }
            }
            .padding()
            .foregroundStyle(.white)
        }
    }
}
