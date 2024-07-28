//
//  ReorderRoomListViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

final class ReorderRoomListViewModel: ObservableObject {
    @Published var roomList: [Room]
    
    private let isPersonal: Bool
    private let saveNewOrder: (RoomSection) async throws -> Void
    
    init(section: RoomSection, saveNewOrder: @escaping (RoomSection) async throws -> Void) {
        self.roomList = section.rooms
        self.isPersonal = section.isPersonal
        self.saveNewOrder = saveNewOrder
    }
}


// MARK: - Actions
extension ReorderRoomListViewModel {
    func saveChanges() async throws {
        try await saveNewOrder(.init(id: "", name: "", rooms: roomList, isPersonal: isPersonal))
    }
}
