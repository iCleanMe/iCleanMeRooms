//
//  DeleteRoomViewModelTests.swift
//
//
//  Created by Nikolai Nobadi on 7/19/24.
//

import XCTest
import NnTestHelpers
@testable import RoomPresentation

final class DeleteRoomViewModelTests: XCTestCase {
    func test_starting_values_are_empty() {
        let (_, delegate) = makeSUT()
        
        XCTAssertNil(delegate.roomToDelete)
    }
    
    func test_delete_text_contains_Tasks_when_room_has_tasks() {
        let room = makeRoom(tasks: [makeTask()])
        let sut = makeSUT(room: room).sut
        
        XCTAssert(sut.deleteButtonText.contains("Tasks"))
    }
    
    func test_delete_text_does_NOT_contain_Tasks_when_room_has_tasks() {
        XCTAssertFalse(makeSUT().sut.deleteButtonText.contains("Tasks"))
    }
    
    func test_room_is_deleted() async {
        let room = makeRoom()
        let (sut, delegate) = makeSUT(room: room)
        
        await asyncAssertNoErrorThrown(action: sut.deleteRoom)
        assertPropertyEquality(delegate.roomToDelete, expectedProperty: room)
    }
}


// MARK: - SUT
extension DeleteRoomViewModelTests {
    func makeSUT(room: Room? = nil, user: RoomUser? = nil, sections: [RoomSection] = [], throwError: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (sut: DeleteRoomViewModel, delegate: MockDelegate) {
        let delegate = MockDelegate(throwError: throwError)
        let datasource = RoomDataSource(user: user ?? makeRoomUser(), sections: sections)
        let sut = DeleteRoomViewModel(room: room ?? makeRoom(), datasource: datasource, deleteRoom: delegate.deleteRoom(_:))
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate)
    }
}


// MARK: - Helper Classes
extension DeleteRoomViewModelTests {
    class MockDelegate {
        private let throwError: Bool
        private(set) var roomToDelete: Room?
        
        init(throwError: Bool) {
            self.throwError = throwError
        }
        
        func deleteRoom(_ room: Room) async throws {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            self.roomToDelete = room
        }
    }
}
