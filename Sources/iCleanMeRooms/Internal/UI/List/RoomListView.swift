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
            
            SectionPicker(selection: $viewModel.selectedSection)
            PlainRoomListView(leadingInsetPercent: 1) {
                RoomListSection(section: viewModel.sectionToDisplay, navHandler: viewModel)
            }
            .showingConditionalView(isShowing: viewModel.showNonProPersonalList) {
                NonProPersonalRoomsListView()
            }
        }
        .withEmptyListView(listEmpty: viewModel.noRooms, listType: .rooms) {
            EmptyListButtonView(
                isPro: viewModel.isPro,
                addHouseRoom: { viewModel.showAddRoom(isPersonal: false) },
                addPersonalRoom: { viewModel.showAddRoom(isPersonal: true) }
            )
        }
        .mainBackground()
    }
}


// MARK: - SectionPicker
fileprivate struct SectionPicker: View {
    @Binding var selection: RoomSectionType
    
    var body: some View {
        Picker("", selection: $selection) {
            ForEach(RoomSectionType.allCases, id: \.self) { section in
                Text(section.title)
            }
        }
        .padding(5)
        .withGradientBackground(selection.gradient)
        .pickerStyle(.segmented)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
}


// MARK: - Section
fileprivate struct RoomListSection: View {
    let section: RoomSection
    let navHandler: RoomListNavHandler
    
    var body: some View {
        Section {
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
        } header: {
            SectionButtons(section: section, navHandler: navHandler)
                .padding([.bottom, .horizontal])
        }
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


// MARK: - EmptyListButtons
fileprivate struct EmptyListButtonView: View {
    let isPro: Bool
    let addHouseRoom: () -> Void
    let addPersonalRoom: () -> Void
    
    var body: some View {
        VStack {
            Button("Add house room", action: addHouseRoom)          
                .padding()
                .buttonStyle(.cleanButtonStyle())
                .setRoomListIdAccessId(.emptyListAddHouseRoomButton)
            
            Button("Add personal room", action: addPersonalRoom)
                .padding()
                .buttonStyle(.cleanButtonStyle(gradientType: .sunset))
                .setRoomListIdAccessId(.emptyListAddPersonalRoomButton)
                .onlyShow(when: isPro)
        }
        .padding()
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
