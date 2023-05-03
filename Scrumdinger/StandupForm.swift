//
//  StandupForm.swift
//  Scrumdinger
//
//  Created by havi.log on 2023/04/19.
//

import SwiftUI
import Foundation

@MainActor
final class StandupFormModel: ObservableObject {
    @Published var focus: Field?
    @Published var standup: Standup
    
    var onDismissButtonTapped: () -> Void
    var onAddButtonTapped: (Standup) -> Void
    
    enum Field: Hashable {
        case attendee(UUID)
        case title
    }
    
    init(
        standup: Standup,
        onDismissButtonTapped: @escaping () -> Void,
        onAddButtonTapped: @escaping (Standup) -> Void
    ) {
        self.standup = standup
        self.onDismissButtonTapped = onDismissButtonTapped
        self.onAddButtonTapped = onAddButtonTapped
        if self.standup.attendees.isEmpty {
            self.standup.attendees.append(Attendee(id: UUID()))
        }
    }
    
    func deleteAttendees(atOffsets indices: IndexSet) {
        
    }
    
    func addAttendeeButtonTapped() {
        let attendee = Attendee(id: UUID())
        self.standup.attendees.append(attendee)
        self.focus = .attendee(attendee.id)
    }
}

struct StandupFormView: View {
    @FocusState var focus: StandupFormModel.Field?
    @ObservedObject var model: StandupFormModel
    
    var body: some View {
        bodyView
            .toolbar {
                dismissToolbarItem
                addToolbarItem
            }
    }
    
    private var bodyView: some View {
        Form {
            Section {
                TextField("Title", text: self.$model.standup.title)
                    .focused(self.$focus, equals: .title)
                HStack {
                    Slider(value: self.$model.standup.duration.seconds, in: 5...30, step: 1) {
                        Text("Length")
                    }
                    Spacer()
                    Text(self.model.standup.duration.formatted(.units()))
                }
                ThemePicker(selection: self.$model.standup.theme)
            } header: {
                Text("Standup Info")
            }
            Section {
                ForEach(self.$model.standup.attendees) { $attendee in
                    TextField("Name", text: $attendee.name)
                        .focused(self.$focus, equals: .attendee(attendee.id))
                }
                .onDelete { indices in
                    self.model.deleteAttendees(atOffsets: indices)
                }
                
                Button("New attendee") {
                    self.model.addAttendeeButtonTapped()
                }
            } header: {
                Text("Attendees")
            }
        }
//        .bind(self.$model.focus, to: self.$focus)
    }
    
    private var dismissToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Dismiss", action: model.onDismissButtonTapped)
        }
    }
    
    private var addToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Add") {
                model.onAddButtonTapped(model.standup)
            }
        }
    }
}

struct ThemePicker: View {
    @Binding var selection: Theme
    
    var body: some View {
        Picker("Theme", selection: $selection) {
            ForEach(Theme.allCases) { theme in
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(theme.mainColor)
                    Label(theme.name, systemImage: "paintpalette")
                        .padding(4)
                }
                .foregroundColor(theme.accentColor)
                .fixedSize(horizontal: false, vertical: true)
                .tag(theme)
            }
        }
    }
}

extension Duration {
    fileprivate var seconds: Double {
        get { Double(self.components.seconds / 60) }
        set { self = .seconds(newValue * 60) }
    }
}

struct StandupForm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            StandupFormView(
                model: StandupFormModel(
                    standup: .init(id: .init()),
                    onDismissButtonTapped: { },
                    onAddButtonTapped: { _ in }
                )
            )
        }
        .previewDisplayName("4th attendee focused")
    }
}

