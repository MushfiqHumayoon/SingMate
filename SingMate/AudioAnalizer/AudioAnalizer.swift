//
//  AudioAnalizer.swift
//  SingMate
//
//  Created by Mushfiq Humayoon on 29/03/24.
//

import AVFoundation
import SwiftUI
import Accelerate

class AudioAnalyzer: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var audioPlayerNode = AVAudioPlayerNode()
    private var audioFile: AVAudioFile?
    private var timer: Timer?
    @Published var audioLevels: [CGFloat] = Array(repeating: 0.5, count: 200)
    
    func startMonitoring() {
            // Reset the audio engine and player node to a clean state
        audioEngine.stop()
        audioEngine.reset()
        audioPlayerNode.stop()
        guard let fireWork = Bundle.main.url(forResource: "CalmDown", withExtension: "mp3") else {
            print("couldn't get the audio")
            return
        }
        do {
            audioFile = try AVAudioFile(forReading: fireWork)
            guard let audioFile = audioFile else { return }
            audioEngine.attach(audioPlayerNode)
            audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
            audioEngine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: audioFile.processingFormat) { [weak self] (buffer, _) in
                self?.updateAudioLevels(buffer: buffer)
            }

            audioEngine.prepare()
            
            audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
            try audioEngine.start()

            // Play the audio
            audioPlayerNode.play()

        } catch {
            print("Error starting audio engine or playing file: \(error.localizedDescription)")
        }
    }
    
    func stopMonitoring() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    private func updateAudioLevels(buffer: AVAudioPCMBuffer) {
        let frameCount = Int(buffer.frameLength)
        guard let channelData = buffer.floatChannelData?[0] else { return } // Ensure we have channel data

        let numberOfSegments = self.audioLevels.count
        let segmentLength = frameCount / numberOfSegments

        DispatchQueue.main.async {
            for i in 0..<numberOfSegments {
                let start = i * segmentLength
                let end = min((i + 1) * segmentLength, frameCount)

                var segmentSamples = [Float]()
                for j in start..<end {
                    segmentSamples.append(channelData[j])
                }

                // Calculate the RMS for the segment
                var rms: Float = 0
                vDSP_rmsqv(segmentSamples, 1, &rms, vDSP_Length(segmentSamples.count))
                
                // Normalize and update audioLevels as before
                let normalizedLevel = min(max(rms, 0.0), 1.0)
                self.audioLevels[i] = CGFloat(normalizedLevel)
            }
        }
    }

    func startPlayingAndMonitoring() {
        guard let fireWork = Bundle.main.url(forResource: "FireWork", withExtension: "mp3") else {
            print("couldn't get the audio")
            return
        }
        let file = try! AVAudioFile(forReading: fireWork)
        let audioPlayerNode = AVAudioPlayerNode()
        
        audioEngine.attach(audioPlayerNode)
        audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: file.processingFormat)
        
        audioPlayerNode.scheduleFile(file, at: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }

}
