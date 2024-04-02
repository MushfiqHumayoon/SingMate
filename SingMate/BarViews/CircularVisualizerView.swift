//
//  CircularVisualizerView.swift
//  SingMate
//
//  Created by Mushfiq Humayoon on 02/04/24.
//

import SwiftUI

struct CircularVisualizerView: View {
    var audioLevels: [CGFloat] // Array of audio levels
    
    var body: some View {
        ZStack {
            ForEach(audioLevels.indices, id: \.self) { index in
                CircularBarView(value: audioLevels[index], index: index, totalBars: audioLevels.count, radius: 100)
            }
        }
        .frame(width: 250, height: 250)
    }
}
