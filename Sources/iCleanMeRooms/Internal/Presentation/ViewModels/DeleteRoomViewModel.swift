//
//  DeleteRoomViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

/// The view model responsible for handling the deletion of a room.
final class DeleteRoomViewModel: ObservableObject {
    private let room: Room
    private let datasource: RoomDataSource
    private let deleteRoom: (Room) async throws -> Void
    
    /// Initializes the view model with the given room, data source, and delete action.
    init(room: Room, datasource: RoomDataSource, deleteRoom: @escaping (Room) async throws -> Void) {
        self.room = room
        self.datasource = datasource
        self.deleteRoom = deleteRoom
    }
}


// MARK: - DisplayData
extension DeleteRoomViewModel {
    /// The list of tasks associated with the room.
    var taskList: [RoomTask] {
        return room.tasks
    }
    
    /// Indicates whether the user can delete the room.
    var canDelete: Bool {
        return datasource.user.hasEditPermission
    }
    
    /// Indicates whether the room has no tasks.
    var noTasks: Bool {
        return room.tasks.isEmpty
    }
    
    /// The text to display on the delete button.
    var deleteButtonText: String {
        return "Delete Room\(room.tasks.isEmpty ? "" : " & Tasks")"
    }
    
    /// The text to display when the user does not have permission to delete the room.
    var noPermissionText: String {
        return "You do not have permission to delete this room. Please ask a house admin to perform the delete."
    }
}


// MARK: - Actions
extension DeleteRoomViewModel {
    /// Deletes the room.
    func deleteRoom() async throws {
        try await deleteRoom(room)
    }
}
