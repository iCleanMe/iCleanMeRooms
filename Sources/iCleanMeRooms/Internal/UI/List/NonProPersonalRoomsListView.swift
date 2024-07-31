//
//  NonProPersonalRoomsListView.swift
//  
//
//  Created by Nikolai Nobadi on 7/31/24.
//

import SwiftUI
import iCleanMeSharedUI

struct NonProPersonalRoomsListView: View {
    var body: some View {
        VStack(spacing: getHeightPercent(5)) {
            Text("Restricted")
                .padding(.top, getHeightPercent(3))
                .withFont(.title3, autoSizeLineLimit: 1)
            
            VStack(spacing: getHeightPercent(3)) {
                Text("Only iCleanMe Pros can create Personal rooms.")
                    .withFont(isDetail: true)
                Text("Hint: You can upgrade to Pro from Settings.")
                    .padding(.horizontal)
                    .withFont(isDetail: true, autoSizeLineLimit: 1)
            }
            .multilineTextAlignment(.center)
        }
        .mainBackground()
    }
}


// MARK: - Preview
#Preview {
    NonProPersonalRoomsListView()
}
