# Steam API Testing Guide

## 🧪 **Complete Testing Process**

### **Step 1: Get Your Steam Credentials**

#### **Get Your Steam ID:**

1. Go to your Steam profile page
2. Copy the numbers from the URL:
   - **Profile URL format:** `steamcommunity.com/profiles/76561198000000001`
   - **Steam ID:** `76561198000000001` (17-digit number)

#### **Get Your Steam API Key:**

1. Go to [steamcommunity.com/dev/apikey](https://steamcommunity.com/dev/apikey)
2. Sign in with your Steam account
3. Click "Register for a new Web API Key"
4. Enter a domain name (can be anything like "localhost")
5. Copy the generated API key

### **Step 2: Configure Environment**

Update your `.env` file with your Steam API key:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key

# Steam API Configuration
STEAM_API_KEY=your-steam-api-key-here

# App Configuration
DEBUG=true
```

### **Step 3: Run the App**

```bash
flutter run
```

### **Step 4: Test Steam Integration**

#### **Method 1: Using the Debug Test Widget**

1. Run the app in debug mode
2. Navigate to the landing page
3. Look for the "Test Steam API" button (only visible in debug mode)
4. Click the button to open the Steam API test widget
5. Enter your Steam ID and API key
6. Click "Test Steam API"
7. Review the test results

#### **Method 2: Using the Steam Auth Form**

1. On the landing page, look for Steam authentication section
2. Enter your Steam ID and API key
3. Click "Connect Steam Account"
4. Should show success message with your Steam display name

### **Step 5: Expected Test Results**

#### **Successful Test Output:**

```
Steam ID validation: ✅ Valid

Fetching Steam profile...
✅ Profile fetched successfully!
Display Name: YourSteamName
Steam ID: 76561198000000001
Avatar URL: https://avatars.steamstatic.com/...

Fetching Steam games...
✅ Games fetched successfully!
Total multiplayer games: 25

Sample games:
- Counter-Strike 2 (730)
- Apex Legends (1172470)
- Among Us (1244460)
```

#### **Common Error Scenarios:**

**Invalid Steam ID:**

```
Steam ID validation: ❌ Invalid
Steam ID must be 17 digits
```

**Invalid API Key:**

```
❌ Failed to fetch profile: Invalid API key
```

**Private Profile:**

```
❌ Failed to fetch profile: Steam profile not found
```

**Network Issues:**

```
❌ Error: Network error: Connection timeout
```

### **Step 6: Troubleshooting**

#### **Common Issues:**

1. **"Invalid Steam ID format"**

   - Ensure Steam ID is exactly 17 digits
   - No spaces or special characters

2. **"Failed to fetch Steam profile"**

   - Check if API key is correct
   - Ensure Steam profile is public
   - Verify internet connection

3. **"Failed to fetch Steam games"**

   - Profile might be private
   - API key might have insufficient permissions
   - Steam API might be temporarily down

4. **"No multiplayer games found"**
   - User might not own multiplayer games
   - Games might not be properly categorized
   - This is normal for some users

#### **Debug Tips:**

1. **Check Console Logs:**

   ```bash
   flutter run --verbose
   ```

2. **Test with Different Steam IDs:**

   - Try with a friend's public Steam profile
   - Use Steam's official test accounts

3. **Verify API Key:**
   - Test API key at [steamcommunity.com/dev/apikey](https://steamcommunity.com/dev/apikey)
   - Ensure it's not expired

### **Step 7: Production Testing**

Once basic testing works:

1. **Test with multiple users**
2. **Test with different game libraries**
3. **Test error handling (invalid credentials)**
4. **Test network failure scenarios**
5. **Verify privacy (Steam IDs not sent to server)**

## 🎯 **Success Criteria**

✅ **Steam ID validation works**  
✅ **Profile fetching succeeds**  
✅ **Games fetching succeeds**  
✅ **Multiplayer filtering works**  
✅ **Error handling works**  
✅ **Privacy is maintained**

## 🚀 **Next Steps After Testing**

Once Steam API testing is successful:

1. **Integrate with Supabase** - Store game data in database
2. **Build swipe interface** - Create game swiping UI
3. **Implement session management** - Handle multiplayer sessions
4. **Add real-time features** - Live session updates

## 📞 **Need Help?**

If you encounter issues:

1. **Check the console logs** for detailed error messages
2. **Verify your Steam credentials** are correct
3. **Test with a different Steam account** if possible
4. **Check Steam API status** at [steamstat.us](https://steamstat.us)

The debug test widget provides detailed output to help identify exactly where the issue occurs.
