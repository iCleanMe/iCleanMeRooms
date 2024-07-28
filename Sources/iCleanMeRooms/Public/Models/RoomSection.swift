//
//  RoomSection.swift
//
//
//  Created by Nikolai Nobadi on 7/7/24.
//

public struct RoomSection: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let rooms: [Room]
    public let isPersonal: Bool
    
    public init(id: String, name: String, rooms: [Room], isPersonal: Bool = false) {
        self.id = id
        self.name = name
        self.rooms = rooms
        self.isPersonal = isPersonal
    }
}
