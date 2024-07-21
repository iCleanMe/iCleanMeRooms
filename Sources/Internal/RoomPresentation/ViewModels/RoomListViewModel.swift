//
//  RoomListViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation
import iCleanMeRoomsCore

public final class RoomListViewModel: ObservableObject {
    @Published var user: RoomUser
    @Published var allTasks: [RoomTask] = []
    @Published public var sections: [RoomSection] = []
    
    private let datasource: RoomDataSource
    private let navHandler: RoomListNavHandler
    
    public init(datasource: RoomDataSource, navHandler: RoomListNavHandler) {
        self.datasource = datasource
        self.navHandler = navHandler
        self.user = datasource.user
        datasource.$user.assign(to: &$user)
        datasource.$sections.assign(to: &$sections)
        $sections.map { sections in
            return sections.flatMap { section in
                return section.rooms.flatMap({ $0.tasks })
            }
        }
        .assign(to: &$allTasks)
    }
}


// MARK: - DisplayData
public extension RoomListViewModel {
    var isPro: Bool {
        return user.type == .pro
    }
    var noRooms: Bool {
        return sections.flatMap({ $0.rooms }).isEmpty
    }
    var topSectionRooms: [Room] {
        return [
            .init(id: .allRoomId, name: "All Tasks", tasks: allTasks),
            .init(id: .taskReminderRoomId, name: "Task Reminders", tasks: allTasks.filter({ $0.hasReminder }))
        ]
    }
}


// MARK: - NavHandler
extension RoomListViewModel: RoomListNavHandler {
    public func showEditRoom(_ room: Room) {
        navHandler.showEditRoom(room)
    }
    
    public func showDeleteRoom(_ room: Room) {
        navHandler.showDeleteRoom(room)
    }
    
    public func showTasks(for room: Room) {
        navHandler.showTasks(for: room)
    }
    
    public func showAddRoom(isPersonal: Bool) {
        navHandler.showAddRoom(isPersonal: isPersonal)
    }
    
    public func showReorderRooms(section: RoomSection) {
        navHandler.showReorderRooms(section: section)
    }
}


// MARK: - Actions
public extension RoomListViewModel {
    func showAllTasks(for room: Room) {
        navHandler.showTasks(for: room)
    }
}
