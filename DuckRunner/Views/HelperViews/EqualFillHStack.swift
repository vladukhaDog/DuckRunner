//
//  EqualFillHStack.swift
//  DuckRunner
//
//  Created by vladukha on 16.02.2026.
//
import SwiftUI

/// Custom layout that fills horizontal space and gives each element the same space 
struct EqualFillHStack: Layout {
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        // Return a size.
        guard !subviews.isEmpty else { return .zero }

        let maxSize = maxSize(subviews: subviews)

        return CGSize(
            width: proposal.width ?? 100,
            height: maxSize.height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        // Place child views.
        guard !subviews.isEmpty else { return }
      
        let maxSize = maxSize(subviews: subviews)

        let elementWidthMax = bounds.width / CGFloat(subviews.count)
        let placementProposal = ProposedViewSize(width: elementWidthMax, height: maxSize.height)
        
        var x = bounds.minX + elementWidthMax / 2
        
        
        for index in subviews.indices {
            subviews[index].place(
                at: CGPoint(x: x, y: bounds.midY),
                anchor: .center,
                proposal: placementProposal)
            x += elementWidthMax
        }
    }
    private func maxSize(subviews: Subviews) -> CGSize {
        let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let maxSize: CGSize = subviewSizes.reduce(.zero) { currentMax, subviewSize in
            CGSize(
                width: max(currentMax.width, subviewSize.width),
                height: max(currentMax.height, subviewSize.height))
        }

        return maxSize
    }
}
