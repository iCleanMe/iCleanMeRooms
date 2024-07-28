//
//  ReorderRoomListViewModelTests.swift
//  
//
//  Created by Nikolai Nobadi on 7/19/24.
//

import XCTest
import NnTestHelpers
@testable import iCleanMeRooms

final class ReorderRoomListViewModelTests: XCTestCase {
    func test_starting_values_are_empty() {
        let (_, delegate) = makeSUT()
        
        XCTAssertNil(delegate.sectionToSave)
    }
    
    func test_section_is_saved_with_new_order() async {
        let rooms = (0...5).map({ makeRoom(id: "\($0)") })
        let section = makeRoomSection(rooms: rooms)
        let (sut, delegate) = makeSUT(section: section)
        
        sut.roomList.shuffle()
        
        await asyncAssertNoErrorThrown(action: sut.saveChanges)
        assertProperty(delegate.sectionToSave) { savedSection in
            XCTAssertNotEqual(rooms, savedSection.rooms)
        }
    }
}


// MARK: - SUT
extension ReorderRoomListViewModelTests {
    func makeSUT(section: RoomSection? = nil, throwError: Bool = false, file: StaticString = #filePath, line: UInt = #line) -> (sut: ReorderRoomListViewModel, delegate: MockDelegate) {
        let delegate = MockDelegate(throwError: throwError)
        let sut = ReorderRoomListViewModel(section: section ?? makeRoomSection(), saveNewOrder: delegate.saveNewOrder(_:))
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, delegate)
    }
    
    func makeRoomSection(id: String = "0", rooms: [Room] = []) -> RoomSection {
        return .init(id: id, name: "", rooms: rooms, isPersonal: false)
    }
}


// MARK: - Helper Classes
extension ReorderRoomListViewModelTests {
    class MockDelegate {
        private let throwError: Bool
        private(set) var sectionToSave: RoomSection?
        
        init(throwError: Bool) {
            self.throwError = throwError
        }
        
        func saveNewOrder(_ section: RoomSection) async throws {
            if throwError { throw NSError(domain: "Test", code: 0) }
            
            self.sectionToSave = section
        }
    }
}
