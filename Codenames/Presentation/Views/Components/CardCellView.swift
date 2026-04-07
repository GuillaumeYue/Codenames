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
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 2)

                // Top color strip for revealed cards
                if card.isRevealed {
                    VStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(stripColor)
                            .frame(height: 6)
                        Spacer()
                    }
                }

                Text(card.word)
                    .font(.system(size: 11, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(textColor)
                    .padding(4)
            }
            .frame(height: 58)
        }
        .disabled(card.isRevealed)
    }

    private var backgroundColor: Color {
        guard card.isRevealed else { return GameColor.cardUnrevealed }
        switch card.cardType {
        case .red: return GameColor.cardRed
        case .blue: return GameColor.cardBlue
        case .neutral: return GameColor.cardNeutral
        case .assassin: return GameColor.cardAssassin
        }
    }

    private var stripColor: Color {
        switch card.cardType {
        case .red: return GameColor.teamRed.opacity(0.6)
        case .blue: return GameColor.teamBlue.opacity(0.6)
        case .neutral: return Color.brown.opacity(0.4)
        case .assassin: return Color.white.opacity(0.1)
        }
    }

    private var textColor: Color {
        if card.isRevealed {
            return card.cardType == .neutral ? GameColor.textOnCard : GameColor.textOnRevealedCard
        }
        return GameColor.textOnCard
    }
}
