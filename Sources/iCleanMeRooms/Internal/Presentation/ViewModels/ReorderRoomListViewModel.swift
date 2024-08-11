//
//  ReorderRoomListViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

/// The view model responsible for managing the reorder room list view.
final class ReorderRoomListViewModel: ObservableObject {
    @Published var roomList: [Room]
    
    private let type: RoomSectionType
    private let saveNewOrder: (RoomSection) async throws -> Void
    
    /// Initializes the view model with the given section and save action.
    init(section: RoomSection, saveNewOrder: @escaping (RoomSection) async throws -> Void) {
        self.type = section.type
        self.roomList = section.rooms
        self.saveNewOrder = saveNewOrder
    }
}

// MARK: - Actions
extension ReorderRoomListViewModel {
    /// Saves the new order of rooms in the section.
    func saveChanges() async throws {
        try await saveNewOrder(.init(type: type, rooms: roomList))
    }
}
