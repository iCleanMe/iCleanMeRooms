//
//  SharedRoomRowView.swift
//
//
//  Created by Nikolai Nobadi on 7/7/24.
//

import SwiftUI
import iCleanMeSharedUI

struct SharedRoomRowView: View {
    let room: Room
    let gradientType: GradientType
    let onSelection: () -> Void
    let showRoomDetails: (() -> Void)?
    
    private var imageSize: CGFloat {
        return getHeightPercent(5.25)
    }
    
    init(room: Room, gradientType: GradientType = .seaNight, onSelection: @escaping () -> Void, showRoomDetails: (() -> Void)? = nil) {
        self.room = room
        self.gradientType = gradientType
        self.onSelection = onSelection
        self.showRoomDetails = showRoomDetails
    }
    
    var body: some View {
        HStack {
            if let showRoomDetails {
                Button(action: showRoomDetails) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
            
            Text(room.name)
                .padding(2)
                .withFont(textColor: .white, autoSizeLineLimit: 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            
            Image.readyMop
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: imageSize, maxHeight: imageSize)
                .background(
                        ZStack {
                            Circle()
                                .fill(Color.white)
                        }
                    )
                .overlay(alignment: .trailing) {
                    Text("\(room.dirtyTaskCount)")
                        .withFont(.caption2, isDetail: true, textColor: .cleanRed)
                        .padding(.trailing, getWidthPercent(1.5))
                }
                .onlyShow(when: room.dirtyTaskCount > 0)
        }
        .padding(.leading, 10)
        .tappable(withChevron: true) {
            onSelection()
        }
        .padding(.trailing, 10)
        .withGradientBackground(gradientType)
        .cornerRadius(10)
        .frame(maxWidth: .infinity, minHeight: getHeightPercent(7), maxHeight: getHeightPercent(7))
        
    }
}


// MARK: - Preview
#Preview {
    NavStack {
        RoomListView(viewModel: .init(datasource: .previewInit(), navHandler: PreviewRoomListNavHandler()))
    }
    .withPreviewModifiers()
}
