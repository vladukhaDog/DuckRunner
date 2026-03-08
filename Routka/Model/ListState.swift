//
//  ListState.swift
//  Routka
//
//  Created by vladukha on 08.03.2026.
//
import Foundation

enum ListState<T: Equatable>: Equatable{
    case loading
    case list(Array<T>)
}
