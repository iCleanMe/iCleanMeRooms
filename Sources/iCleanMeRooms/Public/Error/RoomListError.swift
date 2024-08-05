//
//  RoomListError.swift
//
//
//  Created by Nikolai Nobadi on 7/9/24.
//

public enum RoomListError: Error {
    case roomLimitReached
    case guestLimitReached
    case nonAdminEdit
    case nonAdminDelete
    case nameTaken(String)
    case emptyName
    case missingRoom
    case nameTooLong
    case cancelDelete
    case corruptData
}
