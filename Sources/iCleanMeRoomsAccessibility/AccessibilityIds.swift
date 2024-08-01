//
//  AccessibilityIds.swift
//
//
//  Created by Nikolai Nobadi on 7/30/24.
//

// MARK: - RoomList
public enum RoomListAccessibilityId: String {
    case topSectionList
    case roomSectionList
    case editRoomInfoButton
    case houseReorderButton
    case personalReorderButton
    case houseSectionAddRoomButton
    case personalSectionAddRoomButton
    case emptyListAddHouseRoomButton
    case emptyListAddPersonalRoomButton
}


// MARK: - RoomDetail
public enum RoomDetailAccessibilityId: String {
    case roomNameField
    case saveButton = "roomDetailSaveButton"
}


// MARK: - DeleteRoom
public enum DeleteRoomAccessibilityId: String {
    case noTasksLabel
    case missingPermissionsLabel = "deleteRoomMissingPermissionsLabel"
    case roomTaskList = "deleteRoomTaskList"
    case deleteButton = "deleteRoomDeleteButton"
}


// MARK: - DeleteRoom
public enum ReorderRoomAccessibilityId: String {
    case roomList = "reorderRoomList"
    case saveButton = "reorderRoomSaveButton"
}
