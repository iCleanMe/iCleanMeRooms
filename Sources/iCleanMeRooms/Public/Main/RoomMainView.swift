//
//  RoomMainView.swift
//  
//
//  Created by Nikolai Nobadi on 7/10/24.
//

import SwiftUI
import iCleanMeSharedUI

/// A view that serves as the main entry point for managing rooms within the iCleanMe app.
/// It displays a list of rooms and handles navigation to various room-related views.
public struct RoomMainView: View {
    /// The composer responsible for creating view models for the views within this view.
    @StateObject private var composer: RoomMainComposer
    
    /// The main view model that manages the navigation and other high-level actions for the room management feature.
    @StateObject private var viewModel: RoomMainViewModel
    
    /// Initializes a new instance of `RoomMainView`.
    ///
    /// - Parameters:
    ///   - datasource: The data source providing the room data.
    ///   - delegate: The delegate responsible for handling actions related to rooms.
    ///   - showTaskList: A closure that determines how to display the task list for a room.
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
    
    return RoomMainView(datasource: .previewInit(), delegate: PreviewEventHandler(), showTaskList: { _ in })
        .withPreviewModifiers()
}
