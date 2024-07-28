//
//  AddRoomButton.swift
//
//
//  Created by Nikolai Nobadi on 7/16/24.
//

import SwiftUI
import iCleanMeSharedUI

struct AddRoomButton: View {
    let text: String
    let isPersonal: Bool
    let action: () -> Void
    
    init(_ text: String = "Add new room", isPersonal: Bool, action: @escaping () -> Void) {
        self.text = text
        self.isPersonal = isPersonal
        self.action = action
    }
    
    var body: some View {
        Button(text, action: action)
            .tint(isPersonal ? .cleanRed : .blue)
            .foregroundStyle(.white)
    }
}

