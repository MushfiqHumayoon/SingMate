//
//  BarView.swift
//  SingMate
//
//  Created by Mushfiq Humayoon on 02/04/24.
//

import SwiftUI

struct BarView: View {
    var value: CGFloat // This value should be between 0 and 1 for simplicity
    var color: Color = .blue

    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(color)
            // Apply scale effect vertically based on `value`
            .scaleEffect(x: 1, y: value, anchor: .bottom)
            .frame(width: 10, height: 300) // Max height
            .animation(.linear, value: value)
    }
}
