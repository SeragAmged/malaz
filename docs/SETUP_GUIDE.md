# Malaz Setup Guide

## Prerequisites

- Flutter SDK >=3.10.4
- Dart SDK >=3.10.4
- A Supabase project
- Android Studio or VS Code with Flutter extension

## Initial Setup

### 1. Clone and Install Dependencies

```bash
flutter pub get
```

### 2. Supabase Configuration

#### Create a Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Create a new project
3. Note your **Project URL** and **Anon Key**

#### Initialize Supabase in Flutter

Update `lib/main.dart` or your app initialization to include:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_ANON_KEY',
  );
  
  runApp(const MalazApp());
}
```

### 3. Database Setup

Create the `users` table in Supabase SQL Editor:

```sql
-- Create users table
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT NOT NULL,
  display_name TEXT,
  avatar TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy: Users can read their own data
CREATE POLICY "Users can read own data" ON users
  FOR SELECT USING (auth.uid() = id);

-- Policy: Users can update their own data
CREATE POLICY "Users can update own data" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Policy: Users can insert their own data
CREATE POLICY "Users can insert own data" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);
```

### 4. Storage Setup for Avatars

1. Go to **Storage** in Supabase dashboard
2. Create a new bucket called `avatars`
3. Make it **public** (for direct URL access)
4. Upload your avatar images:
   - `turtle_1010048.png`
   - `macaw_1010020.png`
   - `monkey_1010046.png`
   - `parrot_1010039.png`
   - `pirate_1010047.png`
   - `pirate_1010016.png`

#### Enable Public Access Policy

```sql
-- Allow public read access to avatars
CREATE POLICY "Public read access" ON storage.objects
  FOR SELECT USING (bucket_id = 'avatars');
```

### 5. Enable Email Auth

1. Go to **Authentication** in Supabase dashboard
2. Navigate to **Providers**
3. Ensure **Email** is enabled
4. Configure email templates if desired

## Project Structure

```
malaz/
├── lib/
│   ├── main.dart              # Entry point with Supabase init
│   ├── app.dart               # Main MaterialApp
│   ├── core/
│   │   ├── theme/             # Design system (colors, typography)
│   │   ├── errors/            # Domain error types
│   │   └── result.dart        # Result type for error handling
│   └── features/
│       ├── auth/              # Authentication feature
│       │   ├── data/          # Repositories & datasources
│       │   ├── domain/        # Entities & interfaces
│       │   └── presentation/  # UI (Cubit, Pages, Widgets)
│       └── rooms/             # Room management feature
├── pubspec.yaml
├── DESIGN_SYSTEM.md           # Design documentation
└── SETUP_GUIDE.md             # This file
```

## Key Features

### Authentication Flow

1. **Sign Up**
   - User enters email and password
   - Selects an avatar from the grid
   - Account created in Supabase Auth
   - User profile saved in database
   - User logged in automatically

2. **Login**
   - User enters email and password
   - Authenticated via Supabase
   - User data fetched from database
   - Session maintained

3. **Auto-Login**
   - App checks if user is already authenticated
   - Restores session from local storage
   - Navigates to rooms if authenticated

### Design System

All UI elements use centralized design tokens:
- **Colors**: `lib/core/theme/app_colors.dart`
- **Typography**: `lib/core/theme/app_typography.dart`
- **Theme**: `lib/core/theme/app_theme.dart`

This ensures consistency across the app and makes theme changes simple.

### State Management

Using `flutter_bloc`:
- **AuthCubit** manages authentication state
- Automatic UI updates based on state changes
- Clean separation of logic and UI

## Running the App

### Development

```bash
flutter run
```

### Build APK (Android)

```bash
flutter build apk --release
```

### Build iOS

```bash
flutter build ios --release
```

## Environment Variables

Create a `.env` file (optional, if using flutter_dotenv):

```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

## Testing

### Test Email Auth

1. Run the app
2. Go to **Sign Up**
3. Enter test email: `test@example.com`
4. Enter password: `password123`
5. Select an avatar
6. Click Sign Up
7. Check Supabase **Auth** tab to verify user created
8. Check **users** table to verify profile created

### Test Login

1. Go back to **Login** (or restart app)
2. Enter your test email and password
3. Should navigate to **Rooms** page

## Common Issues

### "Supabase not initialized"
- Make sure `Supabase.initialize()` is called before `runApp()`
- Check that URL and anon key are correct

### Avatar images not loading
- Verify avatars are in `avatars` bucket in Supabase Storage
- Check bucket is set to **public**
- Verify avatar filenames match exactly in code

### Auth fails silently
- Check Supabase Auth providers are enabled
- Verify email auth is active
- Check user password meets minimum requirements (6 chars)

### RLS policy errors
- Ensure RLS policies are correctly configured
- Check that authenticated user ID matches in table

## Next Steps

1. **Implement forgot password** - Add password reset flow
2. **Add profile management** - Allow users to update info
3. **Implement room management** - Complete the rooms feature
4. **Add animations** - Enhance UI with transitions
5. **Error handling** - Improve error messages
6. **Logging** - Add analytics/logging

## Resources

- [Supabase Docs](https://supabase.com/docs)
- [Supabase Flutter SDK](https://supabase.com/docs/reference/flutter/introduction)
- [Material 3 Design](https://m3.material.io)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
