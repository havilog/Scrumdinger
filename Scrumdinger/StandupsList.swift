//
//  ContentView.swift
//  Scrumdinger
//
//  Created by havi.log on 2023/04/18.
//

import SwiftUI

struct StandupsList: View {
    // viewModel
    let mockStandUp: [Standup] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(self.mockStandUp) { standup in
                    Button {
                        // action Binding
                    } label: {
                        CardView(standup: standup)
                    }
                    .listRowBackground(standup.theme.mainColor)
                }
            }
            // toolbar, navigationTitle, sheet, navigationDestination, alert 구현
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
        StandupsList()
            .previewDisplayName("Mocking initial standups")
    }
}
