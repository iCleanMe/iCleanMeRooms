//
//  RoomTaskListType.swift
//
//
//  Created by Nikolai Nobadi on 7/15/24.
//

import iCleanMeRoomsCore

public enum RoomTaskListType: Hashable {
    case all
    case single(Room)
    case onlyReminders
}
