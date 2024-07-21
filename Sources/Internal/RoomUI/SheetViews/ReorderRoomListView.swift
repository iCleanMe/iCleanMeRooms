//
//  ReorderRoomListView.swift
//  
//
//  Created by Nikolai Nobadi on 7/7/24.
//

import SwiftUI
import iCleanMeSharedUI
import RoomPresentation

public struct ReorderRoomListView: View {
    @State private var editing = EditMode.active
    @StateObject var viewModel: ReorderRoomListViewModel
    
    public init(viewModel: ReorderRoomListViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack {
            List {
                Section {
                    ForEach(viewModel.roomList) { room in
                        Text(room.name)
                            .withFont(autoSizeLineLimit: 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .onMove { fromOffsets, toOffsets in
                        viewModel.roomList.move(fromOffsets: fromOffsets, toOffset: toOffsets)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            
            AsyncTryButton("Save Changes", action: viewModel.saveChanges)
                .buttonStyle(.cleanButtonStyle())
        }
        .padding()
        .mainBackground()
        .environment(\.editMode, $editing)
    }
}


// MARK: - Preview
#Preview {
    ReorderRoomListView(viewModel: .init(section: RoomSection.sampleList[0], saveNewOrder: { _ in }))
        .withPreviewModifiers()
}
