//
//  RoomDetailViewModelIntegrationTests.swift
//
//
//  Created by Nikolai Nobadi on 8/1/24.
//

import XCTest
import NnTestHelpers
@testable import iCleanMeRooms

final class RoomDetailViewModelIntegrationTests: BaseRoomMainComposerAndViewModelIntegrationTests {
    func test_existing_room_is_saved_when_updating_an_existing_room() async {
        let (sut, delegate, room) = makeSUT()

        await asyncAssertNoErrorThrown(action: sut.saveRoom)
        
        assertPropertyEquality(delegate.updatedRoom, expectedProperty: room)
    }
    
    func test_new_room_is_saved_when_adding_new_room() async {
        let (sut, delegate, _) = makeSUT(roomId: "")

        await asyncAssertNoErrorThrown(action: sut.saveRoom)
        
        assertProperty(delegate.newRoom) { roomToSave in
            XCTAssertFalse(roomToSave.id.isEmpty)
        }
    }
}


// MARK: - SUT
extension RoomDetailViewModelIntegrationTests {
    func makeSUT(roomId: String = "roomId", throwError: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomDetailViewModel, delegate: MockRoomDelegate, room: Room) {
        let room = makeRoom(id: roomId)
        let houseSection = makeRoomSection(rooms: [room])
        let (composer, _, delegate) = makeComposer(houseSection: houseSection)
        let sut = composer.makeDetailViewModel(room)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate, room)
    }
}
