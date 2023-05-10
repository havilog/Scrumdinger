//
//  StandupApp.swift
//  Scrumdinger
//
//  Created by havi.log on 2023/05/02.
//

import Combine
import SwiftUI

@MainActor
final class AppModel: ObservableObject {
    @Published var path: [Destination]
    @Published var standupList: StandupListModel
    
    enum Destination: Hashable {
        case detail(StandupDetailModel)
    }
    
    init(
        path: [Destination] = [],
        standupList: StandupListModel
    ) {
        self.path = path
        self.standupList = standupList
        bind()
    }
    
    private func bind() {
        standupList.onStandupTapped = { [weak self] standup in
            self?.path.append(.detail(StandupDetailModel(standup: standup)))
        }
    }
}

struct AppView: View {
    @ObservedObject var model: AppModel
    
    var body: some View {
        NavigationStack(path: $model.path) {
            StandupsList(model: model.standupList)
                .navigationDestination(for: AppModel.Destination.self) { destination in
                    switch destination {
                    case let .detail(detailModel):
                        StandupDetailView(model: detailModel)
                    }
                }
        }
    }
}
