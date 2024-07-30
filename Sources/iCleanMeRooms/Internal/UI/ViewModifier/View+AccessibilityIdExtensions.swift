//
//  View+AccessibilityIdExtensions.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

import SwiftUI
import iCleanMeRoomsAccessibility

// MARK: - RoomList
extension View {
    func setRoomListIdAccessId(_ id: RoomListAccessibilityId) -> some View {
        accessibilityIdentifier(id.rawValue)
    }
}
