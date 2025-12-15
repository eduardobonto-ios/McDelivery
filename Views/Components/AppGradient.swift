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
            Color.blue.opacity(0.8),
            Color.purple.opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
