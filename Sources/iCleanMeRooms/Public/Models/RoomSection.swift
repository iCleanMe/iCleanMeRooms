//
//  RoomSection.swift
//
//
//  Created by Nikolai Nobadi on 7/7/24.
//

public struct RoomSection: Identifiable, Equatable {
    public let rooms: [Room]
    public let type: RoomSectionType
    public var id: String {
        return type.id
    }
    
    public init(type: RoomSectionType, rooms: [Room]) {
        self.type = type
        self.rooms = rooms
    }
}


// MARK: - DisplayData
extension RoomSection {
    var name: String {
        return type.title
    }
    
    var isPersonal: Bool {
        return type.isPersonal
    }
}


// MARK: - Helpers
extension RoomSection {
    static var emptyHouseSection: RoomSection {
        return .init(type: .house, rooms: [])
    }
    
    static var emptyPersonalSection: RoomSection {
        return .init(type: .personal, rooms: [])
    }
}


// MARK: - Dependencies
public enum RoomSectionType: String, Identifiable, CaseIterable {
    case house, personal
    
    public var id: String {
        return rawValue
    }
    
    var title: String {
        return "\(rawValue.capitalized) Rooms"
    }
    
    var isPersonal: Bool {
        return self == .personal
    }
}
