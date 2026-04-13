# Malaz - Flutter Authentication with Material 3 Design

A modern Flutter app featuring a complete authentication system implemented with Material 3 design language, Supabase backend, and clean architecture.

## ✨ Features

### Authentication
- ✅ Email/password sign up and login
- ✅ Password validation and matching
- ✅ Avatar selection during sign up (6 avatar options)
- ✅ Automatic session management
- ✅ Secure token storage (via Supabase)

### Design System
- ✅ Material 3 dark theme
- ✅ Teal accent color (#66D9CC)
- ✅ Centralized design tokens
- ✅ Consistent typography scale
- ✅ Material 3 compliance fixes
- ✅ Proper elevation and shadows
- ✅ Accessible color contrast

### Architecture
- ✅ Clean architecture (Domain/Data/Presentation)
- ✅ BLoC state management
- ✅ Repository pattern
- ✅ Result type for error handling
- ✅ Dependency injection
- ✅ Clear separation of concerns

### Backend
- ✅ Supabase authentication
- ✅ Supabase database (user profiles)
- ✅ Supabase storage (avatar images)
- ✅ RLS (Row Level Security) policies
- ✅ Secure data access

## 📁 Project Structure

```
lib/
├── core/                               # Core application layer
│   ├── errors/
│   │   └── domain_errors.dart         # Domain error types
│   ├── theme/
│   │   ├── app_colors.dart            # Color tokens
│   │   ├── app_typography.dart        # Typography scale
│   │   └── app_theme.dart             # Theme configuration
│   └── result.dart                    # Result type for FP
├── features/
│   ├── auth/                          # Authentication feature
│   │   ├── data/                      # Data layer
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/                    # Domain layer
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── presentation/              # UI layer
│   │       ├── cubit/
│   │       ├── pages/
│   │       └── widgets/
│   └── rooms/                         # Room management feature
├── app.dart                           # Main app widget
└── main.dart                          # Entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.10.4
- Dart SDK ≥ 3.10.4
- Supabase project

### Installation

1. **Clone and setup**
```bash
cd malaz
flutter pub get
```

2. **Configure Supabase**
   - Create account at [supabase.com](https://supabase.com)
   - Create new project
   - Copy Project URL and Anon Key
   - Update `lib/main.dart` with your credentials

3. **Setup database**
   - Follow instructions in `SETUP_GUIDE.md`
   - Create users table with RLS policies
   - Create avatars storage bucket

4. **Run the app**
```bash
flutter run
```

## 📚 Documentation

- **[DESIGN_SYSTEM.md](DESIGN_SYSTEM.md)** - Design tokens, components, and Material 3 compliance
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed Supabase configuration
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Technical implementation details

## 🎨 Design System

### Colors
- **Primary**: Teal (#66D9CC)
- **Background**: Deep dark (#0A0F0F)
- **Surface**: Dark gray (#262B2B)
- **Text**: Light gray (#DFE3E2)

### Typography
- **Display**: Space Grotesk (bold)
- **Body**: Manrope (regular)
- Material 3 type scale included

### Components
- **Buttons**: Filled, text, and outlined variants
- **Input Fields**: With validation and icons
- **Avatar Selector**: Grid with visual feedback
- **Cards**: Elevated surfaces with shadows

## 🔐 Authentication Flow

### Login Screen
1. User enters email and password
2. System validates inputs
3. Authenticates via Supabase
4. Navigates to home on success
5. Shows error on failure

### Sign Up Screen
1. User enters email, password, confirm password
2. Selects avatar from 6 options
3. Validates password match
4. Creates account in Supabase Auth
5. Creates user profile in database
6. Automatically logs in user

### Auto-Login
1. App checks if user is authenticated
2. Restores session from device storage
3. Navigates to home if authenticated
4. Shows login page if not

## 📦 Dependencies

```yaml
flutter_bloc: ^9.1.1           # State management
supabase_flutter: ^2.10.0      # Backend
cached_network_image: ^3.3.1   # Image caching
```

## 🏗️ Architecture Overview

### Clean Architecture Layers

**Domain Layer** (Business Logic)
- User entity
- Repository interface
- Domain errors

**Data Layer** (External Data)
- Supabase datasource implementation
- User model (serialization)
- Repository implementation

**Presentation Layer** (UI)
- AuthCubit (state management)
- LoginPage, SignUpPage (screens)
- Custom widgets (input field, avatar selector)

### State Management with BLoC

```
User Input → AuthCubit → AuthRepository → Supabase
                ↓
             AuthState
                ↓
          UI Updates
```

## 🎯 Key Features Explained

### Material 3 Compliance
- ✅ Dark theme with semantic colors
- ✅ Proper typography scale
- ✅ Rounded buttons (9999px radius)
- ✅ Focus state indicators (2px borders)
- ✅ Elevation and shadows per spec
- ✅ Accessible color contrast (WCAG AA)

### Avatar Management
- 6 animal avatar options
- Stored in Supabase Storage
- Cached network image loading
- Visual selection feedback
- User profile integration

### Error Handling
- Semantic domain errors
- User-friendly error messages
- Proper error propagation
- Result type for type-safe errors

## 🧪 Testing

### Manual Testing
1. Run app: `flutter run`
2. Test sign up with new email
3. Select an avatar
4. Check Supabase database for user creation
5. Test login with same credentials
6. Test app restart (auto-login)
7. Test logout

### Unit Testing (Future)
```bash
flutter test
```

## 🔧 Configuration

### Supabase Setup

**Update `main.dart`:**
```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_ANON_KEY',
);
```

**Database Setup:**
See `SETUP_GUIDE.md` for SQL commands

**Storage Setup:**
1. Create `avatars` bucket
2. Upload 6 avatar images
3. Set bucket to public

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ⏳ Web (future)
- ⏳ Desktop (future)

## 🚧 Known Limitations

- Forgot password feature not yet implemented
- Profile editing not yet implemented
- No social authentication yet
- No biometric auth yet

## 🔮 Future Enhancements

1. **Account Management**
   - Edit profile
   - Change password
   - Change avatar
   - Delete account

2. **Advanced Auth**
   - Forgot password flow
   - Email verification
   - Two-factor authentication
   - Social login (Google, GitHub, Apple)
   - Biometric authentication

3. **UI/UX**
   - Screen transition animations
   - Loading state animations
   - Success/error feedback animations
   - Dark/light mode toggle

4. **Performance**
   - Image optimization
   - Lazy loading
   - Caching strategy
   - Bundle size optimization

5. **Analytics & Logging**
   - User behavior tracking
   - Error logging
   - Performance monitoring

## 📝 License

This project is part of the Malaz Task Management application.

## 👥 Contributing

When adding new features:
1. Follow clean architecture principles
2. Use Material 3 design system
3. Add proper error handling
4. Include documentation
5. Test thoroughly

## 🤝 Support

For issues or questions:
1. Check `DESIGN_SYSTEM.md` for design questions
2. Check `SETUP_GUIDE.md` for configuration issues
3. Check `IMPLEMENTATION_SUMMARY.md` for technical details
4. Review code comments in source files

---

**Last Updated:** April 2026  
**Version:** 1.0.0  
**Status:** ✅ Ready for Development
