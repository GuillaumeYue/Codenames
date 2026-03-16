//
//  HelpGuide.swift
//  Codenames
//
//  Created by Frostmourne on 2026-02-14.
//

import Foundation

// Class Diagram, Domain Model, CD-CO23, CD-CO24, SSD-6
struct HelpGuide {
    let objectiveText: String           // Class Diagram, Domain Model
    let roleDescription: String         // Class Diagram, Domain Model
    let turnStructure: String           // Class Diagram, Domain Model
    let winConditionText: String        // Class Diagram, Domain Model

    // Class Diagram (openHowToPlay), CD-CO23
    static func openHowToPlay() -> HelpGuide {
        return HelpGuide(
            objectiveText: """
                Codenames is a team word game. Two teams compete to identify their agents \
                on the board using one-word clues given by their Spymaster.
                """,
            roleDescription: """
                Spymaster: Gives a one-word clue and a number indicating how many cards \
                relate to that clue. Can see the key card showing all card identities.\n\n\
                Operative: Guesses which cards belong to their team based on the Spymaster's clue. \
                Taps cards on the board to reveal them.
                """,
            turnStructure: """
                1. The Spymaster gives a one-word clue and a number.\n\
                2. Operatives guess by tapping cards (up to number + 1 guesses).\n\
                3. If a correct card is revealed, the team may continue guessing.\n\
                4. If a wrong team card or neutral card is revealed, the turn ends.\n\
                5. If the Assassin card is revealed, the game is immediately over.
                """,
            winConditionText: """
                A team wins by revealing all of their agent cards. The starting team has 9 cards \
                to find, while the other team has 8. If a team reveals the Assassin, they immediately lose.
                """
        )
    }

    // Class Diagram (getInstructions)
    func getInstructions() -> [String: String] {
        return [
            "Objective": objectiveText,
            "Roles": roleDescription,
            "Turn Structure": turnStructure,
            "Win Condition": winConditionText
        ]
    }

    // Class Diagram (scrollContent), CD-CO24, SSD-6 step 2.1
    func scrollContent(direction: String, delta: CGFloat) {
    }
}
