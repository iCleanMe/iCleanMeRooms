//
//  RoomTaskListType.swift
//
//
//  Created by Nikolai Nobadi on 7/15/24.
//

public enum RoomTaskListType: Hashable {
    case all
    case single(Room)
    case onlyReminders
}
