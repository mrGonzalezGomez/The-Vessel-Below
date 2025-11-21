# Changelog — The Vessel Below

## PRE-Alpha Development (Milestones)

### Summary
Foundational work establishing the core systems, assets and initial scenes.

### Added
- Week 1 — Discovery & Planning
	- Godot tutorials and a test project to validate engine and tools
	- Story and mood notes (inspired by *Amnesia: The Bunker*)
	- Initial scene and main menu
	- Collected first visual and audio assets
	- Planning tools established (Trello, Git)

### Core systems implemented
- Week 2 — Core Gameplay Features
	- Player movement and camera controls
	- Collision, interaction logic and trigger zones
	- Basic inventory system
	- Dialogue system with NPCs and first scripted narrative events
	- Basic progression (trigger zones)

### Polishing & Release prep
- Week 3 — Finalization
	- UI/UX improvements (transitions, feedback)
	- Additional content: rooms, items and audio
	- Extensive debugging and stabilization
	- User and technical documentation authored
	- Short trailer recorded
	- Exported demo builds for Linux, Windows and macOS

## Alpha Development

### Overview
Early alpha focused on gameplay, accessibility settings and polish; followed by iterative refinements and new content additions.

### Week 1
- New features
	- New flashlight with cursor control (initial/basic implementation)
	- Brightness slider in settings
	- Sound volume slider in settings
	- Language selection menu (English, Spanish, French)
	- Updated localization scripts and resources

### Week 2

- New Features
	- Implemented: Maintenance Bay (new room at the end of the main corridor)
	- Upgraded: Flashlight flicker effect when allies or enemies are present
	- NPC added: Holloway -> Provides hints and backstory (located in Maintenance Bay)

- Refinements and Enhancements
	- Improved time lapse timing between Menu and Prologue for pacing
	- Adjusted flashlight power for better gameplay visibility
	- Added room indicators to highlight interactable areas for navigation

### Week 3
- New Features
	- Updated inventory system to include notes and documents
	- Added new note items with lore, hints and unique assets
	- Added interactions with notes in the inventory (viewing pages)
	- Added 2 new rooms in the corridor area (Dark Corridor and Motor Room stairs) with new sound effects and visual assets

- Refinements and Enhancements
	- Removed arrow indicator for NPC and items/notes to increase immersion (Temporarily -> Will be reworked later with a accessibility toggle)

- Bug Fixes
	- Fixed cursor removal bug when finishing the Maintenance Bay dialogue
	- Fixed flashlight flicker effect bug when entering new rooms
	- Fixed cursor and lighting display when opening inventory

### Week 4
- New Features
	- Added new core mechanic for the flashlight -> Turn on and off with right click
	- Added a new in-game pause menu -> Resume, Options (TODO), Quit
	- Added a new accessibility option in the settings page -> Immersive Option (Hides/shows all UI elements)
	- Added a new item -> The Radio (Located in the Dark Corridor) with unique audio and visual assets

- Refinements and Enhancements
	- Updated sound design for multiple elements -> Inventory, notes and flashlight
	- Updated bus sound design for the music in the menu and in-game
