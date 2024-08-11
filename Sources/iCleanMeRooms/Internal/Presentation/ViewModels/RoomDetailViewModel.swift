//
//  RoomDetailViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/9/24.
//

import Foundation

/// The view model responsible for managing the details of a room.
final class RoomDetailViewModel: ObservableObject {
    @Published public var room: Room
    
    private let datasource: RoomDataSource
    private let delegate: RoomDetailDelegate
    
    /// Initializes the view model with the given room, delegate, and data source.
    init(room: Room, delegate: RoomDetailDelegate, datasource: RoomDataSource) {
        self.room = room
        self.delegate = delegate
        self.datasource = datasource
    }
}


// MARK: - DisplayData
extension RoomDetailViewModel {
    /// The title to display in the room detail view.
    var title: String {
        guard canAddRoom else { return "You've reached your house-room limit." }
        return isNewRoom ? "What would you like to call your new room?" : "Declare the new name of your room!"
    }
    
    /// Indicates whether the user is a guest.
    var isGuest: Bool {
        return user.type == .guest
    }
    
    /// Indicates whether the room is new.
    var isNewRoom: Bool {
        return room.id.isEmpty
    }
    
    /// Indicates whether the room is personal.
    var isPersonal: Bool {
        return room.isPersonal
    }
    
    /// The message to display in the room detail view.
    var message: String {
        return isPersonal ? personalRoomMessage : houseRoomMessage
    }
    
    /// The prompt to display in the text field for the room name.
    var textFieldPrompt: String {
        return isNewRoom ? "New Room Name..." : room.name
    }
    
    /// Indicates whether the user can add a room.
    var canAddRoom: Bool {
        guard isNewRoom && !isPersonal, let roomLimit = user.roomLimit else { return true }
        return currentRoomCount < roomLimit
    }
    
    /// Indicates whether the user can save the room.
    var canSave: Bool {
        return !room.name.isEmpty
    }
}

// MARK: - Actions
extension RoomDetailViewModel {
    
    /// Saves the room.
    func saveRoom() async throws {
        if isNewRoom {
            try await delegate.saveNewRoom(room.addingId())
        } else {
            try await delegate.updateRoom(room)
        }
    }
}

// MARK: - Private
private extension RoomDetailViewModel {
    
    /// The current user of the room.
    var user: RoomUser {
        return datasource.user
    }
    
    /// The current count of rooms in the house section.
    var currentRoomCount: Int {
        return datasource.houseSection.rooms.count
    }
    
    /// The message to display for a house room.
    var houseRoomMessage: String {
        guard canAddRoom else {
            let prefix = "In order to add more rooms,"
            let action = isGuest ? "create an account by adding linking to a sign-in method (Settings > Profile)" : "upgrade to iCleanMePro"
            let suffix = ", or delete another room to make space for a new one."
            return "\(prefix) \(action) \(suffix)"
        }
        return "This \(isNewRoom ? "will be" : "is") a HOUSEHOLD Room. It \(isNewRoom ? "will be" : "is") available to EVERYONE in your household."
    }
    
    /// The message to display for a personal room.
    var personalRoomMessage: String {
        return "This \(isNewRoom ? "will be" : "is") a PERSONAL Room. It \(isNewRoom ? "will NOT be" : "is NOT") available to anyone but you."
            .skipLine("\(isNewRoom ? "If you would like this room to be shared with your household, tap the 'X' in the top right corner, then tap the Household section of the selector at the top of the Room List View, THEN tap the '+' button to add a House Room." : "")")
    }
}


// MARK: - Dependencies
/// A protocol defining the required actions for managing room details.
public protocol RoomDetailDelegate {
    func updateRoom(_ room: Room) async throws
    func saveNewRoom(_ room: Room) async throws
}


// MARK: - Extension Dependencies
fileprivate extension Room {
    /// Adds an ID to the room if it does not already have one.
    func addingId() -> Room {
        guard id.isEmpty else {
            return self
        }
        
        var updated = self
        updated.id = UUID().uuidString
        return updated
    }
}

fileprivate extension RoomUser {
    /// The room limit for the user.
    var roomLimit: Int? {
        switch type {
        case .pro:
            return nil
        case .guest:
            return 4
        case .normal:
            return 7
        }
    }
}

fileprivate extension String {
    func skipLine(_ text: String) -> String {
        return "\(self)\n\n\(text)"
    }
}
