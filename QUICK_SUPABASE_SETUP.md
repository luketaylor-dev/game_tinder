# Quick Supabase Setup Guide

## Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click "New Project"
3. Choose your organization and give it a name like "game-tinder"
4. Set a database password (save this!)
5. Choose a region close to you
6. Click "Create new project"

## Step 2: Get Your Credentials

1. Once your project is created, go to **Settings** → **API**
2. Copy your **Project URL** (looks like `https://abcdefgh.supabase.co`)
3. Copy your **anon public** key (long string starting with `eyJ...`)

## Step 3: Create .env File

Create a file called `.env` in your project root with:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Steam API Configuration (optional for now)
STEAM_API_KEY=your-steam-api-key-here

# App Configuration
DEBUG=true
```

## Step 4: Set Up Database

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the contents of `supabase/schema.sql`
3. Paste it into the SQL editor and click **Run**

## Step 5: Test the App

```bash
flutter run --debug
```

The app should now connect to Supabase and sessions will work across devices!

## Troubleshooting

- **"Failed to load environment variables"**: Make sure your `.env` file exists and has the correct format
- **"Failed to initialize Supabase"**: Check your SUPABASE_URL and SUPABASE_ANON_KEY are correct
- **Database errors**: Make sure you ran the schema.sql file in Supabase

## What This Enables

✅ **Cross-device session sharing** - Create session on phone, join on computer  
✅ **Real-time updates** - See when friends join sessions  
✅ **Persistent data** - Sessions survive app restarts  
✅ **Scalable** - Works with any number of users  
✅ **Secure** - Row Level Security protects user data
