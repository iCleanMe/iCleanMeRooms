//
//  RoomDetailViewModel.swift
//
//
//  Created by Nikolai Nobadi on 7/9/24.
//

import Foundation

final class RoomDetailViewModel: ObservableObject {
    @Published public var room: Room
    
    private let datasource: RoomDataSource
    private let delegate: RoomDetailDelegate
    
    init(room: Room, delegate: RoomDetailDelegate, datasource: RoomDataSource) {
        self.room = room
        self.delegate = delegate
        self.datasource = datasource
    }
}


// MARK: - DisplayData
extension RoomDetailViewModel {
    var title: String {
        guard canAddRoom else {
            return "You've reached your house-room limit."
        }
        
        return isNewRoom ? "What would you like call your new room?" : "Declare the new name of your room!"
    }
    
    var isGuest: Bool {
        return user.type == .guest
    }
    
    var isNewRoom: Bool {
        return room.id.isEmpty
    }
    
    var isPersonal: Bool {
        return room.isPersonal
    }
    
    var message: String {
        return isPersonal ? personalRoomMessage : houseRoomMessage
    }
    
    var textFieldPrompt: String {
        return isNewRoom ? "New Room Name..." : room.name
    }
    
    var canAddRoom: Bool {
        guard isNewRoom && !isPersonal, let roomLimit = user.roomLimit else { return true }
        
        return currentRoomCount < roomLimit
    }
}


// MARK: - Actions
extension RoomDetailViewModel {
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
    var user: RoomUser {
        return datasource.user
    }
    var currentRoomCount: Int {
        return datasource.sections.flatMap({ $0.rooms }).count
    }
    var houseRoomMessage: String {
        guard canAddRoom else {
            let prefix = "In order to add more rooms,"
            let action = isGuest ? "create an account by adding linking to a sign-in method (Settings > Profile)" : "upgrade to iCleanMePro"
            let suffix = ", or delete another room to make space for a new one."
            
            return "\(prefix) \(action) \(suffix)"
        }
        
        return "This \(isNewRoom ? "will be" : "is") a HOUSEHOLD Room. It \(isNewRoom ? "will be" : "is") available to EVERYONE in your household."
    }
    var personalRoomMessage: String {
        return "This \(isNewRoom ? "will be" : "is") a PERSONAL Room. It \(isNewRoom ? "will NOT be" : "is NOT") available to anyone but you."
            .skipLine("\(isNewRoom ? "If you would like this room to be shared with your household, tap the 'X' in the top right corner, then tap the Household section of the selector at the top of the Room List View, THEN tap the '+' button to add a House Room." : "")")
    }
}


// MARK: - Dependencies
public protocol RoomDetailDelegate {
    func updateRoom(_ room: Room) async throws
    func saveNewRoom(_ room: Room) async throws
}


// MARK: - Extension Dependencies
extension Room {
    func addingId() -> Room {
        guard id.isEmpty else {
            return self
        }
        
        var updated = self
        updated.id = UUID().uuidString
        return updated
    }
}
extension RoomUser {
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
