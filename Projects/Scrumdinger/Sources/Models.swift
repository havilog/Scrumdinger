//
//  Models.swift
//  Scrumdinger
//
//  Created by havi.log on 2023/04/18.
//

import SwiftUI
import Foundation

struct Standup: Equatable, Hashable, Identifiable, Codable {
    let id: UUID
    var attendees: [Attendee] = []
    var duration = Duration.seconds(60 * 5)
    var meetings: [Meeting] = []
    var theme: Theme = .bubblegum
    var title: String = ""
    
    var durationPerAttendee: Duration {
      self.duration / self.attendees.count
    }
}

struct Attendee: Equatable, Hashable, Identifiable, Codable {
  let id: UUID
  var name = ""
}

struct Meeting: Equatable, Hashable, Identifiable, Codable {
  let id: UUID
  let date: Date
  var transcript: String
}

enum Theme: String, CaseIterable, Equatable, Hashable, Identifiable, Codable {
  case bubblegum
  case buttercup
  case indigo
  case lavender
  case magenta
  case navy
  case orange
  case oxblood
  case periwinkle
  case poppy
  case purple
  case seafoam
  case sky
  case tan
  case teal
  case yellow

  var id: Self { self }

  var accentColor: Color {
    switch self {
    case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan,
        .teal, .yellow:
      return .black
    case .indigo, .magenta, .navy, .oxblood, .purple:
      return .white
    }
  }

  var mainColor: Color { Color(self.rawValue) }

  var name: String { self.rawValue.capitalized }
}

extension Standup {
  static let mock = Self(
    id: UUID(),
    attendees: [
      Attendee(id: UUID(), name: "Blob"),
      Attendee(id: UUID(), name: "Blob Jr"),
      Attendee(id: UUID(), name: "Blob Sr"),
      Attendee(id: UUID(), name: "Blob Esq"),
      Attendee(id: UUID(), name: "Blob III"),
      Attendee(id: UUID(), name: "Blob I"),
    ],
    duration: .seconds(60),
    meetings: [
      Meeting(
        id: UUID(),
        date: Date().addingTimeInterval(-60 * 60 * 24 * 7),
        transcript: """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor \
          incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud \
          exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure \
          dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. \
          Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt \
          mollit anim id est laborum.
          """
      )
    ],
    theme: .orange,
    title: "Design"
  )

  static let engineeringMock = Self(
    id: UUID(),
    attendees: [
      Attendee(id: UUID(), name: "Blob"),
      Attendee(id: UUID(), name: "Blob Jr"),
    ],
    duration: .seconds(60 * 10),
    meetings: [],
    theme: .periwinkle,
    title: "Engineering"
  )

  static let designMock = Self(
    id: UUID(),
    attendees: [
      Attendee(id: UUID(), name: "Blob Sr"),
      Attendee(id: UUID(), name: "Blob Jr"),
    ],
    duration: .seconds(60 * 30),
    meetings: [],
    theme: .poppy,
    title: "Product"
  )
}
