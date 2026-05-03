import AVFoundation
import Combine

final class AudioEngine: ObservableObject {
    
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let bus = 0
    
    private let bufferSize: AVAudioFrameCount = 1024
    
    @Published var amplitudes: [Float] = Array(repeating: 0, count: 50)
    
    init() {
        setupEngine()
    }
    
    private func setupEngine() {
        engine.attach(playerNode)
        
        let mainMixer = engine.mainMixerNode
        engine.connect(playerNode, to: mainMixer, format: nil)
        
        installTap()
        
        try? engine.start()
    }
    
    func play(url: URL) {
        let file = try! AVAudioFile(forReading: url)
        playerNode.scheduleFile(file, at: nil)
        playerNode.play()
    }
    
    private func installTap() {
        let node = engine.mainMixerNode
        
        node.installTap(onBus: bus, bufferSize: bufferSize, format: node.outputFormat(forBus: bus)) { [weak self] buffer, _ in
            self?.process(buffer: buffer)
        }
    }
    
    private func process(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)
        
        var newAmplitudes: [Float] = []
        
        let step = max(1, frameLength / 50)
        
        for i in Swift.stride(from: 0, to: frameLength, by: step) {
            let idx = min(i, frameLength - 1)
            let value = abs(channelData[idx])
            newAmplitudes.append(value)
        }
        
        DispatchQueue.main.async {
            self.amplitudes = newAmplitudes
        }
    }
}
