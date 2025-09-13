# Game Tinder 🎮

A Flutter app that helps friend groups discover games everyone wants to play together.

## App Concept

**Game Tinder** is a collaborative game discovery app that solves the problem of "what should we play together?" by combining Steam integration with Tinder-style swiping mechanics.

### How It Works

1. **Create a Friend Group** - Users create groups and invite friends
2. **Link Steam Profiles** - Each friend connects their Steam account
3. **Find Mutual Games** - The app compares Steam libraries to find games everyone owns
4. **Tinder-Style Swiping** - Each friend swipes right (like) or left (dislike) on mutual games
5. **Match Detection** - When everyone in the group likes the same game, it gets flagged as a "match"
6. **Group Notifications** - Everyone gets notified: "Hey! Everyone wants to play [Game Name]!"

### Key Features

- **Steam Integration** - Connect Steam profiles to access game libraries
- **Mutual Game Discovery** - Automatically find games owned by all group members
- **Collaborative Swiping** - Tinder-like interface for game preferences
- **Real-time Matching** - Instant notifications when everyone agrees on a game
- **Group Management** - Create, join, and manage friend groups

### Tech Stack

- **Flutter** - Cross-platform mobile development
- **Riverpod** - State management and dependency injection
- **Steam Web API** - Game library and profile data
- **Real-time Updates** - Live synchronization of swipes across group members

### Target Use Case

Perfect for friend groups who want to:

- Find new games to play together
- Avoid the endless "what should we play?" discussions
- Discover games they all own but haven't tried as a group
- Make quick decisions about multiplayer gaming sessions

## Getting Started

This project uses Flutter with Riverpod for state management.

### Development Setup

1. Install Flutter dependencies:

   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── main.dart                 # App entry point with Riverpod setup
├── providers/               # Riverpod state management
│   ├── providers.dart       # Barrel file for all providers
│   └── counter_provider.dart # Example provider (to be replaced)
└── models/                  # Data models (to be created)
```

## Future Development

The app is currently in the initial setup phase with basic Riverpod integration. Future development will include:

- Steam API integration
- User authentication and profile management
- Friend group creation and management
- Game swiping interface
- Real-time match notifications
- Game filtering and preferences
