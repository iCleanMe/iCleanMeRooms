//
//  RoomListViewModelTests.swift
//
//
//  Created by Nikolai Nobadi on 7/19/24.
//

import XCTest
import Combine
import NnTestHelpers
@testable import iCleanMeRooms

final class RoomListViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        super.tearDown()
    }
}


// MARK: - Unit Tests
extension RoomListViewModelTests {
    func test_starting_values_are_empty() {
        let (_, delegate, _) = makeSUT()
        
        XCTAssertNil(delegate.roomToEdit)
        XCTAssertNil(delegate.roomToDelete)
        XCTAssertNil(delegate.roomToShowTasks)
        XCTAssertFalse(delegate.addingHouseRoom)
        XCTAssertFalse(delegate.addingPersonalRoom)
        XCTAssertNil(delegate.sectionToReorder)
    }
    
    func test_changes_to_datasource_user_are_republished() {
        let user = makeRoomUser(type: .normal)
        let newUser = makeRoomUser(type: .pro)
        let (sut, _, datasource) = makeSUT(user: user)
        
        datasource.user = newUser
        
        XCTAssertEqual(sut.user, newUser)
    }
    
    func test_changes_to_datasource_sections_are_republished() {
        let (sut, _, datasource) = makeSUT()

        XCTAssert(sut.houseSection.rooms.isEmpty)
        XCTAssert(sut.personalSection.rooms.isEmpty)
        
        datasource.houseSection = .sampleHouseSection
        
        XCTAssertFalse(sut.houseSection.rooms.isEmpty)
        XCTAssert(sut.personalSection.rooms.isEmpty)
        
        datasource.personalSection = .samplePersonalSection
        
        XCTAssertFalse(sut.houseSection.rooms.isEmpty)
        XCTAssertFalse(sut.personalSection.rooms.isEmpty)
    }
    
    func test_is_pro_when_user_type_is_pro() {
        XCTAssertTrue(makeSUT(user: makeRoomUser(type: .pro)).sut.isPro)
    }
    
    func test_no_rooms_when_sections_flatMap_contains_no_rooms() {
        XCTAssert(makeSUT().sut.noRooms)
    }
    
    func test_all_tasks_room_contains_all_tasks_from_each_section() {
        let task1 = makeTask()
        let task2 = makeTask()
        let room1 = makeRoom(tasks: [task1])
        let room2 = makeRoom(tasks: [task2])
        let sut = makeSUT(houseSection: .init(type: .house, rooms: [room1, room2])).sut

        assertPropertyEquality(sut.topSectionRooms.first?.tasks, expectedProperty: [task1, task2])
    }
    
    func test_task_reminder_room_only_contains_tasks_with_reminders() {
        let taskWithReminder = RoomTask(id: "1", name: "Task with Reminder", isClean: false, hasReminder: true)
        let taskWithoutReminder = RoomTask(id: "2", name: "Task without Reminder", isClean: false, hasReminder: false)
        let room = makeRoom(tasks: [taskWithReminder, taskWithoutReminder])
        let sut = makeSUT(houseSection: .init(type: .house, rooms: [room])).sut
        
        assertPropertyEquality(sut.topSectionRooms.last?.tasks, expectedProperty: [taskWithReminder])
    }
    
    func test_navigates_to_edit_room() {
        let room = makeRoom()
        let (sut, delegate, _) = makeSUT()
        
        sut.showEditRoom(room)
        
        XCTAssertEqual(delegate.roomToEdit, room)
    }
    
    func test_navigates_to_delete_room() {
        let room = makeRoom()
        let (sut, delegate, _) = makeSUT()
        
        sut.showDeleteRoom(room)
        
        XCTAssertEqual(delegate.roomToDelete, room)
    }
    
    func test_navigates_to_taskList_for_room() {
        let room = makeRoom()
        let (sut, delegate, _) = makeSUT()
        
        sut.showTasks(for: room)
        
        XCTAssertEqual(delegate.roomToShowTasks, room)
    }
    
    func test_navigates_to_add_a_house_room_when_not_personal() {
        let (sut, delegate, _) = makeSUT()
        
        sut.showAddRoom(isPersonal: false)
        
        XCTAssertTrue(delegate.addingHouseRoom)
    }
    
    func test_navigates_to_add_a_personal_room_when_personal() {
        let (sut, delegate, _) = makeSUT()
        
        sut.showAddRoom(isPersonal: true)
        
        XCTAssertTrue(delegate.addingPersonalRoom)
    }
    
    func test_navigates_to_reorder_rooms() {
        let section: RoomSection = .emptyHouseSection
        let (sut, delegate, _) = makeSUT(houseSection: section)
        
        sut.showReorderRooms(section: section)
        
        XCTAssertEqual(delegate.sectionToReorder, section)
    }
}


// MARK: - SUT
extension RoomListViewModelTests {
    func makeSUT(user: RoomUser? = nil, houseSection: RoomSection? = nil, personalSection: RoomSection? = nil, file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomListViewModel, delegate: MockDelegate, datasource: RoomDataSource) {
        let delegate = MockDelegate()
        let datasource = makeDatasource(user: user, houseSection: houseSection, personalSection: personalSection)
        let sut = RoomListViewModel(datasource: datasource, navHandler: delegate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate, datasource)
    }
}


// MARK: - Helper Classes
extension RoomListViewModelTests {
    class MockDelegate: RoomListNavHandler {
        private(set) var roomToEdit: Room?
        private(set) var roomToDelete: Room?
        private(set) var roomToShowTasks: Room?
        private(set) var addingHouseRoom = false
        private(set) var addingPersonalRoom = false
        private(set) var sectionToReorder: RoomSection?
        
        func showEditRoom(_ room: Room) {
            roomToEdit = room
        }
        
        func showDeleteRoom(_ room: Room) {
            roomToDelete = room
        }
        
        func showTasks(for room: Room) {
            roomToShowTasks = room
        }
        
        func showAddRoom(isPersonal: Bool) {
            if isPersonal {
                addingPersonalRoom = true
            } else {
                addingHouseRoom = true
            }
        }
        
        func showReorderRooms(section: RoomSection) {
            sectionToReorder = section
        }
    }
}
