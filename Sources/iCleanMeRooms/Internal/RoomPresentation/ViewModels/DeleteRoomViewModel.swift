//
//  DeleteRoomViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

final class DeleteRoomViewModel: ObservableObject {
    private let room: Room
    private let datasource: RoomDataSource
    private let deleteRoom: (Room) async throws -> Void
    
    init(room: Room, datasource: RoomDataSource, deleteRoom: @escaping (Room) async throws -> Void) {
        self.room = room
        self.datasource = datasource
        self.deleteRoom = deleteRoom
    }
}


// MARK: - DisplayData
extension DeleteRoomViewModel {
    var taskList: [RoomTask] {
        return room.tasks
    }
    var canDelete: Bool {
        return datasource.user.hasEditPermission
    }
    var noTasks: Bool {
        return room.tasks.isEmpty
    }
    var deleteButtonText: String {
        return "Delete Room\(room.tasks.isEmpty ? "" : " & Tasks")"
    }
    var noPermissionText: String {
        return "You do not have permission to delete this room. Please ask a house admin to perform the delete."
    }
}


// MARK: - Actions
extension DeleteRoomViewModel {
    func deleteRoom() async throws {
        try await deleteRoom(room)
    }
}
