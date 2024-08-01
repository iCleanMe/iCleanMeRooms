//
//  RoomListViewModelIntegrationTests.swift
//
//
//  Created by Nikolai Nobadi on 8/1/24.
//

import XCTest
import NnTestHelpers
@testable import iCleanMeRooms

final class RoomListViewModelIntegrationTests: BaseRoomMainComposerAndViewModelIntegrationTests {
    func test_navigates_to_details_with_existing_room_when_editing_room() {
        
        let (sut, navHandler, room) = makeSUT()
        
        sut.showEditRoom(room)

        assertProperty(navHandler.navRoute) { route in
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
        let (sut, navHandler, room) = makeSUT()
        
        sut.showDeleteRoom(room)
        
        assertProperty(navHandler.navRoute) { route in
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
            let (sut, navHandler, _) = makeSUT()
            
            sut.showAddRoom(isPersonal: isPersonal)
            
            assertProperty(navHandler.navRoute) { route in
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
        let (sut, navHandler, _) = makeSUT()
        
        sut.showReorderRooms(section: section)
        
        assertProperty(navHandler.navRoute) { route in
            switch route {
            case .reorder(let sectionToReorder):
                XCTAssert(sectionToReorder.isPersonal)
            default:
                XCTFail("unexpected navRoute")
            }
        }
    }
    
    func test_navigates_to_house_reorder_details_when_reordering_house_rooms() {
        let section = makeRoomSection(type: .house)
        let (sut, navHandler, _) = makeSUT()
        
        sut.showReorderRooms(section: section)
        
        assertProperty(navHandler.navRoute) { route in
            switch route {
            case .reorder(let sectionToReorder):
                XCTAssertFalse(sectionToReorder.isPersonal)
            default:
                XCTFail("unexpected navRoute")
            }
        }
    }
    
    func test_shows_taskList_for_single_room_when_room_is_selected() {
        let (sut, _, room, delegate) = makeSUTWithDelegate()
        
        sut.showTasks(for: room)
        
        assertProperty(delegate.taskListType) { taskListType in
            switch taskListType {
            case .single(let roomToShow):
                XCTAssertEqual(room, roomToShow)
            default:
                XCTFail("unexpected taskListType")
            }
        }
    }
    
    func test_shows_taskList_for_all_tasks_when_allTaskRoom_is_selected() {
        let (sut, _, room, delegate) = makeSUTWithDelegate(roomId: .allRoomId)
        
        sut.showTasks(for: room)
        
        assertPropertyEquality(delegate.taskListType, expectedProperty: .all)
    }
    
    func test_shows_taskList_for_reminder_tasks_when_reminderRoom_is_selected() {
        let (sut, _, room, delegate) = makeSUTWithDelegate(roomId: .taskReminderRoomId)
        
        sut.showTasks(for: room)
        
        assertPropertyEquality(delegate.taskListType, expectedProperty: .onlyReminders)
    }
}


// MARK: - SUT
extension RoomListViewModelIntegrationTests {
    func makeSUTWithDelegate(roomId: String = "roomId", throwError: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomListViewModel, navHandler: RoomMainViewModel, room: Room, delegate: MockRoomDelegate) {
        
        let room = makeRoom(id: roomId)
        let houseSection = makeRoomSection(rooms: [room])
        let (composer, viewModel, delegate) = makeComposer(houseSection: houseSection, file: file, line: line)
        let sut = composer.makeListViewModel()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, viewModel, room, delegate)
    }
    
    func makeSUT(throwError: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomListViewModel, navHandler: RoomMainViewModel, room: Room) {
        let (sut, viewModel, room, _) = makeSUTWithDelegate(throwError: throwError)
        
        return (sut, viewModel, room)
    }
}
