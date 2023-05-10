//
//  StandupDetail.swift
//  Scrumdinger
//
//  Created by havi.log on 2023/05/02.
//

import SwiftUI

@MainActor
final class StandupDetailModel: ObservableObject {
    @Published var standup: Standup
    
    init(
        standup: Standup
    ) {
        self.standup = standup
    }
}

extension StandupDetailModel: Hashable {
    nonisolated static func == (lhs: StandupDetailModel, rhs: StandupDetailModel) -> Bool { lhs === rhs }
    nonisolated func hash(into hasher: inout Hasher) { hasher.combine(ObjectIdentifier(self)) }
}

struct StandupDetailView: View {
    @ObservedObject var model: StandupDetailModel
    
    var body: some View {
        Text("\(model.standup.title)")
    }
}

