//
//  PlainRoomListView.swift
//
//
//  Created by Nikolai Nobadi on 7/7/24.
//

import SwiftUI
import iCleanMeSharedUI

struct PlainRoomListView<Content: View>: View {
    let leadingInsetPercent: CGFloat
    let content: () -> Content
    
    init(leadingInsetPercent: CGFloat = 2, @ViewBuilder content: @escaping () -> Content) {
        self.leadingInsetPercent = leadingInsetPercent
        self.content = content
    }
    
    var body: some View {
        List {
            content()
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: getHeightPercent(0.5), leading: getWidthPercent(leadingInsetPercent), bottom: getHeightPercent(0.5), trailing: getWidthPercent(2)))
        }
        .listStyle(.plain)
    }
}
