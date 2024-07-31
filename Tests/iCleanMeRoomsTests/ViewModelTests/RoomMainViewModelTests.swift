//
//  RoomMainViewModelTests.swift
//
//
//  Created by Nikolai Nobadi on 7/15/24.
//

import XCTest
import Combine
import NnTestHelpers
@testable import iCleanMeRooms

final class RoomMainViewModelTests: XCTestCase {
    func test_starting_values_are_empty() {
        let (sut, delegate) = makeSUT()
        
        XCTAssertNil(sut.navRoute)
        XCTAssertNil(delegate.newRoom)
        XCTAssertNil(delegate.updatedRoom)
        XCTAssertNil(delegate.deletedRoom)
        XCTAssertNil(delegate.isPersonal)
        XCTAssertTrue(delegate.newRoomOrder.isEmpty)
    }
    
    func test_existing_room_is_deleted_when_deleting_an_existing_room() async {
        let room = makeRoom()
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.deleteRoom(room)
        }
        
        assertPropertyEquality(delegate.deletedRoom, expectedProperty: room)
    }
    
    func test_sheet_is_dismissed_after_deleting_a_room() async {
        let room = makeRoom()
        let (sut, _) = makeSUT()
        
        sut.navRoute = .delete(room)
        
        XCTAssertNotNil(sut.navRoute)
        
        await asyncAssertNoErrorThrown {
            try await sut.deleteRoom(room)
        }
        
        XCTAssertNil(sut.navRoute)
    }
    
    func test_new_house_room_order_is_saved_when_reordering_house_rooms() async {
        let rooms = (0...3).map({ makeRoom(id: "\($0)") })
        let section = makeRoomSection(rooms: rooms)
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.saveNewOrder(section)
        }
        
        assertPropertyEquality(delegate.newRoomOrder, expectedProperty: rooms)
        XCTAssertEqual(delegate.isPersonal, false, "Should save new order for house rooms")
    }
    
    func test_new_personal_room_order_is_saved_when_reordering_personal_rooms() async {
        let rooms = (0...3).map({ makeRoom(id: "\($0)") })
        let section = makeRoomSection(type: .personal, rooms: rooms)
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.saveNewOrder(section)
        }
        
        assertPropertyEquality(delegate.newRoomOrder, expectedProperty: rooms)
        XCTAssertEqual(delegate.isPersonal, true, "Should save new order for personal rooms")
    }
    
    func test_sheet_is_dismissed_after_reordering_rooms() async {
        let room = makeRoom()
        let (sut, _) = makeSUT()
        
        sut.navRoute = .reorder(.emptyHouseSection)
        
        XCTAssertNotNil(sut.navRoute)
        
        await asyncAssertNoErrorThrown {
            try await sut.deleteRoom(room)
        }
        
        XCTAssertNil(sut.navRoute)
    }
}


// MARK: - RoomListNavHandler
extension RoomMainViewModelTests {
    func test_navigates_to_details_with_existing_room_when_editing_room() {
        let room = makeRoom()
        let (sut, _) = makeSUT()
        
        sut.showEditRoom(room)
        
        assertProperty(sut.navRoute) { route in
            switch route {
            case .detail(let roomToModify):
                switch roomToModify {
                case .existing(let receivedRoom):
                    XCTAssertEqual(receivedRoom, room)
                default:
                    XCTFail("unexpected roomToModify")
                }
            default:
                XCTFail("unexpected navRoute")
            }
        }
    }
    
    func test_navigates_to_delete_details_with_existing_room_when_deleting_room() {
        let room = makeRoom()
        let (sut, _) = makeSUT()
        
        sut.showDeleteRoom(room)
        
        assertProperty(sut.navRoute) { route in
            switch route {
            case .delete(let roomToDelete):
                XCTAssertEqual(roomToDelete, room)
            default:
                XCTFail("unexpected navRoute")
            }
        }
    }
    
    func test_navigates_to_details_with_new_room_when_adding_room() {
        for isPersonal in [true, false] {
            let (sut, _) = makeSUT()
            
            sut.showAddRoom(isPersonal: isPersonal)
            
            assertProperty(sut.navRoute) { route in
                switch route {
                case .detail(let roomToModify):
                    switch roomToModify {
                    case .new(let newRoom):
                        XCTAssertEqual(newRoom.isPersonal, isPersonal)
                    default:
                        XCTFail("unexpected roomToModify")
                    }
                default:
                    XCTFail("unexpected navRoute")
                }
            }
        }
    }
    
    func test_navigates_to_personal_reorder_details_when_reordering_personal_rooms() {
        let section = makeRoomSection(type: .personal)
        let (sut, _) = makeSUT()
        
        sut.showReorderRooms(section: section)
        
        assertProperty(sut.navRoute) { route in
            switch route {
            case .reorder(let sectionToReorder):
                XCTAssert(sectionToReorder.isPersonal)
            default:
                XCTFail("unexpected navRoute")
            }
        }
    }
    
