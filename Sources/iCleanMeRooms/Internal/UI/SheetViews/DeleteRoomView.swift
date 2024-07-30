//
//  DeleteRoomView.swift
//
//
//  Created by Nikolai Nobadi on 7/12/24.
//

import SwiftUI
import iCleanMeSharedUI
import iCleanMeRoomsAccessibility

struct DeleteRoomView: View {
    @StateObject var viewModel: DeleteRoomViewModel
    
    var body: some View {
        VStack {
            if viewModel.canDelete {
                Text("Are you sure you sure?")
                    .padding()
                    .multilineTextAlignment(.center)
                    .withFont(.headline, autoSizeLineLimit: 1)
                
                if viewModel.noTasks {
                    Spacer()
                    Text("This room does not contain any cleaning tasks.")
                        .padding()
                        .withFont(.headline, isDetail: true)
                        .multilineTextAlignment(.center)
                        .setDeleteRoomIdAccessId(.noTasksLabel)
                    Spacer()
                } else {
                    VStack(spacing: 0) {
                        Text("The following tasks will also be deleted:")
                            .padding()
                            .withFont(autoSizeLineLimit: 1)
                        
                        List(viewModel.taskList) { task in
                            Text(task.name)
                                .withFont(.caption, isDetail: true)
                        }
                        .scrollContentBackground(.hidden)
                        .setDeleteRoomIdAccessId(.roomTaskList)
                    }
                }
                
                AsyncTryButton(viewModel.deleteButtonText, action: viewModel.deleteRoom)
                    .padding()
                    .buttonStyle(.cleanButtonStyle(gradientType: .sunset))
                    .setDeleteRoomIdAccessId(.deleteButton)
            } else {
                Text(viewModel.noPermissionText)
                    .withFont(isDetail: true)
                    .multilineTextAlignment(.center)
                    .padding()
                    .setDeleteRoomIdAccessId(.missingPermissionsLabel)
            }
        }
        .mainBackground()
    }
}


// MARK: - Preview
#Preview("Can Delete, no tasks") {
    DeleteRoomView(viewModel: .previewInit())
        .withPreviewModifiers()
}
#Preview("Can Delete, WITH tasks") {
    DeleteRoomView(viewModel: .previewInit())
        .withPreviewModifiers()
}
#Preview("CANNOT Delete, WITH tasks") {
    DeleteRoomView(viewModel: .previewInit(canDelete: false))
        .withPreviewModifiers()
}
