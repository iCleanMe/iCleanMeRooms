//
//  RoomToModify.swift
//
//
//  Created by Nikolai Nobadi on 7/12/24.
//

enum RoomToModify: Identifiable {
    case new(Room)
    case existing(Room)
}


// MARK: - Helpers
extension RoomToModify {
    var id: String {
        return room.id
    }
    
    var navTitle: String {
        switch self {
        case .new(let room):
            return "New \(room.isPersonal ? "Personal" : "House") Room"
        case .existing(let room):
            return room.name
        }
    }
    
    var room: Room {
        switch self {
        case .new(let room):
            return room
        case .existing(let room):
            return room
        }
    }
}
