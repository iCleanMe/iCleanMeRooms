//
//  RoomListViewModel.swift
//  
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

/// The view model responsible for managing the data and actions for the room list view.
final class RoomListViewModel: ObservableObject {
    @Published var user: RoomUser
    @Published var houseTasks: [RoomTask] = []
    @Published var personalTasks: [RoomTask] = []
    @Published var houseSection: RoomSection
    @Published var personalSection: RoomSection
    @Published var selectedSection: RoomSectionType = .house
    
    private let datasource: RoomDataSource
    private let navHandler: RoomListNavHandler
    
    /// Initializes the view model with the given data source and navigation handler.
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
    /// Indicates whether the user is a Pro user.
    var isPro: Bool {
        return user.type == .pro
    }
    
    /// Indicates whether the non-Pro personal room list should be displayed.
    var showNonProPersonalList: Bool {
        return selectedSection == .personal && !isPro
    }
    
    /// Indicates whether there are no rooms in the current section.
    var noRooms: Bool {
        return houseSection.rooms.isEmpty && personalSection.rooms.isEmpty
    }
    
    /// The rooms to be displayed in the top section.
    var topSectionRooms: [Room] {
        let allTasks = houseTasks + personalTasks
        
        return [
            .init(id: .allRoomId, name: "All Tasks", tasks: allTasks),
            .init(id: .taskReminderRoomId, name: "Task Reminders", tasks: allTasks.filter({ $0.hasReminder }))
        ]
    }
    
    /// The section to be displayed based on the selected section type.
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
    /// Shows the edit room view for the specified room.
    func showEditRoom(_ room: Room) {
        navHandler.showEditRoom(room)
    }
    
    /// Shows the delete room view for the specified room.
    func showDeleteRoom(_ room: Room) {
        navHandler.showDeleteRoom(room)
    }
    
    /// Shows the tasks for the specified room.
    func showTasks(for room: Room) {
        navHandler.showTasks(for: room)
    }
    
    /// Shows the view to add a new room.
    func showAddRoom(isPersonal: Bool) {
        navHandler.showAddRoom(isPersonal: isPersonal)
    }
    
    /// Shows the reorder rooms view for the specified section.
    func showReorderRooms(section: RoomSection) {
        navHandler.showReorderRooms(section: section)
    }
}


// MARK: - Actions
extension RoomListViewModel {
    /// Shows all tasks for the specified room.
    func showAllTasks(for room: Room) {
        navHandler.showTasks(for: room)
    }
}


// MARK: - Private Methods
private extension RoomListViewModel {
    /// Starts observing changes in the data source.
    func startObservers() {
        datasource.$user.assign(to: &$user)
        datasource.$houseSection.assign(to: &$houseSection)
        datasource.$personalSection.assign(to: &$personalSection)
        $houseSection.map({ $0.allTasks }).assign(to: &$houseTasks)
        $personalSection.map({ $0.allTasks }).assign(to: &$personalTasks)
    }
}


// MARK: - Extension Dependencies
fileprivate extension RoomSection {
    /// Returns all tasks in the section.
    var allTasks: [RoomTask] {
        return rooms.flatMap({ $0.tasks })
    }
}
