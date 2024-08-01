//
//  BaseRoomMainComposerAndViewModelIntegrationTests.swift
//  
//
//  Created by Nikolai Nobadi on 8/1/24.
//

import XCTest
import NnTestHelpers
@testable import iCleanMeRooms

class BaseRoomMainComposerAndViewModelIntegrationTests: XCTestCase {
    func test_starting_values_are_empty() {
        let (_, viewModel, delegate) = makeComposer()
        
        XCTAssertNil(viewModel.navRoute)
        XCTAssertNil(delegate.newRoom)
        XCTAssertNil(delegate.updatedRoom)
        XCTAssertNil(delegate.deletedRoom)
        XCTAssertNil(delegate.isPersonal)
        XCTAssertNil(delegate.taskListType)
        XCTAssertTrue(delegate.newRoomOrder.isEmpty)
    }
}


// MARK: - ReorderRooms Tests
extension BaseRoomMainComposerAndViewModelIntegrationTests {
    func test_new_house_room_order_is_saved_when_reordering_house_rooms() async {
        let rooms = (0...3).map({ makeRoom(id: "\($0)") })
        let houseSection = makeRoomSection(rooms: rooms)
        let (composer, _, delegate) = makeComposer(houseSection: houseSection)
        let viewModel = composer.makeReorderViewModel(houseSection)
        
        await asyncAssertNoErrorThrown(action: viewModel.saveChanges)
        
        assertPropertyEquality(delegate.newRoomOrder, expectedProperty: rooms)
        assertPropertyEquality(delegate.isPersonal, expectedProperty: false)
    }
    
    func test_new_personal_room_order_is_saved_when_reordering_personal_rooms() async {
        let rooms = (0...3).map({ makeRoom(id: "\($0)", isPersonal: true) })
        let houseSection = makeRoomSection(rooms: [])
        let personalSection = makeRoomSection(type: .personal, rooms: rooms)
        let (composer, _, delegate) = makeComposer(houseSection: houseSection, personalSection: personalSection)
        let viewModel = composer.makeReorderViewModel(personalSection)
        
        await asyncAssertNoErrorThrown(action: viewModel.saveChanges)
        
        assertPropertyEquality(delegate.newRoomOrder, expectedProperty: rooms)
        assertPropertyEquality(delegate.isPersonal, expectedProperty: true)
    }
}


// MARK: - DeleteRoom Tests
extension BaseRoomMainComposerAndViewModelIntegrationTests {
    func test_existing_room_is_deleted() async {
        let roomToDelete = makeRoom()
        let houseSection = makeRoomSection(rooms: [roomToDelete])
        let (composer, _, delegate) = makeComposer(houseSection: houseSection)
        let viewModel = composer.makeDeleteViewModel(roomToDelete)
        
        await asyncAssertNoErrorThrown(action: viewModel.deleteRoom)
        
        assertPropertyEquality(delegate.deletedRoom, expectedProperty: roomToDelete)
    }
}


// MARK: - SUT
extension BaseRoomMainComposerAndViewModelIntegrationTests {
    func makeComposer(user: RoomUser? = nil, houseSection: RoomSection? = nil, personalSection: RoomSection? = nil, throwError: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (composer: RoomMainComposer, viewModel: RoomMainViewModel, delegate: MockRoomDelegate) {
        let delegate = MockRoomDelegate(throwError: throwError)
        let datasource = makeDatasource(user: user, houseSection: houseSection, personalSection: personalSection)
        let viewModel = RoomMainViewModel(delegate: delegate, showTaskList: delegate.showTaskList(_:))
        let composer = RoomMainComposer(delegate: viewModel, datasource: datasource)
        
        trackForMemoryLeaks(viewModel, file: file, line: line)
        trackForMemoryLeaks(composer, file: file, line: line)
        
        return (composer, viewModel, delegate)
    }
}
