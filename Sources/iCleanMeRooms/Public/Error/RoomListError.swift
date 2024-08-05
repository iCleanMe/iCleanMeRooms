//
//  RoomListError.swift
//
//
//  Created by Nikolai Nobadi on 7/9/24.
//

//import iCleanMeSharedUI

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


// MARK: - DisplayableError
//extension RoomListError: DisplayableError {
//    public var message: String {
//        switch self {
//        case .roomLimitReached:
//            return "\(addRoomErrorPrefix) upgrade to iCleanMe Pro \(addRoomErrorSuffix)"
//        case .guestLimitReached:
//            return "\(addRoomErrorPrefix) create an account by adding a sign-in method (Settings > Profile) \(addRoomErrorSuffix)"
//        case .nonAdminEdit:
//            return "Only house admins are allowed to edit room names."
//        case .nonAdminDelete:
//            return "Only house admins are allowed to delete rooms."
//        case .nameTaken(let name):
//            return "There's already a room named \(name). Please select another name."
//        case .emptyName:
//            return "Plants need sunlight, fish need water, and rooms need names. You didn't enter a name for the room. Please do so next time."
//        case .nameTooLong:
//            return "Apologies, but that name is too long for this tiny screen. Please choose a shorter name for your room."
//        case .cancelDelete:
//            return "Your room will NOT be deleted"
//        case .missingRoom:
//            return "Apologies, but the room you want to edit no longer exists, or something terrible has happened to the data. Please try again."
//        case .corruptData:
//            return "Something horrible went wrong with your data. If you continue experiencing problems, please send me feedback (which you can do from Settings)"
//        }
//    }
//}
//
//
//// MARK: - Private Helpers
//private extension RoomListError {
//    private var addRoomErrorSuffix: String {
//        "or delete another room to make space."
//    }
//    
//    private var addRoomErrorPrefix: String {
//        """
//        You've reached your house room limit.
//        
//        In order to add more rooms, please
//        """
//    }
//}
