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
    @Published var destination: Destination?
    
    var onConfirmDeletion: (() -> Void)?
    
    enum Destination {
        case alert(AlertState)
        case edit(StandupFormModel)
        case meeting
        case record
    }
    
    enum AlertState {
        case deleteStandup
        case speechRecognitionDenied
        case speechRecognitionRestricted
    }
    
    init(
        standup: Standup
    ) {
        self.standup = standup
    }
    
    func deleteButtonTapped() {
        self.destination = .alert(.deleteStandup)
    }
    
    func editButtonTapped() {
        self.destination = .edit(
            .init(
                standup: self.standup,
                onDismissButtonTapped: {
                    self.destination = nil
                },
                onAddButtonTapped: { standup in
                    self.standup = standup
                    self.destination = nil
                }
            )
        )
    }
    
    func dismissAlert() {
        self.destination = nil
    }
    
    func alertTapped(_ state: AlertState) {
        switch state {
        case .deleteStandup:
            onConfirmDeletion?()
            dismissAlert()
            
        case .speechRecognitionDenied, .speechRecognitionRestricted:
            return
        }
    }
}

extension StandupDetailModel: Hashable {
    nonisolated static func == (lhs: StandupDetailModel, rhs: StandupDetailModel) -> Bool { lhs === rhs }
    nonisolated func hash(into hasher: inout Hasher) { hasher.combine(ObjectIdentifier(self)) }
}

struct StandupDetailView: View {
    @ObservedObject var model: StandupDetailModel
    
    var body: some View {
        List {
            Section {
                Button {
                    //              self.model.startMeetingButtonTapped()
                } label: {
                    Label("Start Meeting", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "clock")
                    Spacer()
                    Text(self.model.standup.duration.formatted(.units()))
                }
                
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(self.model.standup.theme.name)
                        .padding(4)
                        .foregroundColor(self.model.standup.theme.accentColor)
                        .background(self.model.standup.theme.mainColor)
                        .cornerRadius(4)
                }
            } header: {
                Text("Standup Info")
            }
            
            if !self.model.standup.meetings.isEmpty {
                Section {
                    ForEach(self.model.standup.meetings) { meeting in
                        Button {
//                            self.model.meetingTapped(meeting)
                        } label: {
                            HStack {
                                Image(systemName: "calendar")
                                Text(meeting.date, style: .date)
                                Text(meeting.date, style: .time)
                            }
                        }
                    }
                    .onDelete { indices in
//                        self.model.deleteMeetings(atOffsets: indices)
                    }
                } header: {
                    Text("Past meetings")
                }
            }
            
            Section {
                ForEach(self.model.standup.attendees) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            } header: {
                Text("Attendees")
            }
            
            Section {
                Button("Delete") {
                    self.model.deleteButtonTapped()
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(self.model.standup.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    self.model.editButtonTapped()
                }
            }
        }
        .alert(
            "Delete",
            isPresented: Binding(
                get: {
                    guard case .alert = self.model.destination else { return false }
                    return true
                },
                set: { isPresent, transaction in
                    if !isPresent { self.model.dismissAlert() }
                }
            ),
            presenting: model.destination,
            actions: { destination in
                if case let .alert(state) = destination {
                    HStack {
                        Button("nevermind", action: { model.dismissAlert() })
                        Button("yes", action: { model.alertTapped(state) })
                    }
                }
            },
            message: { _ in Text("Are you sure to delete meeting?") }
        )
//        .navigationDestination(
//            unwrapping: self.$model.destination,
//            case: /StandupDetailModel.Destination.meeting
//        ) { $meeting in
//            MeetingView(meeting: meeting, standup: self.model.standup)
//        }
//        .navigationDestination(
//            unwrapping: self.$model.destination,
//            case: /StandupDetailModel.Destination.record
//        ) { $model in
//            RecordMeetingView(model: model)
//        }
//        .alert(
//            unwrapping: self.$model.destination,
//            case: /StandupDetailModel.Destination.alert
//        ) { action in
//            await self.model.alertButtonTapped(action)
//        }
//        .sheet(
//            unwrapping: self.$model.destination,
//            case: /StandupDetailModel.Destination.edit
//        ) { $editModel in
//            NavigationStack {
//                StandupFormView(model: editModel)
//                    .navigationTitle(self.model.standup.title)
//                    .toolbar {
//                        ToolbarItem(placement: .cancellationAction) {
//                            Button("Cancel") {
//                                self.model.cancelEditButtonTapped()
//                            }
//                        }
//                        ToolbarItem(placement: .confirmationAction) {
//                            Button("Done") {
//                                self.model.doneEditingButtonTapped()
//                            }
//                        }
//                    }
//            }
//        }
//        .onChange(of: self.model.isDismissed) { _ in self.dismiss() }
    }
}

struct MeetingView: View {
    let meeting: Meeting
    let standup: Standup
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("Attendees")
                    .font(.headline)
                ForEach(self.standup.attendees) { attendee in
                    Text(attendee.name)
                }
                Text("Transcript")
                    .font(.headline)
                    .padding(.top)
                Text(self.meeting.transcript)
            }
        }
        .navigationTitle(Text(self.meeting.date, style: .date))
        .padding()
    }
}
