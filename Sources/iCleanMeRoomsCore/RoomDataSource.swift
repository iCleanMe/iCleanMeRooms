//
//  RoomFeatureDataSource.swift
//
//
//  Created by Nikolai Nobadi on 7/12/24.
//

import Foundation

public final class RoomDataSource: ObservableObject {
    @Published public var user: RoomUser
    @Published public var sections: [RoomSection]
    
    public init(user: RoomUser, sections: [RoomSection] = []) {
        self.user = user
        self.sections = sections
    }
}
