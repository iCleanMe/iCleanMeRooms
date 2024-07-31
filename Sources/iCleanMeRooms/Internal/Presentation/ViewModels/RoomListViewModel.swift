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
    @Published var houseSection: RoomSection
    @Published var personalSection: RoomSection
    @Published var selectedSection: RoomSectionType = .house 
    
    private let datasource: RoomDataSource
    private let navHandler: RoomListNavHandler
    
    init(datasource: RoomDataSource, navHandler: RoomListNavHandler, houseSection: RoomSection = .emptyHouseSection, personalSection: RoomSection = .emptyPersonalSection) {
        self.datasource = datasource
        self.navHandler = navHandler
        self.user = datasource.user
        self.houseSection = houseSection
        self.personalSection = personalSection
        
        startObservers()
    }
}


// MARK: - DisplayData
extension RoomListViewModel {
    var isPro: Bool {
        return user.type == .pro
    }
    
    var showNonProPersonalList: Bool {
        return selectedSection == .personal && !isPro
    }
    
    var noRooms: Bool {
        return houseSection.rooms.isEmpty && personalSection.rooms.isEmpty
    }
    
    var topSectionRooms: [Room] {
        return [
            .init(id: .allRoomId, name: "All Tasks", tasks: allTasks),
            .init(id: .taskReminderRoomId, name: "Task Reminders", tasks: allTasks.filter({ $0.hasReminder }))
        ]
    }
    
    var sectionToDisplay: RoomSection {
        switch selectedSection {
        case .house:
            return houseSection
        case .personal:
            return personalSection
        }
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


// MARK: - Private Methods
private extension RoomListViewModel {
    func startObservers() {
        datasource.$user.assign(to: &$user)
        datasource.$houseSection.assign(to: &$houseSection)
        datasource.$personalSection.assign(to: &$houseSection)
        $houseSection
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map { $0.allTasks }
            .combineLatest($personalSection.map({ $0.allTasks }))
            .map { houseTasks, personalTasks in
                return houseTasks + personalTasks
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$allTasks)
    }
}


// MARK: - Extension Dependencies
fileprivate extension RoomSection {
    var allTasks: [RoomTask] {
        return rooms.flatMap({ $0.tasks })
    }
}
