//
//  RoomPreviewContent.swift
//  
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import iCleanMeSharedUI

extension RoomUser {
    static func previewUser(type: RoomUserType = .normal, hasEditPermission: Bool = true) -> RoomUser {
        return .init(type: type, hasEditPermission: hasEditPermission)
    }
}

extension Room {
    static var sample: Room {
        return .init(id: "0", name: "kitchen", isPersonal: false, tasks: RoomTask.sampleList)
    }
    
    static var houseList: [Room] {
        return [
            .init(id: "0", name: "Kitchen and everything else", tasks: []),
            .init(id: "1", name: "Bathroom", tasks: [.init(id: "0", name: "Clean Toilet", isClean: false, hasReminder: true)]),
            .init(id: "2", name: "Living Room", tasks: [.init(id: "1", name: "Vacuum Rug", isClean: false, hasReminder: false)])
        ]
    }
    
    static var personalList: [Room] {
        return [
            .init(id: "10", name: "My Room", tasks: []),
        ]
    }
}

extension RoomTask {
    static var sampleList: [RoomTask] {
        return [
            .init(id: "0", name: "Clean Stove", isClean: false, hasReminder: false),
            .init(id: "1", name: "Change Sponge", isClean: false, hasReminder: false)
        ]
    }
}

extension RoomSection {
    static var sampleHouseSection: RoomSection {
        .init(type: .house, rooms: Room.houseList)
    }
    
    static var samplePersonalSection: RoomSection {
        .init(type: .house, rooms: Room.personalList)
    }
}

extension RoomDataSource {
    static func previewInit(user: RoomUser = .previewUser(), houseSection: RoomSection = .sampleHouseSection, personalSection: RoomSection = .samplePersonalSection) -> RoomDataSource {
        return .init(user: user, houseSection: houseSection, personalSection: personalSection )
    }
}

extension DeleteRoomViewModel {
    static func previewInit(room: Room = .sample, canDelete: Bool = true) -> DeleteRoomViewModel {
        return .init(room: room, datasource: .previewInit(user: .previewUser(hasEditPermission: canDelete)), deleteRoom: { _ in })
    }
}


// MARK: - Preview Classes
final class PreviewRoomListNavHandler: RoomListNavHandler {
    func showEditRoom(_ room: Room) { }
    func showDeleteRoom(_ room: Room) { }
    func showTasks(for room: Room) { }
    func showAddRoom(isPersonal: Bool) { }
    func showReorderRooms(section: RoomSection) { }
}
