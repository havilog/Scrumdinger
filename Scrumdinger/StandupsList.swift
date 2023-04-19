//
//  ContentView.swift
//  Scrumdinger
//
//  Created by havi.log on 2023/04/18.
//

import SwiftUI
import Combine

@MainActor
final class StandupListModel: ObservableObject {
    @Published  var standups: [Standup]
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(standups: [Standup]) {
        self.standups = standups
    }
    
    func addStandupButtonTapped() {
        print("havi")
        // present addStandup
    }
    
    func standupTapped(standup: Standup) {
        // push standup
    }
}

struct StandupsList: View {
    @ObservedObject var model: StandupListModel
    
    var body: some View {
        NavigationStack {
            bodyView
                .toolbar {
                    /*
                    // Converting function value of type '@MainActor () -> ()' to '() -> Void' loses global actor 'MainActor'
                    Button(action: model.addStandupButtonTapped) {
                        Image(systemName: "plus")
                    }
                     */
                    Button {
                        model.addStandupButtonTapped()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
//                .sheet(isPresented: <#T##Binding<Bool>#>, onDismiss: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, content: <#T##() -> View#>)
                // TODO: navigationTitle, navigationDestination, alert 구현
        }
    }
    
    private var bodyView: some View {
        List {
            ForEach(model.standups) { standup in
                Button {
                    model.standupTapped(standup: standup)
                } label: {
                    CardView(standup: standup)
                }
                .listRowBackground(standup.theme.mainColor)
            }
        }
    }
}

struct CardView: View {
    let standup: Standup
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.standup.title)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(self.standup.attendees.count)", systemImage: "person.3")
                Spacer()
                Label(self.standup.duration.formatted(.units()), systemImage: "clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(self.standup.theme.accentColor)
    }
}

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}

extension URL {
    fileprivate static let standups = Self.documentsDirectory.appending(component: "standups.json")
}

struct StandupsList_Previews: PreviewProvider {
    static var previews: some View {
        StandupsList(model: .init(standups: [.designMock, .engineeringMock]))
            .previewDisplayName("Mocking initial standups")
    }
}
