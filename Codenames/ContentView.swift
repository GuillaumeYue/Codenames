//
//  ContentView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-05.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var gameVM = GameViewModel()
    // Todo：@StateObject private var settingsVM = SettingsViewModel()
    // Todo：@StateObject private var profileVM  = ProfileViewModel()

    var body: some View {
        MainMenuView(vm: gameVM)
    }
}
