-- Game Tinder Database Schema
-- This file contains the complete database schema for the Game Tinder application

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table - stores user profiles (Steam data stays local)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    display_name VARCHAR(100) NOT NULL,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Sessions table - stores game swiping sessions
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    host_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    session_code VARCHAR(8) UNIQUE NOT NULL, -- 8-character join code
    status VARCHAR(20) DEFAULT 'waiting', -- waiting, active, completed
    max_participants INTEGER DEFAULT 10,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Session participants - many-to-many relationship
CREATE TABLE session_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(session_id, user_id)
);

-- Games table - stores game metadata (Steam App ID for identification only)
CREATE TABLE games (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    steam_app_id INTEGER UNIQUE, -- Steam App ID (public identifier, not personal data)
    name VARCHAR(200) NOT NULL,
    description TEXT,
    image_url TEXT,
    header_image_url TEXT,
    genres TEXT[], -- Array of genre strings
    tags TEXT[], -- Array of tag strings
    is_multiplayer BOOLEAN DEFAULT FALSE,
    max_players INTEGER,
    platforms TEXT[], -- Array of platform strings
    release_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- User game library - stores user's owned games
CREATE TABLE user_games (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    game_id UUID REFERENCES games(id) ON DELETE CASCADE,
    playtime_minutes INTEGER DEFAULT 0,
    last_played_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, game_id)
);

-- Swipes table - stores user swipe actions
CREATE TABLE swipes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    game_id UUID REFERENCES games(id) ON DELETE CASCADE,
    action VARCHAR(10) NOT NULL CHECK (action IN ('like', 'dislike', 'skip')),
    swiped_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(session_id, user_id, game_id)
);

-- Matches table - stores when all users like the same game
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID REFERENCES sessions(id) ON DELETE CASCADE,
    game_id UUID REFERENCES games(id) ON DELETE CASCADE,
    matched_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(session_id, game_id)
);

-- Create indexes for better performance
CREATE INDEX idx_sessions_code ON sessions(session_code);
CREATE INDEX idx_sessions_host ON sessions(host_user_id);
CREATE INDEX idx_session_participants_session ON session_participants(session_id);
CREATE INDEX idx_session_participants_user ON session_participants(user_id);
CREATE INDEX idx_games_steam_app_id ON games(steam_app_id);
CREATE INDEX idx_games_multiplayer ON games(is_multiplayer);
CREATE INDEX idx_user_games_user ON user_games(user_id);
CREATE INDEX idx_user_games_game ON user_games(game_id);
CREATE INDEX idx_swipes_session ON swipes(session_id);
CREATE INDEX idx_swipes_user ON swipes(user_id);
CREATE INDEX idx_swipes_game ON swipes(game_id);
CREATE INDEX idx_matches_session ON matches(session_id);
CREATE INDEX idx_matches_game ON matches(game_id);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add updated_at triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_sessions_updated_at BEFORE UPDATE ON sessions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_games_updated_at BEFORE UPDATE ON games FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
