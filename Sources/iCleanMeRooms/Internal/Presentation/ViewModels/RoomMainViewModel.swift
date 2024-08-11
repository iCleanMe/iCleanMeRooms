//
//  RoomMainViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

/// The main view model for handling navigation and actions in the Room module.
final class RoomMainViewModel: ObservableObject {
    @Published var navRoute: RoomListNavRoute?
    
    private let delegate: RoomDelegate
    private let showTaskList: (RoomTaskListType) -> Void
    
    /// Initializes the view model with the given delegate and task list handler.
    init(delegate: RoomDelegate, showTaskList: @escaping (RoomTaskListType) -> Void) {
        self.delegate = delegate
        self.showTaskList = showTaskList
    }
}


// MARK: - Actions
extension RoomMainViewModel {
    /// Deletes the specified room.
    func deleteRoom(_ room: Room) async throws {
        try await delegate.deleteRoom(room)
        await dismissSheet()
    }
    
    /// Saves the new order of rooms in the specified section.
    func saveNewOrder(_ section: RoomSection) async throws {
        try await delegate.saveNewOrder(section.rooms, isPersonal: section.isPersonal)
        await dismissSheet()
    }
}


// MARK: - RoomDetailDelegate
extension RoomMainViewModel: RoomDetailDelegate {
    /// Updates the specified room.
    public func updateRoom(_ room: Room) async throws {
        try await delegate.updateRoom(room)
        await dismissSheet()
    }
    
    /// Saves a new room.
    public func saveNewRoom(_ room: Room) async throws {
        try await delegate.saveNewRoom(room)
        await dismissSheet()
    }
}


// MARK: - RoomListNavHandler
extension RoomMainViewModel: RoomListNavHandler {
    /// Shows the edit room view for the specified room.
    public func showEditRoom(_ room: Room) {
        self.navRoute = .detail(.existing(room))
    }
    
    /// Shows the delete room view for the specified room.
    public func showDeleteRoom(_ room: Room) {
        self.navRoute = .delete(room)
    }
    
    /// Shows the tasks for the specified room.
    public func showTasks(for room: Room) {
        switch room.id {
        case .allRoomId:
            showTaskList(.all)
        case .taskReminderRoomId:
            showTaskList(.onlyReminders)
        default:
            showTaskList(.single(room))
        }
    }
    
    /// Shows the view to add a new room.
    public func showAddRoom(isPersonal: Bool) {
        self.navRoute = .detail(.new(.init(isPersonal: isPersonal, tasks: [])))
    }
    
    /// Shows the reorder rooms view for the specified section.
    public func showReorderRooms(section: RoomSection) {
        self.navRoute = .reorder(section)
    }
}


// MARK: - Private Methods
@MainActor
private extension RoomMainViewModel {
    
    /// Dismisses the current sheet.
    func dismissSheet() {
        navRoute = nil
    }
}


// MARK: - Dependencies
/// A protocol defining the required actions for room management.
public protocol RoomDelegate {
    func updateRoom(_ room: Room) async throws
    func saveNewRoom(_ room: Room) async throws
    func deleteRoom(_ room: Room) async throws
    func saveNewOrder(_ rooms: [Room], isPersonal: Bool) async throws
}
