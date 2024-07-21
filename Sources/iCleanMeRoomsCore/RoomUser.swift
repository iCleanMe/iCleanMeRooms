//
//  RoomUser.swift
//
//
//  Created by Nikolai Nobadi on 7/12/24.
//

public struct RoomUser: Equatable {
    public let type: RoomUserType
    public let hasEditPermission: Bool
    
    public init(type: RoomUserType, hasEditPermission: Bool) {
        self.type = type
        self.hasEditPermission = hasEditPermission
    }
}


// MARK: - Dependencies
public enum RoomUserType {
    case guest, normal, pro
}
