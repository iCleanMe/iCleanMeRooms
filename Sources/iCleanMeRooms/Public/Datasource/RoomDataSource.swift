//
//  RoomFeatureDataSource.swift
//
//
//  Created by Nikolai Nobadi on 7/12/24.
//

import Foundation

public final class RoomDataSource: ObservableObject {
    @Published public var user: RoomUser
    @Published public var houseSection: RoomSection
    @Published public var personalSection: RoomSection
    
    public init(user: RoomUser, houseSection: RoomSection? = nil, personalSection: RoomSection? = nil) {
        self.user = user
        self.houseSection = houseSection ?? .emptyHouseSection
        self.personalSection = personalSection ?? .emptyPersonalSection
    }
}
