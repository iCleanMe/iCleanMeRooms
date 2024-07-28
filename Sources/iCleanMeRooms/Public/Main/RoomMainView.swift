//
//  RoomMainView.swift
//  
//
//  Created by Nikolai Nobadi on 7/10/24.
//

import SwiftUI
import iCleanMeSharedUI

public struct RoomMainView: View {
    @StateObject private var composer: RoomMainComposer
    @StateObject private var viewModel: RoomMainViewModel
    
    public init(datasource: RoomDataSource, delegate: RoomDelegate, showTaskList: @escaping (RoomTaskListType) -> Void) {
        let viewModel = RoomMainViewModel(delegate: delegate, showTaskList: showTaskList)
        self._composer = .init(wrappedValue: .init(delegate: viewModel, datasource: datasource))
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        RoomListView(viewModel: composer.makeListViewModel())
            .sheetWithErrorHandling(item: $viewModel.navRoute) { route in
                NavStack(title: route.navTitle) {
                    Group {
                        switch route {
                        case .detail(let roomToModify):
                            RoomDetailView(viewModel: composer.makeDetailViewModel(roomToModify.room))
                        case .delete(let roomToDelete):
                            DeleteRoomView(viewModel: composer.makeDeleteViewModel(roomToDelete))
                        case .reorder(let section):
                            ReorderRoomListView(viewModel: composer.makeReorderViewModel(section))
                        }
                    }
                    #if canImport(UIKit)
                    .withNavBarDismissButton()
                    #endif
                }
                .interactiveDismissDisabled()
            }
    }
}


// MARK: - Preview
#Preview {
    class PreviewEventHandler: RoomDelegate {
        func updateRoom(_ room: Room) async throws { }
        func saveNewRoom(_ room: Room) async throws { }
        func deleteRoom(_ room: Room) async throws { }
        func saveNewOrder(_ rooms: [Room], isPersonal: Bool) async throws { }
    }
    
    return RoomMainView(datasource: .init(user: .previewUser(), sections: RoomSection.sampleList), delegate: PreviewEventHandler(), showTaskList: { _ in })
        .withPreviewModifiers()
}
