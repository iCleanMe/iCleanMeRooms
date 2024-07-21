//
//  RoomListViewModelTests.swift
//
//
//  Created by Nikolai Nobadi on 7/19/24.
//

import XCTest
import NnTestHelpers
@testable import RoomPresentation

final class RoomListViewModelTests: XCTestCase {
    func test_starting_values_are_empty() {
        let (_, delegate) = makeSUT()
        
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
        let (sut, _, datasource) = makeSUTWithDatasource(user: user)
        
        datasource.user = newUser
        
        XCTAssertEqual(sut.user, newUser)
    }
    
    func test_changes_to_datasource_sections_are_republished() {
        let section1 = RoomSection(id: "1", name: "Section 1", rooms: [])
        let section2 = RoomSection(id: "2", name: "Section 2", rooms: [])
        let (sut, _, datasource) = makeSUTWithDatasource(sections: [section1])
        
        datasource.sections = [section2]
        
        XCTAssertEqual(sut.sections, [section2])
    }
    
    func test_is_pro_when_user_type_is_pro() {
        let proUser = makeRoomUser(type: .pro)
        let (sut, _) = makeSUT(user: proUser)
        
        XCTAssertTrue(sut.isPro)
    }
    
    func test_no_rooms_when_sections_flatMap_contains_no_rooms() {
        let emptySection = RoomSection(id: "1", name: "Empty Section", rooms: [])
        let (sut, _) = makeSUT(sections: [emptySection])
        
        XCTAssertTrue(sut.noRooms)
    }
    
    func test_all_tasks_room_contains_all_tasks_from_each_section() {
        let task1 = makeTask()
        let task2 = makeTask()
        let room1 = makeRoom(tasks: [task1])
        let room2 = makeRoom(tasks: [task2])
        let section1 = RoomSection(id: "1", name: "Section 1", rooms: [room1, room2])
        let (sut, _) = makeSUT(sections: [section1])
        
        assertPropertyEquality(sut.topSectionRooms.first?.tasks, expectedProperty: [task1, task2])
    }
    
    func test_task_reminder_room_only_contains_tasks_with_reminders() {
        let taskWithReminder = RoomTask(id: "1", name: "Task with Reminder", isClean: false, hasReminder: true)
        let taskWithoutReminder = RoomTask(id: "2", name: "Task without Reminder", isClean: false, hasReminder: false)
        let room = makeRoom(tasks: [taskWithReminder, taskWithoutReminder])
        let section = RoomSection(id: "1", name: "Section 1", rooms: [room])
        let (sut, _) = makeSUT(sections: [section])
        
        assertPropertyEquality(sut.topSectionRooms.last?.tasks, expectedProperty: [taskWithReminder])
    }
    
    func test_navigates_to_edit_room() {
        let room = makeRoom()
        let (sut, delegate) = makeSUT()
        
        sut.showEditRoom(room)
        
        XCTAssertEqual(delegate.roomToEdit, room)
    }
    
    func test_navigates_to_delete_room() {
        let room = makeRoom()
        let (sut, delegate) = makeSUT()
        
        sut.showDeleteRoom(room)
        
        XCTAssertEqual(delegate.roomToDelete, room)
    }
    
    func test_navigates_to_taskList_for_room() {
        let room = makeRoom()
        let (sut, delegate) = makeSUT()
        
        sut.showTasks(for: room)
        
        XCTAssertEqual(delegate.roomToShowTasks, room)
    }
    
    func test_navigates_to_add_a_house_room_when_not_personal() {
        let (sut, delegate) = makeSUT()
        
        sut.showAddRoom(isPersonal: false)
        
        XCTAssertTrue(delegate.addingHouseRoom)
    }
    
    func test_navigates_to_add_a_personal_room_when_personal() {
        let (sut, delegate) = makeSUT()
        
        sut.showAddRoom(isPersonal: true)
        
        XCTAssertTrue(delegate.addingPersonalRoom)
    }
    
    func test_navigates_to_reorder_rooms() {
        let section = RoomSection(id: "1", name: "Section 1", rooms: [])
        let (sut, delegate) = makeSUT()
        
        sut.showReorderRooms(section: section)
        
        XCTAssertEqual(delegate.sectionToReorder, section)
    }
}


// MARK: - SUT
extension RoomListViewModelTests {
    func makeSUT(user: RoomUser? = nil, sections: [RoomSection] = [], file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomListViewModel, delegate: MockDelegate) {
        
        let (sut, delegate, _) = makeSUTWithDatasource(user: user, sections: sections)
        
        return (sut, delegate)
    }
    
    
    func makeSUTWithDatasource(user: RoomUser? = nil, sections: [RoomSection] = [], file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomListViewModel, delegate: MockDelegate, datasource: RoomDataSource) {
        let delegate = MockDelegate()
        let datasource = RoomDataSource(user: user ?? makeRoomUser(), sections: sections)
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
