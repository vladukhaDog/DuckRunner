//
//  BackgroundModifier.swift
//  Routka
//
//  Created by vladukha on 04.04.2026.
//

import SwiftUI

extension View {
    func defaultBackground() -> some View {
        self
            .background(backgroundGradient)
    }
}

private var backgroundGradient: some View {
    LinearGradient(colors: [
        Color.blue.opacity(0.12),
        Color.mint.opacity(0.08),
        Color(.systemBackground)
    ], startPoint: .topLeading, endPoint: .bottomTrailing)
    .ignoresSafeArea()
}
