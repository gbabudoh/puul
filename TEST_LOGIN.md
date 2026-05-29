# 🔐 PUUL Demo Login - Step by Step

## ✅ EXACT CREDENTIALS TO USE

```
Username: demo
Password: demo123
```

## 📱 Step-by-Step Instructions

### Step 1: Check the Simulator
- Make sure the iPhone simulator is open
- You should see the PUUL login screen

### Step 2: Enter Credentials
1. Tap on the "Phone Number or Username" field
2. Type exactly: **demo**
3. Tap on the "Password" field  
4. Type exactly: **demo123**

### Step 3: Login
- Tap the **"Login"** button
- You'll see a loading spinner for ~1 second
- Then you'll be taken to the onboarding flow

### Step 4: Complete Onboarding
- Swipe through 4 pages OR click "Skip"
- Click "Get Started" on the last page
- You'll reach the home screen with demo PUULs

## 🔄 If It's Not Working

### Option 1: Hot Restart
In your terminal where Flutter is running, press:
- **R** (capital R) for hot restart
- Wait for "Restarted application" message
- Try logging in again

### Option 2: Stop and Restart
```bash
# In the terminal, press 'q' to quit
# Then run:
flutter run
```

### Option 3: Check the Screen
The login screen should show:
- A yellow info box at the top saying "Demo Login: demo / demo123"
- Two input fields with hints
- A dark gray "Login" button

## 🎯 What Should Happen

1. **Login Screen** → Enter demo/demo123 → Click Login
2. **Loading** → Shows spinner for ~1 second
3. **Onboarding** → 4 pages about PUUL features
4. **Home Screen** → Shows 4 demo categories (Family, Work, Holiday, Party)

## 🐛 Troubleshooting

**Problem**: Button doesn't respond
- **Solution**: Make sure both fields have text, then try again

**Problem**: Nothing happens after clicking Login
- **Solution**: Check terminal for errors, do hot restart (press R)

**Problem**: App crashes
- **Solution**: Stop app (press q), then run `flutter run` again

**Problem**: Can't see the login screen
- **Solution**: The app might be on a different screen. Restart the app.

## 💡 Alternative Credentials

The demo also accepts ANY non-empty credentials:
- Username: `test` / Password: `test`
- Username: `user` / Password: `pass`
- Username: `anything` / Password: `anything`

## 🎉 Success!

When login works, you'll see:
1. Loading spinner appears
2. Screen transitions to onboarding
3. Beautiful welcome page with PUUL logo
4. Swipeable tutorial pages

---

**Need help?** Check the terminal output for any error messages.
