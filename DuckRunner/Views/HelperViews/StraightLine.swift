//
//  StraightLine.swift
//  DuckRunner
//
//  Created by vladukha on 03.03.2026.
//
import SwiftUI

struct StraightLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
