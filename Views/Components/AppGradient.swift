//
//  AppGradient.swift
//  McdDelivery
//
//  Created by Mac on 2025-12-14.
//

import SwiftUI

struct AppGradient {
    static let primary = LinearGradient(
        colors: [
            Color.yellow.opacity(10),
            Color.white.opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
