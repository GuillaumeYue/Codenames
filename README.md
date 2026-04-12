# Codenames iOS Game
A SwiftUI implementation of the board game Codenames.
Developed across three iterations for Information System Implementation (420-MP6-AS) — Winter 2026.

Features (Iteration 1 — Core Gameplay)：

·5×5 random board generation with KeyCard assignments
·Spymaster clue submission with validation
·Operative card selection and guess resolution
·Turn switching between Red and Blue teams
·Assassin handling (immediate loss)
·Win/Loss detection (target score reached)
·Game Over screen with scores

Features (Iteration 2 — Navigation, Settings, Game Management)：

·Main Menu with navigation (New Game, How to Play, Settings)
·How to Play screen with scrollable instructions
·Settings screen (sound, music, haptic toggles; theme selection; reset to defaults)
·Pause Menu overlay (Resume, How to Play, Settings, Quit)
·Quit confirmation dialog

Features (Iteration 3 — Persistence, About & Error Recovery)：

·Auto-save game state on background transition and significant state changes
·Restore saved game on app launch with resume/discard prompt
·About screen with version, credits, and legal notice
·Error handling for word bank load, board generation, corrupted saves, and UI errors


Architecture：

The project follows a controller-driven SwiftUI structure:
·Domain/Models – Game entities, enums, and state objects
·Domain/Services – WordBank, RulesValidator, PersistenceManager, SaveManager, ErrorHandler, RecoveryManager
·Presentation/ViewModels – GameController (orchestration) and UIManager (navigation/UI state)
·Presentation/Views – SwiftUI screens and components

Gameplay, navigation, and persistence contracts follow the project diagrams (UC, SSD, CD-CO, Class Diagram, Domain Model).


How to Run：

·Open the project in Xcode
·Select an iPhone simulator
·Press ⌘ + R


Authors：

·Antonio Moriello
·Han Yue
·Apostolos Tsouroupakis

