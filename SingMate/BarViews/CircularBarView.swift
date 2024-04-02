//
//  CircularBarView.swift
//  SingMate
//
//  Created by Mushfiq Humayoon on 02/04/24.
//

import SwiftUI

struct CircularBarView: View {
    var value: CGFloat // The normalized height of the bar (0 to 1 for example)
    var index: Int // Position in the circle
    
    let totalBars: Int
    let radius: CGFloat
    let minHeight: CGFloat = 10 // Set the minimum height for a bar here
    
    private var angle: Double {
        Double(index) * (360 / Double(totalBars))
    }
    
    private var xOffset: CGFloat {
        radius * cos(CGFloat(angle).degreesToRadians)
    }
    
    private var yOffset: CGFloat {
        radius * sin(CGFloat(angle).degreesToRadians)
    }
    
    var body: some View {
        // Ensure the bar has at least the minimum height
        let barHeight = max(value * 100, minHeight)
        
        RoundedRectangle(cornerRadius: 2)
            .frame(width: 2, height: barHeight)
            .rotationEffect(Angle(degrees: angle - 90)) // Align to circle
            .offset(x: xOffset, y: yOffset)
            .animation(.linear, value: value)
    }
}


// Extension to convert degrees to radians
extension CGFloat {
    var degreesToRadians: CGFloat {
        self * .pi / 180
    }
}
