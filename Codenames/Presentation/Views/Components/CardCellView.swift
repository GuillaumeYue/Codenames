//
//  CardCellView.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import SwiftUI

struct CardCellView: View {
    let card: Card
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)

                Text(card.word)
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .padding(4)
            }
            .frame(height: 54)
        }
        .disabled(card.isRevealed)
    }

    private var backgroundColor: Color {
        guard card.isRevealed else { return Color(.systemGray6) }
        switch card.type {
        case .red: return .red.opacity(0.35)
        case .blue: return .blue.opacity(0.35)
        case .neutral: return .gray.opacity(0.35)
        case .assassin: return .black.opacity(0.65)
        }
    }
}
