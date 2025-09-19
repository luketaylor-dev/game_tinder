# Game Tinder Setup Guide

## Environment Setup

1. **Copy Environment Template**

   ```bash
   cp .env.example .env
   ```

2. **Configure Your Credentials**
   - Edit `.env` file with your actual credentials
   - **Never commit the `.env` file to version control!**

## Supabase Setup

1. **Create a Supabase Project**

   - Go to [supabase.com](https://supabase.com)
   - Create a new project
   - Note down your project URL and anon key

2. **Update Environment Variables**

   - Edit your `.env` file:

   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key
   ```

3. **Run the App**
   ```bash
   flutter pub get
   flutter run
   ```

## Security Notes

- ✅ `.env` files are automatically ignored by git
- ✅ Use `.env.example` as a template for other developers
- ✅ Never commit real API keys to version control
- ✅ Use different keys for development/production

## Database Schema (Coming Soon)

We'll need to create tables for:

- `users` - User profiles and Steam integration
- `sessions` - Game swiping sessions
- `games` - Game metadata and multiplayer info
- `swipes` - User swipe actions
- `matches` - When all users swipe the same game

## Steam API Integration (Coming Soon)

- Steam Web API for fetching user libraries
- Steam OpenID for authentication
- Game metadata and multiplayer detection

## Next Steps

1. Set up Supabase project and update `.env` file
2. Create database schema
3. Implement Steam authentication
4. Build session management
5. Add real-time swipe functionality
