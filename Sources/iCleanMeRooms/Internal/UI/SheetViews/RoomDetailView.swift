//
//  RoomDetailView.swift
//  
//
//  Created by Nikolai Nobadi on 7/7/24.
//

import SwiftUI
import iCleanMeSharedUI
import iCleanMeRoomsAccessibility

/// A view that allows users to add or edit room details.
/// Includes a text field for entering the room name and a save button.
struct RoomDetailView: View {
    @FocusState private var fieldIsFocused: Bool
    @StateObject var viewModel: RoomDetailViewModel
    
    var body: some View {
        VStack(spacing: getHeightPercent(5)) {
            VStack(spacing: getHeightPercent(3)) {
                Text(viewModel.title)
                    .withFont()
                
                Text(viewModel.message)
                    .withFont(.caption, isDetail: true)
            }
            .multilineTextAlignment(.center)
            
            VStack {
                TextField("enter room name...", text: $viewModel.room.name)
                    .focused($fieldIsFocused)
                    .textFieldStyle(.cleanFieldStyle())
                    .setRoomDetailIdAccessId(.roomNameField)
                
                AsyncTryButton("Save", action: viewModel.saveRoom)
                    .buttonStyle(.cleanButtonStyle(disabled: !viewModel.canSave))
                    .setRoomDetailIdAccessId(.saveButton)
                    .disabled(!viewModel.canSave)
            }
            .onlyShow(when: viewModel.canAddRoom)
        }
        .padding()
        .mainBackground()
        .onAppear {
            if viewModel.canAddRoom {
                fieldIsFocused = true
            }
        }
    }
}


// MARK: - Preview
#Preview {
    class PreviewDelegate: RoomDetailDelegate {
        func updateRoom(_ room: Room) async throws { }
        func saveNewRoom(_ room: Room) async throws { }
    }
    
    return RoomDetailView(viewModel: .init(room: .sample, delegate: PreviewDelegate(), datasource: .previewInit()))
        .withPreviewModifiers()
}
