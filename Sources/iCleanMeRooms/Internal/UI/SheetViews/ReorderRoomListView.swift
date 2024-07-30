//
//  ReorderRoomListView.swift
//  
//
//  Created by Nikolai Nobadi on 7/7/24.
//

import SwiftUI
import iCleanMeSharedUI

struct ReorderRoomListView: View {
    #if canImport(UIKit)
    @State private var editing = EditMode.active
    #endif
    @StateObject var viewModel: ReorderRoomListViewModel
    
    var body: some View {
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
            #if canImport(UIKit)
            .listStyle(.insetGrouped)
            #endif
            .scrollContentBackground(.hidden)
            .setReorderRoomIdAccessId(.roomList)
            
            AsyncTryButton("Save Changes", action: viewModel.saveChanges)
                .buttonStyle(.cleanButtonStyle())
                .setReorderRoomIdAccessId(.saveButton)
        }
        .padding()
        .mainBackground()
        #if canImport(UIKit)
        .environment(\.editMode, $editing)
        #endif
    }
}


// MARK: - Preview
#Preview {
    ReorderRoomListView(viewModel: .init(section: RoomSection.sampleList[0], saveNewOrder: { _ in }))
        .withPreviewModifiers()
}
