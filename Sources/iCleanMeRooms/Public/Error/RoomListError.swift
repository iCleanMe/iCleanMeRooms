//
//  RoomListError.swift
//
//
//  Created by Nikolai Nobadi on 7/9/24.
//

/// An enumeration representing the different errors that can occur while managing rooms in the iCleanMe app.
public enum RoomListError: Error {
    /// Error when the user has reached the maximum number of rooms allowed.
    case roomLimitReached
    
    /// Error when a guest user tries to perform an action restricted to registered users.
    case guestLimitReached
    
    /// Error when a non-admin user attempts to edit a room.
    case nonAdminEdit
    
    /// Error when a non-admin user attempts to delete a room.
    case nonAdminDelete
    
    /// Error when a room name is already taken.
    /// - Parameter name: The name that is already in use.
    case nameTaken(String)
    
    /// Error when the room name is empty.
    case emptyName
    
    /// Error when the specified room is not found.
    case missingRoom
    
    /// Error when the room name exceeds the allowed length.
    case nameTooLong
    
    /// Error when the user cancels the deletion of a room.
    case cancelDelete
}
