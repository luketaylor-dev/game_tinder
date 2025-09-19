-- Sample Data for Game Tinder Database
-- This file contains test data to verify the database schema works correctly

-- Insert sample users (no Steam IDs - they stay local)
INSERT INTO users (id, display_name, avatar_url) VALUES
    ('550e8400-e29b-41d4-a716-446655440001', 'AliceGamer', 'https://avatars.steamstatic.com/avatar1.jpg'),
    ('550e8400-e29b-41d4-a716-446655440002', 'BobTheBuilder', 'https://avatars.steamstatic.com/avatar2.jpg'),
    ('550e8400-e29b-41d4-a716-446655440003', 'CharlieChamp', 'https://avatars.steamstatic.com/avatar3.jpg'),
    ('550e8400-e29b-41d4-a716-446655440004', 'DianaDestroyer', 'https://avatars.steamstatic.com/avatar4.jpg');

-- Insert sample games (popular multiplayer games)
INSERT INTO games (id, steam_app_id, name, description, image_url, header_image_url, genres, tags, is_multiplayer, max_players, platforms, release_date) VALUES
    ('660e8400-e29b-41d4-a716-446655440001', 730, 'Counter-Strike 2', 'The world''s premier competitive FPS', 'https://cdn.akamai.steamstatic.com/cs2.jpg', 'https://cdn.akamai.steamstatic.com/cs2_header.jpg', ARRAY['Action', 'FPS'], ARRAY['Multiplayer', 'Competitive', 'Shooter'], true, 10, ARRAY['Windows', 'Linux'], '2023-09-27'),
    ('660e8400-e29b-41d4-a716-446655440002', 1172470, 'Apex Legends', 'Battle royale hero shooter', 'https://cdn.akamai.steamstatic.com/apex.jpg', 'https://cdn.akamai.steamstatic.com/apex_header.jpg', ARRAY['Action', 'Battle Royale'], ARRAY['Multiplayer', 'Free to Play', 'Shooter'], true, 60, ARRAY['Windows'], '2020-11-04'),
    ('660e8400-e29b-41d4-a716-446655440003', 1091500, 'Cyberpunk 2077', 'Open-world action-adventure RPG', 'https://cdn.akamai.steamstatic.com/cp2077.jpg', 'https://cdn.akamai.steamstatic.com/cp2077_header.jpg', ARRAY['RPG', 'Action'], ARRAY['Singleplayer', 'Story Rich', 'Futuristic'], false, 1, ARRAY['Windows', 'PlayStation', 'Xbox'], '2020-12-10'),
    ('660e8400-e29b-41d4-a716-446655440004', 1244460, 'Among Us', 'Online multiplayer social deduction game', 'https://cdn.akamai.steamstatic.com/amongus.jpg', 'https://cdn.akamai.steamstatic.com/amongus_header.jpg', ARRAY['Casual', 'Indie'], ARRAY['Multiplayer', 'Social Deduction', 'Funny'], true, 15, ARRAY['Windows', 'Android', 'iOS'], '2018-11-16'),
    ('660e8400-e29b-41d4-a716-446655440005', 1174180, 'Red Dead Redemption 2', 'Western action-adventure game', 'https://cdn.akamai.steamstatic.com/rdr2.jpg', 'https://cdn.akamai.steamstatic.com/rdr2_header.jpg', ARRAY['Action', 'Adventure'], ARRAY['Open World', 'Story Rich', 'Western'], true, 32, ARRAY['Windows', 'PlayStation', 'Xbox'], '2019-11-05'),
    ('660e8400-e29b-41d4-a716-446655440006', 271590, 'Grand Theft Auto V', 'Open world action-adventure', 'https://cdn.akamai.steamstatic.com/gta5.jpg', 'https://cdn.akamai.steamstatic.com/gta5_header.jpg', ARRAY['Action', 'Adventure'], ARRAY['Open World', 'Multiplayer', 'Crime'], true, 30, ARRAY['Windows', 'PlayStation', 'Xbox'], '2015-04-14');

-- Insert user game libraries (users own different combinations of games)
INSERT INTO user_games (user_id, game_id, playtime_minutes, last_played_at) VALUES
    -- Alice owns CS2, Apex, Among Us
    ('550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 1200, NOW() - INTERVAL '2 days'),
    ('550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440002', 800, NOW() - INTERVAL '1 day'),
    ('550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440004', 300, NOW() - INTERVAL '3 days'),
    
    -- Bob owns CS2, Cyberpunk, Among Us
    ('550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', 900, NOW() - INTERVAL '1 day'),
    ('550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440003', 2000, NOW() - INTERVAL '5 days'),
    ('550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440004', 150, NOW() - INTERVAL '1 week'),
    
    -- Charlie owns Apex, RDR2, GTA5
    ('550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440002', 1500, NOW() - INTERVAL '1 day'),
    ('550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440005', 800, NOW() - INTERVAL '3 days'),
    ('550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440006', 3000, NOW() - INTERVAL '2 days'),
    
    -- Diana owns CS2, Among Us, GTA5
    ('550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440001', 600, NOW() - INTERVAL '1 day'),
    ('550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440004', 200, NOW() - INTERVAL '2 days'),
    ('550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440006', 1200, NOW() - INTERVAL '1 day');

-- Insert a sample session
INSERT INTO sessions (id, name, host_user_id, session_code, status, max_participants) VALUES
    ('770e8400-e29b-41d4-a716-446655440001', 'Friday Night Gaming', '550e8400-e29b-41d4-a716-446655440001', 'ABC12345', 'active', 4);

-- Insert session participants
INSERT INTO session_participants (session_id, user_id) VALUES
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001'),
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002'),
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003'),
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004');

-- Insert some sample swipes (simulating users swiping on games)
INSERT INTO swipes (session_id, user_id, game_id, action) VALUES
    -- Alice swipes on CS2 (like), Among Us (like)
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 'like'),
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440004', 'like'),
    
    -- Bob swipes on CS2 (like), Among Us (like)
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440001', 'like'),
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440004', 'like'),
    
    -- Charlie swipes on Among Us (like)
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440004', 'like'),
    
    -- Diana swipes on CS2 (like), Among Us (like)
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440001', 'like'),
    ('770e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440004', 'like');

-- Note: The trigger should automatically create matches for CS2 and Among Us
-- since all participants liked them
