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
    @Published var addModel: StandupFormModel?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(standups: [Standup]) {
        self.standups = standups
    }
    
    func addStandupButtonTapped() {
        addModel = .init()
    }
    
    // FIXME: 뷰에서 일어나는 이벤트가 아닌 행위에 대한 이름을 담고 있어서 적절한 네이밍 필요
    func dismissAddSheet() {
        addModel = nil
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
                .toolbar(content: plusButton)
                .sheet(
                    isPresented: Binding(
                        get: { return model.addModel != nil },
                        set: { newValue in
                            if !newValue { model.dismissAddSheet() }
                        }
                    ),
                    onDismiss: {
                        // TODO: dismiss 했을 때 정책 보고 정리
                    },
                    content: standupFormView
                )
                // TODO: navigationTitle, navigationDestination, alert 구현
        }
    }
    
    private func plusButton() -> some View {
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
    
    private func standupFormView() -> some View {
        NavigationStack {
            StandupFormView(model: .init())
                .navigationTitle("New standup")
                // FIXME: 왜 툴바 form에서 붙이지 않고 여기서 붙이는지 알아보기
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
