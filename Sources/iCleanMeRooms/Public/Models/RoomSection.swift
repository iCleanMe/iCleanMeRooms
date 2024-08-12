//
//  RoomSection.swift
//
//
//  Created by Nikolai Nobadi on 7/7/24.
//

/// A struct representing a section of rooms in the app.
public struct RoomSection: Identifiable, Equatable {
    /// A list of rooms in the section.
    public let rooms: [Room]
    
    /// The type of the room section, e.g., house or personal.
    public let type: RoomSectionType
    
    /// The unique identifier for the room section.
    public var id: String {
        return type.id
    }
    
    /// Initializes a new instance of `RoomSection`.
    ///
    /// - Parameters:
    ///   - type: The type of the room section.
    ///   - rooms: A list of rooms in the section.
    public init(type: RoomSectionType, rooms: [Room]) {
        self.type = type
        self.rooms = rooms
    }
}

// MARK: - DisplayData
extension RoomSection {
    /// The name of the room section, derived from its type.
    var name: String {
        return type.title
    }
    
    /// A boolean indicating whether the section is personal.
    var isPersonal: Bool {
        return type.isPersonal
    }
}

// MARK: - Helpers
extension RoomSection {
    /// An empty room section for household rooms.
    static var emptyHouseSection: RoomSection {
        return .init(type: .house, rooms: [])
    }
    
    /// An empty room section for personal rooms.
    static var emptyPersonalSection: RoomSection {
        return .init(type: .personal, rooms: [])
    }
}

// MARK: - Dependencies
/// An enum representing the type of a room section, either house or personal.
public enum RoomSectionType: String, Identifiable, CaseIterable {
    case house, personal
    
    /// The unique identifier for the room section type.
    public var id: String {
        return rawValue
    }
    
    /// The title of the room section, derived from its type.
    var title: String {
        return "\(rawValue.capitalized) Rooms"
    }
    
    /// A boolean indicating whether the section type is personal.
    var isPersonal: Bool {
        return self == .personal
    }
}
