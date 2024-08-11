//
//  RoomMainComposer.swift
//  
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

/// A composer class responsible for creating view models for the Room module.
final class RoomMainComposer: ObservableObject {
    private let datasource: RoomDataSource
    private let delegate: RoomMainViewModel
    
    /// Initializes the composer with the given delegate and data source.
    init(delegate: RoomMainViewModel, datasource: RoomDataSource) {
        self.delegate = delegate
        self.datasource = datasource
    }
}

// MARK: - Composer
extension RoomMainComposer {
    /// Creates a view model for the room list view.
    func makeListViewModel() -> RoomListViewModel {
        return .init(datasource: datasource, navHandler: delegate)
    }
    
    /// Creates a view model for the room detail view.
    func makeDetailViewModel(_ room: Room) -> RoomDetailViewModel {
        return .init(room: room, delegate: delegate, datasource: datasource)
    }
    
    /// Creates a view model for the delete room view.
    func makeDeleteViewModel(_ room: Room) -> DeleteRoomViewModel {
        return .init(room: room, datasource: datasource, deleteRoom: delegate.deleteRoom(_:))
    }
    
    /// Creates a view model for the reorder room list view.
    func makeReorderViewModel(_ section: RoomSection) -> ReorderRoomListViewModel {
        return .init(section: section, saveNewOrder: delegate.saveNewOrder(_:))
    }
}
