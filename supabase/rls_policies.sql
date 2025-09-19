-- Row Level Security (RLS) Policies for Game Tinder
-- This file contains security policies to ensure data privacy and proper access control

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE games ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_games ENABLE ROW LEVEL SECURITY;
ALTER TABLE swipes ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;

-- Users table policies
-- Users can read their own data and other users' public data
CREATE POLICY "Users can view their own data" ON users
    FOR SELECT USING (auth.uid()::text = id::text);

CREATE POLICY "Users can view other users' public data" ON users
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own data" ON users
    FOR INSERT WITH CHECK (auth.uid()::text = id::text);

CREATE POLICY "Users can update their own data" ON users
    FOR UPDATE USING (auth.uid()::text = id::text);

-- Sessions table policies
-- Users can read sessions they participate in
CREATE POLICY "Users can view sessions they participate in" ON sessions
    FOR SELECT USING (
        id IN (
            SELECT session_id FROM session_participants 
            WHERE user_id::text = auth.uid()::text
        )
    );

CREATE POLICY "Users can create sessions" ON sessions
    FOR INSERT WITH CHECK (auth.uid()::text = host_user_id::text);

CREATE POLICY "Hosts can update their sessions" ON sessions
    FOR UPDATE USING (auth.uid()::text = host_user_id::text);

-- Session participants policies
CREATE POLICY "Users can view session participants" ON session_participants
    FOR SELECT USING (
        session_id IN (
            SELECT id FROM sessions WHERE id IN (
                SELECT session_id FROM session_participants 
                WHERE user_id::text = auth.uid()::text
            )
        )
    );

CREATE POLICY "Users can join sessions" ON session_participants
    FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can leave sessions" ON session_participants
    FOR DELETE USING (auth.uid()::text = user_id::text);

-- Games table policies
-- Games are public data, everyone can read
CREATE POLICY "Anyone can view games" ON games
    FOR SELECT USING (true);

CREATE POLICY "System can insert games" ON games
    FOR INSERT WITH CHECK (true); -- In production, restrict this to service role

-- User games policies
CREATE POLICY "Users can view their own game library" ON user_games
    FOR SELECT USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can add games to their library" ON user_games
    FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update their game library" ON user_games
    FOR UPDATE USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can remove games from their library" ON user_games
    FOR DELETE USING (auth.uid()::text = user_id::text);

-- Swipes policies
CREATE POLICY "Users can view swipes in their sessions" ON swipes
    FOR SELECT USING (
        session_id IN (
            SELECT session_id FROM session_participants 
            WHERE user_id::text = auth.uid()::text
        )
    );

CREATE POLICY "Users can create their own swipes" ON swipes
    FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update their own swipes" ON swipes
    FOR UPDATE USING (auth.uid()::text = user_id::text);

-- Matches policies
CREATE POLICY "Users can view matches in their sessions" ON matches
    FOR SELECT USING (
        session_id IN (
            SELECT session_id FROM session_participants 
            WHERE user_id::text = auth.uid()::text
        )
    );

CREATE POLICY "System can create matches" ON matches
    FOR INSERT WITH CHECK (true); -- In production, restrict this to service role
