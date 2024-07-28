//
//  RoomMainComposer.swift
//  
//
//  Created by Nikolai Nobadi on 7/18/24.
//

import Foundation

final class RoomMainComposer: ObservableObject {
    private let datasource: RoomDataSource
    private let delegate: RoomMainViewModel
    
    init(delegate: RoomMainViewModel, datasource: RoomDataSource) {
        self.delegate = delegate
        self.datasource = datasource
    }
}


// MARK: - Composer
extension RoomMainComposer {
    func makeListViewModel() -> RoomListViewModel {
        return .init(datasource: datasource, navHandler: delegate)
    }
    func makeDetailViewModel(_ room: Room) -> RoomDetailViewModel {
        return .init(room: room, delegate: delegate, datasource: datasource)
    }
    func makeDeleteViewModel(_ room: Room) -> DeleteRoomViewModel {
        return .init(room: room, datasource: datasource, deleteRoom: delegate.deleteRoom(_:))
    }
    
    func makeReorderViewModel(_ section: RoomSection) -> ReorderRoomListViewModel {
        return .init(section: section, saveNewOrder: delegate.saveNewOrder(_:))
    }
}
