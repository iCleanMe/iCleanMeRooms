//
//  Room.swift
//
//
//  Created by Nikolai Nobadi on 7/3/24.
//

/// A struct representing a room in the app.
public struct Room: Identifiable, Hashable {
    /// The unique identifier for the room.
    public var id: String
    
    /// The name of the room.
    public var name: String
    
    /// A boolean indicating whether the room is personal.
    public var isPersonal: Bool
    
    /// A list of tasks associated with the room.
    public var tasks: [RoomTask]

    /// Initializes a new instance of `Room`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the room. Defaults to an empty string.
    ///   - name: The name of the room. Defaults to an empty string.
    ///   - isPersonal: A boolean indicating whether the room is personal. Defaults to `false`.
    ///   - tasks: A list of tasks associated with the room. Defaults to an empty list.
    public init(id: String = "", name: String = "", isPersonal: Bool = false, tasks: [RoomTask] = []) {
        self.id = id
        self.name = name
        self.isPersonal = isPersonal
        self.tasks = tasks
    }
}


// MARK: - RoomTask
/// A struct representing a task associated with a room.
public struct RoomTask: Identifiable, Hashable {
    /// The unique identifier for the task.
    public let id: String
    
    /// The name of the task.
    public let name: String
    
    /// A boolean indicating whether the task is clean.
    public let isClean: Bool
    
    /// A boolean indicating whether the task has a reminder set.
    public let hasReminder: Bool
    
    /// Initializes a new instance of `RoomTask`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the task.
    ///   - name: The name of the task.
    ///   - isClean: A boolean indicating whether the task is clean.
    ///   - hasReminder: A boolean indicating whether the task has a reminder set.
    public init(id: String, name: String, isClean: Bool, hasReminder: Bool) {
        self.id = id
        self.name = name
        self.isClean = isClean
        self.hasReminder = hasReminder
    }
}


// MARK: - Helpers
public extension Room {
    /// The count of tasks in the room that are not clean.
    var dirtyTaskCount: Int {
        return tasks.filter({ !$0.isClean }).count
    }
}
