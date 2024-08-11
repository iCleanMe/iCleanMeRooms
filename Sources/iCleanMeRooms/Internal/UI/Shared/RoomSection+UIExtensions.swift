//
//  RoomSection+UIExtensions.swift
//
//
//  Created by Nikolai Nobadi on 7/31/24.
//

import iCleanMeSharedUI

/// Extensions to provide UI-related functionality for RoomSection.
extension RoomSection {
    /// Returns the gradient type associated with the room section type.
    var gradient: GradientType {
        return type.gradient
    }
}

extension RoomSectionType {
    /// Returns the gradient type associated with the room section type.
    var gradient: GradientType {
        switch self {
        case .house:
            return .seaNight
        case .personal:
            return .sunset
        }
    }
}
