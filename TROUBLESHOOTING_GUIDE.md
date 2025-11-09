# Troubleshooting Guide - Project Setup After Zip Extraction

## ✅ Issues Resolved

### 1. **Dependencies Reinstalled**
- ✅ Ran `flutter clean` to remove corrupted build artifacts
- ✅ Ran `flutter pub get` to reinstall all dependencies
- ✅ All packages downloaded successfully

### 2. **Code Analysis**
- ✅ No compilation errors
- ✅ No linter warnings
- ✅ All imports resolved correctly

### 3. **Build Verification**
- ✅ Web build completed successfully
- ✅ All assets compiled correctly

---

## 🚀 How to Run the Project

### Step 1: Verify Flutter Installation
```bash
flutter doctor
```
Make sure Flutter is properly installed and Chrome is available.

### Step 2: Install Dependencies (if needed)
```bash
flutter pub get
```

### Step 3: Run the Application
```bash
flutter run -d chrome
```

Or for release mode:
```bash
flutter run -d chrome --release
```

---

## 🔧 Common Issues After Zip Extraction

### Issue 1: "Package not found" or "Import errors"

**Solution:**
```bash
flutter clean
flutter pub get
```

### Issue 2: "Build failed" or "Compilation errors"

**Solution:**
```bash
flutter clean
flutter pub get
flutter analyze
```

### Issue 3: "Missing dependencies"

**Solution:**
```bash
flutter pub upgrade
flutter pub get
```

### Issue 4: "Database connection errors"

**Check:**
1. Open `lib/config/database_config.dart`
2. Verify Supabase URL and key are correct
3. Make sure Supabase project is active
4. Check internet connection

### Issue 5: "App not loading in browser"

**Solution:**
1. Clear browser cache
2. Try incognito/private mode
3. Check browser console (F12) for errors
4. Verify Flutter web is enabled:
   ```bash
   flutter config --enable-web
   ```

---

## 📋 Pre-Run Checklist

Before running the project, ensure:

- [ ] Flutter SDK is installed and in PATH
- [ ] Chrome browser is installed
- [ ] Internet connection is available (for Supabase)
- [ ] Supabase credentials are configured in `lib/config/database_config.dart`
- [ ] Database schema is created in Supabase (run `database/supabase_schema.sql`)
- [ ] Test users are created in Supabase database

---

## 🗄️ Database Setup

### If Database is Not Set Up:

1. **Create Supabase Project:**
   - Go to https://supabase.com
   - Create a new project
   - Get Project URL and anon key

2. **Update Configuration:**
   - Open `lib/config/database_config.dart`
   - Replace `supabaseUrl` and `supabaseAnonKey`

3. **Create Database Schema:**
   - Open Supabase SQL Editor
   - Run the SQL from `database/supabase_schema.sql`

4. **Create Test Users:**
   - Use Supabase Table Editor or SQL Editor
   - Create at least one authority user and one teacher user
   - See `SUPABASE_SETUP_GUIDE.md` for details

---

## 🔍 Verification Steps

### 1. Check Project Structure
```
lib/
├── config/
│   └── database_config.dart          ✅
├── models/
│   ├── user_model.dart               ✅
│   ├── grocery_usage_model.dart      ✅
│   └── report_model.dart             ✅
├── providers/
│   └── app_provider.dart             ✅
├── screens/
│   ├── login_screen.dart             ✅
│   ├── teacher_dashboard.dart        ✅
│   └── authority_dashboard.dart      ✅
├── services/
│   ├── auth_service.dart             ✅
│   └── supabase_service.dart         ✅
└── main.dart                         ✅
```

### 2. Verify Dependencies
```bash
flutter pub get
```
Should show: "Got dependencies!"

### 3. Check for Errors
```bash
flutter analyze
```
Should show: "No issues found!"

### 4. Test Build
```bash
flutter build web
```
Should complete successfully.

---

## 🐛 Debugging Tips

### Enable Verbose Logging
```bash
flutter run -d chrome -v
```

### Check Browser Console
1. Open browser (F12)
2. Go to Console tab
3. Look for errors or warnings

### Check Flutter Logs
```bash
flutter logs
```

### Clear Flutter Cache
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

---

## 📱 Running on Different Platforms

### Web (Chrome)
```bash
flutter run -d chrome
```

### Web (Edge)
```bash
flutter run -d edge
```

### Web (Firefox)
```bash
flutter run -d web-server
```
Then open http://localhost:port in Firefox

---

## ⚠️ Important Notes

1. **Supabase Connection:**
   - The app requires internet connection
   - Supabase project must be active
   - Database schema must be created

2. **Browser Compatibility:**
   - Chrome (recommended)
   - Edge
   - Firefox
   - Safari (may have limitations)

3. **Development vs Production:**
   - Development: `flutter run -d chrome`
   - Production: `flutter build web --release`

4. **Hot Reload:**
   - Press `r` in terminal to hot reload
   - Press `R` to hot restart
   - Press `q` to quit

---

## 📞 Still Having Issues?

### Check These Files:
1. `pubspec.yaml` - Dependencies are correct
2. `lib/config/database_config.dart` - Supabase credentials
3. `lib/main.dart` - Entry point is correct
4. `web/index.html` - Web configuration

### Common Solutions:
1. **Restart IDE/Editor**
2. **Restart Terminal**
3. **Delete `.dart_tool` folder and run `flutter pub get`**
4. **Update Flutter:** `flutter upgrade`
5. **Check Flutter version:** `flutter --version`

---

## ✅ Success Indicators

Your project is working correctly if:
- ✅ `flutter analyze` shows no errors
- ✅ `flutter pub get` completes successfully
- ✅ `flutter build web` completes without errors
- ✅ App loads in browser without errors
- ✅ Login screen appears
- ✅ Can navigate to dashboards (after login)

---

## 🎯 Quick Fix Commands

If nothing works, try this sequence:

```bash
# 1. Clean everything
flutter clean

# 2. Remove pub cache (optional, if issues persist)
flutter pub cache repair

# 3. Get dependencies
flutter pub get

# 4. Analyze code
flutter analyze

# 5. Build for web
flutter build web

# 6. Run the app
flutter run -d chrome
```

---

**Last Updated:** After zip extraction troubleshooting
**Status:** ✅ All issues resolved, project ready to run


