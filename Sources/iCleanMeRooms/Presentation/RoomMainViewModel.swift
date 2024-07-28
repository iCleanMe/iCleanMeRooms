//
//  RoomMainViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

final class RoomMainViewModel: ObservableObject {
    @Published var navRoute: RoomListNavRoute?
    
    private let delegate: RoomDelegate
    private let showTaskList: (RoomTaskListType) -> Void
    
    init(delegate: RoomDelegate, showTaskList: @escaping (RoomTaskListType) -> Void) {
        self.delegate = delegate
        self.showTaskList = showTaskList
    }
}


// MARK: - Actions
extension RoomMainViewModel {
    func deleteRoom(_ room: Room) async throws {
        try await delegate.deleteRoom(room)
        await dismissSheet()
    }
    
    func saveNewOrder(_ section: RoomSection) async throws {
        try await delegate.saveNewOrder(section.rooms, isPersonal: section.isPersonal)
        await dismissSheet()
    }
}


// MARK: - RoomDetailDelegate
extension RoomMainViewModel: RoomDetailDelegate {
    public func updateRoom(_ room: Room) async throws {
        try await delegate.updateRoom(room)
        await dismissSheet()
    }
    
    public func saveNewRoom(_ room: Room) async throws {
        try await delegate.saveNewRoom(room)
        await dismissSheet()
    }
}

// MARK: - RoomListNavHandler
extension RoomMainViewModel: RoomListNavHandler {
    public func showEditRoom(_ room: Room) {
        self.navRoute = .detail(.existing(room))
    }
    
    public func showDeleteRoom(_ room: Room) {
        self.navRoute = .delete(room)
    }
    
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
    
    public func showAllTasks(room: Room) {
        showTaskList(room.id == .allRoomId ? .all : .onlyReminders)
    }
    
    public func showAddRoom(isPersonal: Bool) {
        self.navRoute = .detail(.new(.init(isPersonal: isPersonal, tasks: [])))
    }
    
    public func showReorderRooms(section: RoomSection) {
        self.navRoute = .reorder(section)
    }
}


// MARK: - Private Methods
@MainActor
private extension RoomMainViewModel {
    func dismissSheet() {
        navRoute = nil
    }
}


// MARK: - Dependencies
public protocol RoomDelegate {
    func updateRoom(_ room: Room) async throws
    func saveNewRoom(_ room: Room) async throws
    func deleteRoom(_ room: Room) async throws
    func saveNewOrder(_ rooms: [Room], isPersonal: Bool) async throws
}


// MARK: - Extension Dependencies

