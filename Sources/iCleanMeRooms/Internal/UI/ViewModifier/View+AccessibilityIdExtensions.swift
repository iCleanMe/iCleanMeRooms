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


// MARK: - RoomDetail
extension View {
    func setRoomDetailIdAccessId(_ id: RoomDetailAccessibilityId) -> some View {
        accessibilityIdentifier(id.rawValue)
    }
}


// MARK: - DeleteRoom
extension View {
    func setDeleteRoomIdAccessId(_ id: DeleteRoomAccessibilityId) -> some View {
        accessibilityIdentifier(id.rawValue)
    }
}


// MARK: - ReorderRoom
extension View {
    func setReorderRoomIdAccessId(_ id: ReorderRoomAccessibilityId) -> some View {
        accessibilityIdentifier(id.rawValue)
    }
}
