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
    var gradient: GradientType {
        return isPersonal ? .sunset : .seaNight
    }
    
    static var sampleList: [RoomSection] {
        return [
            .init(id: "house", name: "House Rooms", rooms: Room.houseList),
            .init(id: "personal", name: "Personal Rooms", rooms: Room.personalList, isPersonal: true)
        ]
    }
}
extension RoomDataSource {
    static func previewInit(user: RoomUser = .previewUser(), sections: [RoomSection] = RoomSection.sampleList) -> RoomDataSource {
        return .init(user: user, sections: sections)
    }
}
extension DeleteRoomViewModel {
    static func previewInit(room: Room = .sample, canDelete: Bool = true) -> DeleteRoomViewModel {
        return .init(room: room, datasource: .previewInit(user: .previewUser(hasEditPermission: canDelete)), deleteRoom: { _ in })
    }
}

final class PreviewRoomListNavHandler: RoomListNavHandler {
    func showEditRoom(_ room: Room) { }
    func showDeleteRoom(_ room: Room) { }
    func showTasks(for room: Room) { }
    func showAddRoom(isPersonal: Bool) { }
    func showReorderRooms(section: RoomSection) { }
}

