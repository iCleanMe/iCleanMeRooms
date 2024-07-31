//
//  RoomSection+UIExtensions.swift
//
//
//  Created by Nikolai Nobadi on 7/31/24.
//

import iCleanMeSharedUI

extension RoomSection {
    var gradient: GradientType {
        return type.gradient
    }
}

extension RoomSectionType {
    var gradient: GradientType {
        switch self {
        case .house:
            return .seaNight
        case .personal:
            return .sunset
        }
    }
}
