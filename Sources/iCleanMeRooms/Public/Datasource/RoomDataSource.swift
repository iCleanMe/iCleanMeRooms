//
//  RoomFeatureDataSource.swift
//
//
//  Created by Nikolai Nobadi on 7/12/24.
//

import Foundation

/// A data source class that holds the user and room sections information for the room management feature.
public final class RoomDataSource: ObservableObject {
    /// The current user associated with the rooms.
    @Published public var user: RoomUser
    
    /// The section containing the house rooms.
    @Published public var houseSection: RoomSection
    
    /// The section containing the personal rooms.
    @Published public var personalSection: RoomSection
    
    /// Initializes a new instance of `RoomDataSource`.
    ///
    /// - Parameters:
    ///   - user: The user associated with the rooms.
    ///   - houseSection: An optional house section. Defaults to an empty house section if not provided.
    ///   - personalSection: An optional personal section. Defaults to an empty personal section if not provided.
    public init(user: RoomUser, houseSection: RoomSection? = nil, personalSection: RoomSection? = nil) {
        self.user = user
        self.houseSection = houseSection ?? .emptyHouseSection
        self.personalSection = personalSection ?? .emptyPersonalSection
    }
}
