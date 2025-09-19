# Supabase Database Setup Guide

This guide will help you set up the complete database schema for Game Tinder in your Supabase project.

## 📋 **Prerequisites**

1. ✅ Supabase project created
2. ✅ `.env` file configured with your Supabase credentials
3. ✅ Access to Supabase dashboard

## 🗄️ **Database Schema Overview**

The Game Tinder database includes:

- **`users`** - User profiles and Steam integration
- **`sessions`** - Game swiping sessions
- **`session_participants`** - Many-to-many relationship
- **`games`** - Game metadata from Steam
- **`user_games`** - User's game library
- **`swipes`** - User swipe actions
- **`matches`** - When all users like the same game

## 🚀 **Setup Steps**

### **Step 1: Access Supabase SQL Editor**

1. Go to your [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your Game Tinder project
3. Click **"SQL Editor"** in the left sidebar
4. Click **"New query"**

### **Step 2: Create Database Schema**

Copy and paste the contents of `supabase/schema.sql` into the SQL editor and run it:

```sql
-- Copy the entire contents of supabase/schema.sql here
```

This will create:

- All tables with proper relationships
- Indexes for performance
- Triggers for automatic `updated_at` timestamps

### **Step 3: Set Up Security Policies**

Copy and paste the contents of `supabase/rls_policies.sql` into a new query:

```sql
-- Copy the entire contents of supabase/rls_policies.sql here
```

This will:

- Enable Row Level Security (RLS) on all tables
- Create policies for data privacy and access control
- Ensure users can only access their own data

### **Step 4: Add Database Functions**

Copy and paste the contents of `supabase/functions.sql` into a new query:

```sql
-- Copy the entire contents of supabase/functions.sql here
```

This will create:

- `get_mutual_games()` - Find games all users own
- `check_game_match()` - Check if a game is a match
- `create_match_on_all_likes()` - Auto-create matches
- `get_session_stats()` - Session statistics
- `get_swipeable_games()` - Get games for swiping

### **Step 5: Add Sample Data (Optional)**

For testing, you can add sample data by running `supabase/sample_data.sql`:

```sql
-- Copy the entire contents of supabase/sample_data.sql here
```

This creates:

- 4 sample users
- 6 sample games (mix of multiplayer/singleplayer)
- 1 sample session with participants
- Sample swipes and matches

## 🔍 **Verify Setup**

After running all SQL files, verify the setup:

1. **Check Tables**: Go to **"Table Editor"** - you should see all 7 tables
2. **Check Functions**: Go to **"Database" > "Functions"** - you should see 5 functions
3. **Test Sample Data**: Run this query to see mutual games:

```sql
SELECT * FROM get_mutual_games('770e8400-e29b-41d4-a716-446655440001');
```

## 🔒 **Privacy-First Design**

**What Stays Local (Never Sent to Server):**

- ✅ **Steam ID** - Personal identifier stays on device
- ✅ **Steam API Key** - Authentication stays local
- ✅ **Personal Steam Data** - Private profile information

**What Goes to Server (Public Information Only):**

- ✅ **Internal User ID** - For grouping and relationships
- ✅ **Display Name** - For UI purposes
- ✅ **Avatar URL** - For UI purposes
- ✅ **Game Ownership** - Which games user owns (public info)
- ✅ **Steam App ID** - Game identifier (not personal data)

**Why Steam App IDs Are Safe:**

- Game App IDs are public product identifiers
- Similar to ISBN numbers for books
- Not personally identifying information
- Required for reliable game identification

## 📊 **Key Database Functions**

### **Get Mutual Games**

```sql
SELECT * FROM get_mutual_games('session-uuid');
```

### **Get Swipeable Games**

```sql
SELECT * FROM get_swipeable_games('session-uuid', 'user-uuid');
```

### **Get Session Statistics**

```sql
SELECT * FROM get_session_stats('session-uuid');
```

## 🎯 **Next Steps**

After database setup:

1. **Test the app** - Run `flutter run` to verify Supabase connection
2. **Implement Steam API** - Connect to Steam for real game data
3. **Build UI components** - Create swipe interface
4. **Add real-time features** - Live session updates

## 🆘 **Troubleshooting**

**Common Issues:**

- **Permission Denied**: Check RLS policies are applied correctly
- **Function Not Found**: Ensure all functions were created successfully
- **Connection Error**: Verify `.env` file has correct Supabase credentials

**Need Help?**

- Check Supabase logs in the dashboard
- Verify all SQL files ran without errors
- Test with sample data first
