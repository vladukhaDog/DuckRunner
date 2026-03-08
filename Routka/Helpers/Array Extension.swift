//
//  Array Extension.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//
import Foundation

extension Array {
    func chunks(of size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map { i in
            Array(self[i..<Swift.min(i + size, count)])
        }
    }
}
