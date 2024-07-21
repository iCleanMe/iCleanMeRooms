//
//  RoomListNavHandler.swift
//
//
//  Created by Nikolai Nobadi on 7/12/24.
//

import iCleanMeRoomsCore

public protocol RoomListNavHandler {
    func showEditRoom(_ room: Room)
    func showDeleteRoom(_ room: Room)
    func showTasks(for room: Room)
    func showAddRoom(isPersonal: Bool)
    func showReorderRooms(section: RoomSection)
}
