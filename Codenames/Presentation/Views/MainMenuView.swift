//
//  MainMenuView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct MainMenuView: View {

    @ObservedObject var controller: GameController

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                Text("CODENAMES")
                    .font(.system(size: 42, weight: .black))
                    .tracking(4)

                VStack(spacing: 16) {
                    ForEach(controller.mainMenuOptions) { option in
                        Button {
                            controller.selectMenuOption(option: option)
                        } label: {
                            Text(option.optionName)
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(option.destination == "gameBoard" ? .blue : Color(.systemGray5))
                                .foregroundStyle(option.destination == "gameBoard" ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                .padding(.horizontal, 40)

                Spacer()
            }
        }
    }
}
