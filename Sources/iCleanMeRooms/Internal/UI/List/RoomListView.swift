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
    @State private var showingAddButton = true
    @StateObject var viewModel: RoomListViewModel
    
    func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let velocityY = gesture.velocity(in: gesture.view).y
        
        if velocityY < 0 {
            if -(velocityY / 5) > 60 && showingAddButton {
                showingAddButton = false
            }
        } else {
            if (velocityY / 5) > 40 && !showingAddButton {
                showingAddButton = true
            }
        }
    }
    
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
            .setRoomListIdAccessId(.topSectionList)
            
            SectionPicker(selection: $viewModel.selectedSection)
            
            PlainRoomListView(leadingInsetPercent: 1) {
                RoomListSection(section: viewModel.sectionToDisplay, navHandler: viewModel)
            }
            .background(
                CustomGesture {
                    handleGesture($0)
                }
            )
            .setRoomListIdAccessId(.roomSectionList)
            .showingConditionalView(isShowing: viewModel.showNonProPersonalList) {
                NonProPersonalRoomsListView()
            }
            .overlay(alignment: .bottom) {
                if showingAddButton {
                    AddButton {
                        viewModel.showAddRoom(isPersonal: viewModel.selectedSection.isPersonal)
                    }
                    .transition(.move(edge: .bottom))
                    .setRoomListIdAccessId(.addRoomButton)
                }
            }
        }
        .animation(.default, value: showingAddButton)
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
                } showRoomDetails: {
                    navHandler.showEditRoom(room)
                }
                .withSwipeAction(info: .init(prompt: "Delete"), systemImage: "trash", tint: .red) {
                    navHandler.showDeleteRoom(room)
                }
            }
        } header: {
            HStack {
                Spacer()
                Button("Reorder rooms") {
                    navHandler.showReorderRooms(section: section)
                }
                .tint(.gray)
                .foregroundStyle(.black)
                .buttonStyle(.bordered)
                .setRoomListIdAccessId(.reorderButton)
            }
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



// TODO: - Move to SharedUI
fileprivate struct AddButton: View {
    let action: () throws -> Void
    
    private var buttonSize: CGFloat {
        #if canImport(UIKit)
        return getHeightPercent(isSmallPhone ? 8 : 6)
        #else
        return getHeightPercent(6)
        #endif
    }
    
    var body: some View {
        TryButton(action: action) {
            Image(systemName: "plus")
                .withFont(.title3, textColor: .white)
        }
        .frame(maxWidth: buttonSize, maxHeight: buttonSize)
        .withGradientBackground(.seaNight)
        .clipShape(Circle())
        .shadow(color: .primary, radius: 7)
    }
}


struct CustomGesture: UIViewRepresentable {
    private let gestureId = UUID().uuidString
    
    var onChange: (UIPanGestureRecognizer) -> Void
    
    func makeCoordinator() -> Coordinator {
        return .init(onChange: onChange)
    }
    
    func makeUIView(context: Context) -> some UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let superview = uiView.superview?.superview, !(superview.gestureRecognizers?.contains(where: { $0.name == gestureId }) ?? false) {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.gestureChange(gesture:)))
                
                gesture.name = gestureId
                gesture.delegate = context.coordinator
                
                superview.addGestureRecognizer(gesture)
            }
        }
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var onChange: (UIPanGestureRecognizer) -> Void
        
        init(onChange: @escaping (UIPanGestureRecognizer) -> Void) {
            self.onChange = onChange
        }
        
        @objc
        func gestureChange(gesture: UIPanGestureRecognizer) {
            onChange(gesture)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
