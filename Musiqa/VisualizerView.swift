import SwiftUI

struct VisualizerView: View {
    
    var amplitudes: [Float]
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(amplitudes.indices, id: \.self) { index in
                let progress = Double(index) / Double(max(amplitudes.count - 1, 1))
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hue: 0.65, saturation: 0.9, brightness: 0.95).opacity(0.15),
                                Color(hue: 0.80, saturation: 0.9, brightness: 0.95).opacity(0.6),
                                Color(hue: 0.95, saturation: 0.9, brightness: 0.95).opacity(0.15)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(
                        width: 4,
                        height: CGFloat(amplitudes[index] * 200)
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
        }
        .animation(.linear(duration: 0.05), value: amplitudes)
    }
}
