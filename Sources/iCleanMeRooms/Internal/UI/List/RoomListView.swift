//
//  RoomListView.swift
//  
//
//  Created by Nikolai Nobadi on 7/3/24.
//

import SwiftUI
import iCleanMeSharedUI
import iCleanMeRoomsAccessibility

struct RoomListView: View {
    @StateObject var viewModel: RoomListViewModel
    
    var body: some View {
        VStack {
            PlainRoomListView {
                ForEach(viewModel.topSectionRooms) { room in
                    SharedRoomRowView(room: room) {
                        viewModel.showAllTasks(for: room)
                    }
                }
            }
            .padding(.top)
            .frame(maxHeight: getHeightPercent(18))
            
            PlainRoomListView(leadingInsetPercent: 1) {
                ForEach(viewModel.sections) { section in
                    RoomListSection(section: section, navHandler: viewModel)
                }
            }
        }
        .withEmptyListView(listEmpty: viewModel.noRooms, listType: .rooms) {
            VStack {
                Button("Add house room") {
                    viewModel.showAddRoom(isPersonal: false)
                }
                .padding()
                .buttonStyle(.cleanButtonStyle())
                .setRoomListIdAccessId(.emptyListAddHouseRoomButton)
                
                Button("Add personal room") {
                    viewModel.showAddRoom(isPersonal: true)
                }
                .padding()
                .buttonStyle(.cleanButtonStyle(gradientType: .sunset))
                .setRoomListIdAccessId(.emptyListAddPersonalRoomButton)
                .onlyShow(when: viewModel.isPro)
            }
            .padding()
        }
        .mainBackground()
    }
}


// MARK: - Section
fileprivate struct RoomListSection: View {
    @State private var isExpanded: Bool
    
    let section: RoomSection
    let navHandler: RoomListNavHandler
    
    init(section: RoomSection, navHandler: RoomListNavHandler) {
        self.section = section
        self.navHandler = navHandler
        self._isExpanded = .init(wrappedValue: section.gradient == .seaNight ? true : false)
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            SectionButtons(section: section, navHandler: navHandler)
                .padding([.bottom, .horizontal])
            
            ForEach(section.rooms) { room in
                SharedRoomRowView(room: room, gradientType: section.gradient) {
                    navHandler.showTasks(for: room)
                }
                .withSwipeAction("Edit", tint: .gray, edge: .leading) {
                    navHandler.showEditRoom(room)
                }
                .withSwipeAction("Delete", image: "trash", tint: .red) {
                    navHandler.showDeleteRoom(room)
                }
            }
        } label: {
            Text(section.name)
                .padding(.leading)
                .withFont(.caption)
        }
        .tint(.white)
    }
}


// MARK: - SectionButtons
fileprivate struct SectionButtons: View {
    let section: RoomSection
    let navHandler: RoomListNavHandler
    
    var body: some View {
        HStack {
            Spacer()
            Button("Reorder rooms") {
                navHandler.showReorderRooms(section: section)
            }
            .tint(.gray)
            .foregroundStyle(.black)
            .buttonStyle(.bordered)
            .setRoomListIdAccessId(section.reorderAccessId)
            
            Spacer()
            
            AddRoomButton(isPersonal: section.isPersonal) {
                navHandler.showAddRoom(isPersonal: section.isPersonal)
            }
            .buttonStyle(.bordered)
            .tint(section.isPersonal ? .cleanRed : .blue)
            .setRoomListIdAccessId(section.addRoomAccessId)
            
            Spacer()
        }
    }
}


// MARK: - Preview
#Preview {
    NavStack(title: "My House") {
        RoomListView(viewModel: .init(datasource: .previewInit(), navHandler: PreviewRoomListNavHandler()))
    }
    .withPreviewModifiers()
}


// MARK: - Extension Dependencies
fileprivate extension RoomSection {
    var reorderAccessId: RoomListAccessibilityId {
        return isPersonal ? .personalReorderButton : .houseReorderButton
    }
    
    var addRoomAccessId: RoomListAccessibilityId {
        return isPersonal ? .personalSectionAddRoomButton : .houseSectionAddRoomButton
    }
}
