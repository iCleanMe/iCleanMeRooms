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


// MARK: - RoomDetailStore
extension RoomMainViewModelTests {
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
    func makeSUT(throwError: Bool = false, showTaskList: @escaping (RoomTaskListType) -> Void = { _ in }, file: StaticString = #filePath, line: UInt = #line) -> (sut: RoomMainViewModel, delegate: MockRoomDelegate) {
        let delegate = MockRoomDelegate(throwError: throwError)
        let sut = RoomMainViewModel(delegate: delegate, showTaskList: showTaskList)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate)
    }
}
