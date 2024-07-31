//
//  ReorderRoomListViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

final class ReorderRoomListViewModel: ObservableObject {
    @Published var roomList: [Room]
    
    private let type: RoomSectionType
    private let saveNewOrder: (RoomSection) async throws -> Void
    
    init(section: RoomSection, saveNewOrder: @escaping (RoomSection) async throws -> Void) {
        self.type = section.type
        self.roomList = section.rooms
        self.saveNewOrder = saveNewOrder
    }
}


// MARK: - Actions
extension ReorderRoomListViewModel {
    func saveChanges() async throws {
        try await saveNewOrder(.init(type: type, rooms: roomList))
    }
}
