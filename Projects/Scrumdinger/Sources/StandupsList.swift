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
    @Published var standups: [Standup]
    @Published private(set) var destination: Destination?
    
    private var cancellables: Set<AnyCancellable> = .init()
    var onStandupTapped: ((Standup) -> Void)?
    
    enum Destination {
        case add(StandupFormModel)
    }
    
    init(
        standups: [Standup] = [],
        onStandupTapped: ((Standup) -> Void)? = nil
    ) {
        self.standups = standups
        self.onStandupTapped = onStandupTapped
    }
    
    func addStandupButtonTapped() {
        destination = .add(
            .init(
                standup: .init(id: .init()),
                onDismissButtonTapped: { [weak self] in
                    self?.handleDismissForm()
                },
                onAddButtonTapped: { [weak self] standup in
                    self?.handleAddForm(with: standup)
                }
            )
        )
    }
    
    // MARK: View Action
    
    func standupTapped(standup: Standup) {
        self.onStandupTapped?(standup)
    }
    
    // MARK: Delegate Action
    
    func handleDismissForm() {
        destination = nil
    }
    
    func handleAddForm(with standup: Standup) {
        var standup = standup
        
        standup.attendees.removeAll { attendee in
            attendee.name.allSatisfy(\.isWhitespace)
        }
        
        if standup.attendees.isEmpty {
            standup.attendees.append(Attendee(id: UUID()))
        }
        
        standups.append(standup)
        destination = nil
    }
}

struct StandupsList: View {
    @ObservedObject var model: StandupListModel
    
    var body: some View {
        bodyView
            .toolbar(content: plusButton)
            .sheet(
                isPresented: Binding(
                    get: {
                        if case .add = model.destination { return true }
                        else { return false }
                    },
                    set: { newValue in
                        if !newValue { model.handleDismissForm() }
                    }
                ),
                content: {
                    NavigationStack {
                        if case let .add(formModel) = model.destination {
                            StandupFormView(model: formModel)
                                .navigationTitle("New standup")
                        }
                    }
                }
            )
    }
    
    private func plusButton() -> some View {
        Button {
            model.addStandupButtonTapped()
        } label: {
            Image(systemName: "plus")
        }
        .accessibilityLabel("New Scrum")
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
        NavigationStack {
            StandupsList(
                model: .init(
                    standups: [.designMock, .engineeringMock],
                    onStandupTapped: { standup in
                        
                    }
                )
            )
        }
        .previewDisplayName("Mocking initial standups")
    }
}
