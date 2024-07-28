//
//  Room.swift
//
//
//  Created by Nikolai Nobadi on 7/3/24.
//

public struct Room: Identifiable, Hashable {
    public var id: String
    public var name: String
    public var isPersonal: Bool
    public var tasks: [RoomTask]

    public init(id: String = "", name: String = "", isPersonal: Bool = false, tasks: [RoomTask] = []) {
        self.id = id
        self.name = name
        self.isPersonal = isPersonal
        self.tasks = tasks
    }
}


// MARK: - Dependencies
public struct RoomTask: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let isClean: Bool
    public let hasReminder: Bool
    
    public init(id: String, name: String, isClean: Bool, hasReminder: Bool) {
        self.id = id
        self.name = name
        self.isClean = isClean
        self.hasReminder = hasReminder
    }
}


// MARK: - Helpers
public extension Room {
    var dirtyTaskCount: Int {
        return tasks.filter({ !$0.isClean }).count
    }
    
    static var houseList: [Room] {
        return [
            .init(id: "0", name: "Kitchen and everything else", tasks: []),
            .init(id: "1", name: "Bathroom", tasks: [.init(id: "0", name: "Clean Toilet", isClean: false, hasReminder: true)]),
            .init(id: "2", name: "Living Room", tasks: [.init(id: "1", name: "Vacuum Rug", isClean: false, hasReminder: false)])
        ]
    }
    
    static var personalList: [Room] {
        return [
            .init(id: "10", name: "My Room", tasks: []),
        ]
    }
    
    static var longList: [Room]  {
        return [
//            .init(id: "0", name: "Kitchen and everything else", dirtyTaskCount: 3),
//            .init(id: "1", name: "Bathroom"),
//            .init(id: "2", name: "Living Room", dirtyTaskCount: 1),
//            .init(id: "3", name: "Dining Room"),
//            .init(id: "4", name: "Bedoom"),
//            .init(id: "5", name: "Garage", dirtyTaskCount: 20),
//            .init(id: "6", name: "Attic")
        ]
    }
}
