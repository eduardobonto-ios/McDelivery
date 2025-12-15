//
//  AppBackground.swift
//  McdDelivery
//
//  Created by Mac on 2025-12-14.
//

import SwiftUI

struct AppBackground {

    static let gradient = LinearGradient(
        colors: [
            Color(red: 0.92, green: 0.12, blue: 0.18),   // main red
            Color(red: 0.75, green: 0.05, blue: 0.12),   // darker depth
            Color(red: 0.55, green: 0.02, blue: 0.08)    // shadow tone
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
