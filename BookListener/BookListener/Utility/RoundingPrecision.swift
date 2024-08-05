//
//  RoundingPrecision.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import Foundation

// MARK: - RoundingPrecision

enum RoundingPrecision {
    case ones
    case tenths
    case hundredths
}

extension Double {
    func preciceCeil(to precision: RoundingPrecision) -> Double {
        switch precision {
        case .ones:
            ceil(self)
        case .tenths:
            ceil(self * 10) / 10.0
        case .hundredths:
            ceil(self * 100) / 100.0
        }
    }
}
