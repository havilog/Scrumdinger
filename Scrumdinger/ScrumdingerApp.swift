//
//  ScrumdingerApp.swift
//  Scrumdinger
//
//  Created by havi.log on 2023/04/18.
//

import SwiftUI

@main
struct ScrumdingerApp: App {
    var body: some Scene {
        WindowGroup {
            StandupsList(model: StandupListModel(standups: []))
        }
    }
}
