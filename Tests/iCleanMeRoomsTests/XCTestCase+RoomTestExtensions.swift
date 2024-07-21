//
//  XCTestCase+RoomTestExtensions.swift
//
//
//  Created by Nikolai Nobadi on 7/19/24.
//

import XCTest
import iCleanMeRoomsCore

extension XCTestCase {
    func makeRoom(id: String = "0", name: String = "Kitchen", isPersonal: Bool = false, tasks: [RoomTask] = []) -> Room {
        return .init(id: id, name: name, isPersonal: isPersonal, tasks: tasks)
    }
    
    func makeTask() -> RoomTask {
        return .init(id: "00", name: "Clean Stove", isClean: false, hasReminder: false)
    }
    
    func makeRoomUser(type: RoomUserType = .normal, hasEditPermission: Bool = true) -> RoomUser {
        return .init(type: type, hasEditPermission: hasEditPermission)
    }
}
