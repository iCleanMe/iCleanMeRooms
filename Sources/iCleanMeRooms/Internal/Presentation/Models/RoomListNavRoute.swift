//
//  RoomListNavRoute.swift
//  
//
//  Created by Nikolai Nobadi on 7/12/24.
//

/// Represents the different navigation routes within the room list feature.
enum RoomListNavRoute: Identifiable {
    /// Case for deleting a room.
    case delete(Room)
    
    /// Case for viewing or editing room details.
    case detail(RoomToModify)
    
    /// Case for reordering rooms within a section.
    case reorder(RoomSection)
    
    /// Unique identifier for each navigation route.
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
    
    /// Title for the navigation bar based on the current route.
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
