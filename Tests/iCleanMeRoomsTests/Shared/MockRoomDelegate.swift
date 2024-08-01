//
//  MockRoomDelegate.swift
//
//
//  Created by Nikolai Nobadi on 8/1/24.
//

import XCTest
@testable import iCleanMeRooms

final class MockRoomDelegate: RoomDelegate {
    private let throwError: Bool
    private(set) var newRoom: Room?
    private(set) var updatedRoom: Room?
    private(set) var deletedRoom: Room?
    private(set) var isPersonal: Bool?
    private(set) var newRoomOrder: [Room] = []
    private(set) var taskListType: RoomTaskListType?
    
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
    
    func showTaskList(_ type: RoomTaskListType) {
        self.taskListType = type
    }
}
