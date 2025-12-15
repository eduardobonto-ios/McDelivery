//
//  SideMenuItem.swift
//  McdDelivery
//
//  Created by Mac on 2025-12-14.
//

import SwiftUI

struct SideMenuItem: View {

    let icon: String
    let title: String

    var body: some View {
        Button {
            // Navigation logic
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .frame(width: 22)

                Text(title)
                    .font(.system(size: 16, weight: .medium))

                Spacer()
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .foregroundColor(.white)
    }
}
