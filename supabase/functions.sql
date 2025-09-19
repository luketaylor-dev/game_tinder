-- Database Functions for Game Tinder
-- This file contains PostgreSQL functions for game matching and session management

-- Function to get mutual games between users in a session
CREATE OR REPLACE FUNCTION get_mutual_games(session_uuid UUID)
RETURNS TABLE (
    game_id UUID,
    game_name VARCHAR,
    game_image_url TEXT,
    like_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        g.id as game_id,
        g.name as game_name,
        g.image_url as game_image_url,
        COUNT(s.id) as like_count
    FROM games g
    INNER JOIN user_games ug ON g.id = ug.game_id
    INNER JOIN session_participants sp ON ug.user_id = sp.user_id
    LEFT JOIN swipes s ON g.id = s.game_id AND s.session_id = session_uuid AND s.action = 'like'
    WHERE sp.session_id = session_uuid
    AND g.is_multiplayer = true
    GROUP BY g.id, g.name, g.image_url
    HAVING COUNT(DISTINCT ug.user_id) = (
        SELECT COUNT(*) FROM session_participants WHERE session_id = session_uuid
    )
    ORDER BY like_count DESC, g.name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if a game is a match (all users liked it)
CREATE OR REPLACE FUNCTION check_game_match(session_uuid UUID, game_uuid UUID)
RETURNS BOOLEAN AS $$
DECLARE
    participant_count INTEGER;
    like_count INTEGER;
BEGIN
    -- Get total participants in session
    SELECT COUNT(*) INTO participant_count
    FROM session_participants
    WHERE session_id = session_uuid;
    
    -- Get number of likes for this game
    SELECT COUNT(*) INTO like_count
    FROM swipes
    WHERE session_id = session_uuid 
    AND game_id = game_uuid 
    AND action = 'like';
    
    -- Return true if all participants liked the game
    RETURN like_count = participant_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to create a match when all users like a game
CREATE OR REPLACE FUNCTION create_match_on_all_likes()
RETURNS TRIGGER AS $$
DECLARE
    participant_count INTEGER;
    like_count INTEGER;
BEGIN
    -- Only process 'like' actions
    IF NEW.action != 'like' THEN
        RETURN NEW;
    END IF;
    
    -- Get total participants in session
    SELECT COUNT(*) INTO participant_count
    FROM session_participants
    WHERE session_id = NEW.session_id;
    
    -- Get number of likes for this game
    SELECT COUNT(*) INTO like_count
    FROM swipes
    WHERE session_id = NEW.session_id 
    AND game_id = NEW.game_id 
    AND action = 'like';
    
    -- If all participants liked the game, create a match
    IF like_count = participant_count THEN
        INSERT INTO matches (session_id, game_id)
        VALUES (NEW.session_id, NEW.game_id)
        ON CONFLICT (session_id, game_id) DO NOTHING;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically create matches
CREATE TRIGGER trigger_create_match_on_all_likes
    AFTER INSERT ON swipes
    FOR EACH ROW
    EXECUTE FUNCTION create_match_on_all_likes();

-- Function to get session statistics
CREATE OR REPLACE FUNCTION get_session_stats(session_uuid UUID)
RETURNS TABLE (
    total_participants INTEGER,
    total_games INTEGER,
    total_swipes INTEGER,
    total_matches INTEGER,
    session_status VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        (SELECT COUNT(*) FROM session_participants WHERE session_id = session_uuid)::INTEGER as total_participants,
        (SELECT COUNT(DISTINCT ug.game_id) 
         FROM user_games ug 
         INNER JOIN session_participants sp ON ug.user_id = sp.user_id 
         WHERE sp.session_id = session_uuid)::INTEGER as total_games,
        (SELECT COUNT(*) FROM swipes WHERE session_id = session_uuid)::INTEGER as total_swipes,
        (SELECT COUNT(*) FROM matches WHERE session_id = session_uuid)::INTEGER as total_matches,
        s.status as session_status
    FROM sessions s
    WHERE s.id = session_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get user's swipeable games for a session
CREATE OR REPLACE FUNCTION get_swipeable_games(session_uuid UUID, user_uuid UUID)
RETURNS TABLE (
    game_id UUID,
    game_name VARCHAR,
    game_image_url TEXT,
    game_description TEXT,
    genres TEXT[],
    already_swiped BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        g.id as game_id,
        g.name as game_name,
        g.image_url as game_image_url,
        g.description as game_description,
        g.genres,
        CASE WHEN s.id IS NOT NULL THEN true ELSE false END as already_swiped
    FROM games g
    INNER JOIN user_games ug ON g.id = ug.game_id
    INNER JOIN session_participants sp ON ug.user_id = sp.user_id
    LEFT JOIN swipes s ON g.id = s.game_id AND s.session_id = session_uuid AND s.user_id = user_uuid
    WHERE sp.session_id = session_uuid
    AND sp.user_id = user_uuid
    AND g.is_multiplayer = true
    ORDER BY g.name;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
