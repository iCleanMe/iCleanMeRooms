//
//  RoomListViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

final class RoomListViewModel: ObservableObject {
    @Published var user: RoomUser
    @Published var allTasks: [RoomTask] = []
    @Published var sections: [RoomSection] = []
    
    private let datasource: RoomDataSource
    private let navHandler: RoomListNavHandler
    
    init(datasource: RoomDataSource, navHandler: RoomListNavHandler) {
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
extension RoomListViewModel {
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
    func showEditRoom(_ room: Room) {
        navHandler.showEditRoom(room)
    }
    
    func showDeleteRoom(_ room: Room) {
        navHandler.showDeleteRoom(room)
    }
    
    func showTasks(for room: Room) {
        navHandler.showTasks(for: room)
    }
    
    func showAddRoom(isPersonal: Bool) {
        navHandler.showAddRoom(isPersonal: isPersonal)
    }
    
    func showReorderRooms(section: RoomSection) {
        navHandler.showReorderRooms(section: section)
    }
}


// MARK: - Actions
extension RoomListViewModel {
    func showAllTasks(for room: Room) {
        navHandler.showTasks(for: room)
    }
}