    func test_navigates_to_house_reorder_details_when_reordering_house_rooms() {
        let section = makeRoomSection()
        let (sut, _) = makeSUT()
        
        sut.showReorderRooms(section: section)
        
        assertProperty(sut.navRoute) { route in
            switch route {
            case .reorder(let sectionToReorder):
                XCTAssertFalse(sectionToReorder.isPersonal)
            default:
                XCTFail("unexpected navRoute")
            }
        }
    }
    
    func test_shows_taskList_for_single_room_when_room_is_selected() {
        let room = Room(id: "1", name: "Room 1")
        var receivedTaskListType: RoomTaskListType?
        let (sut, _) = makeSUT(showTaskList: { receivedTaskListType = $0 })
        
        sut.showTasks(for: room)
        
        XCTAssertEqual(receivedTaskListType, .single(room), "Should show task list for the selected room")
    }
    
    func test_shows_taskList_for_all_tasks_when_allTaskRoom_is_selected() {
        let room = Room(id: .allRoomId, name: "All Tasks")
        var receivedTaskListType: RoomTaskListType?
        let (sut, _) = makeSUT(showTaskList: { receivedTaskListType = $0 })
        
        sut.showAllTasks(room: room)
        
        XCTAssertEqual(receivedTaskListType, .all, "Should show task list for all tasks when allTaskRoom is selected")
    }
    
    func test_shows_taskList_for_reminder_tasks_when_reminderRoom_is_selected() {
        let room = Room(id: .taskReminderRoomId, name: "Task Reminders")
        var receivedTaskListType: RoomTaskListType?
        let (sut, _) = makeSUT(showTaskList: { receivedTaskListType = $0 })
        
        sut.showAllTasks(room: room)
        
        XCTAssertEqual(receivedTaskListType, .onlyReminders, "Should show task list for reminder tasks when reminderRoom is selected")
    }
}


// MARK: - RoomDetailStore
extension RoomMainViewModelTests {
    func test_existing_room_is_saved_when_updating_an_existing_room() async {
        let room = Room(id: "1", name: "Room 1")
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.updateRoom(room)
        }
        
        assertPropertyEquality(delegate.updatedRoom, expectedProperty: room)
    }
    
    func test_sheet_is_dismissed_after_editing_a_room() async {
        let room = makeRoom()
        let (sut, _) = makeSUT()
        
        sut.navRoute = .detail(.existing(room))
        
        XCTAssertNotNil(sut.navRoute)
        
        await asyncAssertNoErrorThrown {
            try await sut.updateRoom(room)
        }
        
        XCTAssertNil(sut.navRoute)
    }
    
    func test_new_room_is_saved_when_adding_new_room() async {
        let room = Room(id: "1", name: "New Room")
        let (sut, delegate) = makeSUT()
        
        await asyncAssertNoErrorThrown {
            try await sut.saveNewRoom(room)
        }
        
        assertPropertyEquality(delegate.newRoom, expectedProperty: room)
    }
    
    func test_sheet_is_dismissed_after_adding_a_room() async {
        let room = makeRoom()
        let (sut, _) = makeSUT()
        
        sut.navRoute = .detail(.new(room))
        
        XCTAssertNotNil(sut.navRoute)
        
        await asyncAssertNoErrorThrown {
            try await sut.saveNewRoom(room)
        }
        
        XCTAssertNil(sut.navRoute)
    }
}


// MARK: - SUT
extension RoomMainViewModelTests {
    func makeSUT(throwError: Bool = false, showTaskList: @escaping (RoomTaskListType) -> Void = { _ in }, file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomMainViewModel, delegate: MockDelegate) {
        let delegate = MockDelegate(throwError: throwError)
        let sut = RoomMainViewModel(delegate: delegate, showTaskList: showTaskList)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate)
    }
}


// MARK: - Helper Classes
extension RoomMainViewModelTests {
    class MockDelegate: RoomDelegate {
        private let throwError: Bool
        private(set) var newRoom: Room?
        private(set) var updatedRoom: Room?
        private(set) var deletedRoom: Room?
        private(set) var isPersonal: Bool?
        private(set) var newRoomOrder: [Room] = []
        
        init(throwError: Bool) {
            self.throwError = throwError
        }
        
        func updateRoom(_ room: Room) async throws {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            updatedRoom = room
        }
        
        func saveNewRoom(_ room: Room) async throws {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            newRoom = room
        }
        
        func deleteRoom(_ room: Room) async throws {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            deletedRoom = room
        }
        
        func saveNewOrder(_ rooms: [Room], isPersonal: Bool) async throws {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            newRoomOrder = rooms
            self.isPersonal = isPersonal
        }
    }
}
