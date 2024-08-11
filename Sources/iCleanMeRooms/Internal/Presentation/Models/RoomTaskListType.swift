//
//  RoomTaskListType.swift
//
//
//  Created by Nikolai Nobadi on 7/15/24.
//

/// An enumeration that defines the different types of room task lists.
public enum RoomTaskListType: Hashable {
    case all
    case single(Room)
    case onlyReminders
}
