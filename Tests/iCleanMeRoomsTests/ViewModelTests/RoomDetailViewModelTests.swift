//
//  RoomDetailViewModelTests.swift
//
//
//  Created by Nikolai Nobadi on 7/15/24.
//

import XCTest
import NnTestHelpers
@testable import iCleanMeRooms

final class RoomDetailViewModelTests: XCTestCase {
    func test_starting_values_are_empty() {
        let (_, delegate) = makeSUT()
        
        XCTAssertNil(delegate.newRoom)
        XCTAssertNil(delegate.updatedRoom)
    }
    
    func test_guest_cannot_add_room_when_current_room_count_exceeds_guest_limit() {
        let roomCount = 5
        let houseSection = makeHouseSection(roomCount: roomCount)
        let (sut, _) = makeSUT(room: .init(), user: makeRoomUser(type: .guest), houseSection: houseSection)
        
        XCTAssertFalse(sut.canAddRoom, "Guest should not be able to add a room when current room count exceeds the limit")
    }
    
    func test_normal_user_cannot_add_room_when_current_room_count_exceeds_normal_limit() {
        let roomCount = 8
        let houseSection = makeHouseSection(roomCount: roomCount)
        let (sut, _) = makeSUT(room: .init(), houseSection: houseSection)
        
        XCTAssertFalse(sut.canAddRoom, "Normal user should not be able to add a room when current room count exceeds the limit")
    }
    
    func test_pro_user_can_always_add_a_room() {
        (0...20).forEach { roomCount in
            let houseSection = makeHouseSection(roomCount: roomCount)
            let (sut, _) = makeSUT(room: .init(), user: makeRoomUser(type: .pro), houseSection: houseSection)
            
            XCTAssert(sut.canAddRoom, "Guest should be able to add a room when current room count is \(roomCount)")
        }
    }
    
    func test_new_room_is_saved_when_adding() async {
        let room = Room(name: "New Room")
        let (sut, store) = makeSUT(room: room)
        
        await asyncAssertNoErrorThrown(action: sut.saveRoom)
        assertProperty(store.newRoom) { savedRoom in
            XCTAssertFalse(savedRoom.id.isEmpty)
        }
    }
    
    func test_existing_room_is_saved_when_editing() async {
        let room = Room(id: "1", name: "Existing Room")
        let (sut, store) = makeSUT(room: room)
        
        await asyncAssertNoErrorThrown(action: sut.saveRoom)
        assertPropertyEquality(store.updatedRoom, expectedProperty: room)
    }
    
    func test_guest_can_add_room_when_current_room_count_is_under_guest_limit() {
        (0...3).forEach { roomCount in
            let houseSection = makeHouseSection(roomCount: roomCount)
            let (sut, _) = makeSUT(room: .init(), user: makeRoomUser(type: .guest), houseSection: houseSection)
            
            XCTAssertTrue(sut.canAddRoom, "Guest should be able to add a room when current room count is \(roomCount)")
        }
    }
    
    func test_normal_user_can_add_room_when_current_room_count_is_under_normal_limit() {
        (0...6).forEach { roomCount in
            let houseSection = makeHouseSection(roomCount: roomCount)
            let (sut, _) = makeSUT(room: .init(), houseSection: houseSection)
            
            XCTAssertTrue(sut.canAddRoom, "Guest should be able to add a room when current room count is \(roomCount)")
        }
    }
    
    func test_new_room_with_id_is_saved_when_room_id_was_empty() async {
        let room = Room()
        let (sut, delegate) = makeSUT(room: room)
        
        XCTAssert(room.id.isEmpty)
        
        await asyncAssertNoErrorThrown(action: sut.saveRoom)
        assertProperty(delegate.newRoom) { newRoom in
            XCTAssertFalse(newRoom.id.isEmpty)
        }
    }
    
    func test_existing_room_is_saved_when_room_id_is_filled() async {
        let room = Room(id: "existingId")
        let (sut, delegate) = makeSUT(room: room)
        
        XCTAssertFalse(room.id.isEmpty)
        
        await asyncAssertNoErrorThrown(action: sut.saveRoom)
        assertPropertyEquality(delegate.updatedRoom?.id, expectedProperty: room.id)
    }
}


// MARK: - SUT
extension RoomDetailViewModelTests {
    func makeSUT(room: Room = .init(), user: RoomUser? = nil, houseSection: RoomSection? = nil, personalSection: RoomSection? = nil, throwError: Bool = false, updateRoom: @escaping (Room) async throws -> Void = { _ in }, saveNewRoom: @escaping (Room) async throws -> Void = { _ in }, file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomDetailViewModel, delegate: MockDelegate) {
        let delegate = MockDelegate(throwError: throwError)
        let datasource = makeDatasource(user: user, houseSection: houseSection, personalSection: personalSection)
        let sut = RoomDetailViewModel(room: room, delegate: delegate, datasource: datasource)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate)
    }
    
    func makeHouseSection(roomCount: Int = 1) -> RoomSection {
        return .init(type: .house, rooms: createRooms(count: roomCount))
    }
    
    func createRooms(count: Int) -> [Room] {
        var rooms = [Room]()
        for _ in 0..<count {
            rooms.append(.init())
        }
        return rooms
    }
}


// MARK: - Helper Classes
extension RoomDetailViewModelTests {
    class MockDelegate: RoomDetailDelegate {
        private let throwError: Bool
        private(set) var newRoom: Room?
        private(set) var updatedRoom: Room?
        
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
    }
}
