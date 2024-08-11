//
//  RoomToModify.swift
//
//
//  Created by Nikolai Nobadi on 7/12/24.
//

/// An enumeration that defines the room to be modified (either new or existing).
enum RoomToModify: Identifiable {
    case new(Room)
    case existing(Room)
    
    // MARK: - Helpers
    
    /// The ID of the room.
    var id: String {
        return room.id
    }
    
    /// The navigation title based on the room type.
    var navTitle: String {
        switch self {
        case .new(let room):
            return "New \(room.isPersonal ? "Personal" : "House") Room"
        case .existing(let room):
            return room.name
        }
    }
    
    /// The room instance.
    var room: Room {
        switch self {
        case .new(let room):
            return room
        case .existing(let room):
            return room
        }
    }
}
