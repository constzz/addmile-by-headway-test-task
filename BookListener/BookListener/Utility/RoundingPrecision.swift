//
//  RoundingPrecision.swift
//  BookListener
//
//  Created by Konstantin Bezzemelnyi on 03.08.2024.
//

import Foundation

enum RoundingPrecision {
    case ones
    case tenths
    case hundredths
}

extension Double {
    func preciceCeil(to precision: RoundingPrecision) -> Double {
        switch precision {
        case .ones:
            return ceil(self)
        case .tenths:
            return ceil(self * 10) / 10.0
        case .hundredths:
            return ceil(self * 100) / 100.0
        }
    }
}
