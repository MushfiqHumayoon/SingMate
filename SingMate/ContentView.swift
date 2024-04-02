//
//  ContentView.swift
//  SingMate
//
//  Created by Mushfiq Humayoon on 29/03/24.
//

import SwiftUI

struct AudioVisualizerView: View {
    @ObservedObject var audioAnalyzer = AudioAnalyzer()
    
    var body: some View {
//        HStack(spacing: 4) {
//            ForEach(audioAnalyzer.audioLevels.indices, id: \.self) { index in
//                BarView(value: audioAnalyzer.audioLevels[index])
//            }
//        }
        
        CircularVisualizerView(audioLevels: audioAnalyzer.audioLevels)
            .overlay(content: {
                Circle()
                    .frame(width: 200, height: 200)
                Image(.gadi)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .mask {
                        Circle()
                            .frame(width: 195, height: 195)
                    }
            })
        .onAppear {
            audioAnalyzer.startMonitoring()
        }
        .onDisappear {
            audioAnalyzer.stopMonitoring()
        }
    }
}

