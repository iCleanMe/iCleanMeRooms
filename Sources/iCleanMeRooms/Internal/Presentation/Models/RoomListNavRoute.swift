//
//  RoomListNavRoute.swift
//  
//
//  Created by Nikolai Nobadi on 7/12/24.
//

enum RoomListNavRoute: Identifiable {
    case delete(Room)
    case detail(RoomToModify)
    case reorder(RoomSection)
}


// MARK: - Helpers
extension RoomListNavRoute {
    var id: String {
        switch self {
        case .delete:
            return "delete"
        case .detail:
            return "detail"
        case .reorder:
            return "reorder"
        }
    }
    
    var navTitle: String {
        switch self {
        case .delete:
            return "Delete Room"
        case .detail(let roomToModify):
            switch roomToModify {
            case .new:
                return "New Room"
            case .existing:
                return "Edit Room"
            }
        case .reorder:
            return "Reorder Rooms"
        }
    }
}
