# Malaz Design System

## Overview

The Malaz app implements a comprehensive Material 3 design system with a dark theme and teal accent color. The design system is built on the Figma mockups for the authentication flow and extended to cover the entire application.

## Design Principles

### Material 3 Compliance
- ✅ Dark theme optimized for accessibility and modern aesthetics
- ✅ Semantic color tokens for consistent branding
- ✅ Typography scale following Material 3 guidelines
- ✅ Rounded corners (28px for cards, 12px for inputs, 9999px for buttons)
- ✅ Proper elevation and shadow usage
- ✅ Accessible color contrast ratios

### Color System

#### Primary Colors
- **Primary**: `#66D9CC` (Teal accent - brand color)
- **On Primary**: `#003732` (Dark text on teal)
- **Primary Container**: `#004F4A` (Teal shade for secondary uses)
- **On Primary Container**: `#8FEEE5` (Light text on container)

#### Surface Colors
- **Background**: `#0A0F0F` (Deep dark)
- **Surface**: `#262B2B` (Card/modal background)
- **Surface Container High**: `#262B2B` (Elevated surfaces)
- **Surface Container**: `#1A1E1E` (Lower elevation)
- **Surface Dim**: `#0A0F0F` (Lowest elevation)
- **Surface Bright**: `#2C3130` (Brightest surface)

#### Text Colors
- **Primary Text**: `#DFE3E2` (Main text)
- **Secondary Text**: `#BDC9C8` (Labels, hints)
- **Tertiary Text**: `#879392` (Muted text)

#### Input Colors
- **Input Background**: `#313635` (Input field fill)
- **Input Hint**: `#879392` (Placeholder text)
- **Border**: `#3F4443` (Input borders)

### Typography

#### Font Families
- **Display/Headlines**: Space Grotesk (600-700 weight for emphasis)
- **Body/Labels**: Manrope (400-600 weight)

#### Type Scale
| Role | Size | Weight | Line Height | Letter Spacing |
|------|------|--------|-------------|-----------------|
| Display Large | 57px | 400 | 1.12 | -0.25 |
| Headline Large | 32px | 700 | 1.25 | -0.8 |
| Title Large | 22px | 500 | 1.27 | 0 |
| Body Large | 16px | 400 | 1.5 | 0.15 |
| Body Medium | 14px | 400 | 1.43 | 0.25 |
| Label Medium | 12px | 600 | 1.33 | 0.5 |

### Components

#### Buttons
- **Filled Button (Primary)**: Teal background, dark text, 48px height, 9999px border radius
- **Text Button**: Teal text, no background
- **Outlined Button**: Teal border, transparent background

#### Input Fields
- **Text Input**: 12px border radius, 313635 background, teal focus border (2px)
- **Label**: Above input, 12px size, secondary text color
- **Prefix Icon**: Email/lock icons for context

#### Cards
- **Surface Container**: 28px border radius, elevation 0
- **Padding**: 24-32px inner spacing
- **Shadow**: Optional elevation shadow

#### Avatar Selector
- **Size**: 56px diameter
- **Border**: 2px teal border when selected
- **Background**: Input color with 0.2 alpha overlay when selected
- **Grid**: 3 columns, 16px spacing

### Design Tokens

All colors and typography are centralized in:
- `lib/core/theme/app_colors.dart` - Color constants
- `lib/core/theme/app_typography.dart` - Typography definitions
- `lib/core/theme/app_theme.dart` - Theme configuration

### Responsive Design

The app uses Flutter's responsive capabilities:
- Single-column layout optimized for mobile (390px standard)
- SafeArea for notch/status bar handling
- Column/Row with flex for flexible layouts
- MediaQuery for responsive breakpoints (future enhancement)

### Accessibility Features

- Proper contrast ratios (WCAG AA compliant)
- Icon + text combinations for clarity
- Form validation with error messages
- Clear visual feedback for interactive elements
- Focus states for keyboard navigation

## Implementation Details

### Authentication Flow

#### Login Screen
- Email and password inputs with icons
- "Forgot password?" link (placeholder)
- Teal "Login" button
- "Don't have an account? Sign Up" link
- Decorative gradient overlay

#### Sign Up Screen
- Email, password, confirm password inputs
- Avatar selection (6 animal avatars from Supabase storage)
- Teal "Sign Up" button
- "Already have an account? Login" link
- Avatar images loaded from Supabase `avatars` bucket

### State Management

Using **flutter_bloc** with:
- `AuthCubit` - Manages auth state (loading, authenticated, unauthenticated, error)
- `AuthState` - Sealed class with state variants
- Automatic routing based on auth state

### Data Flow

```
UI (LoginPage/SignUpPage)
  ↓
AuthCubit (state management)
  ↓
AuthRepository (use case layer)
  ↓
AuthRemoteDataSourceImpl (Supabase)
  ↓
Supabase Auth + Database
```

### Supabase Integration

#### Authentication
- Email/password sign up and sign in
- Supabase Auth built-in user management
- Session token storage (automatically handled)

#### Avatar Storage
- Avatars stored in `avatars` bucket in Supabase Storage
- Public URLs generated for cached network image loading
- Avatar IDs stored in user profile in database

#### Database Schema
Users table:
```sql
id (UUID)
email (text)
display_name (text, nullable)
avatar (text, nullable) -- avatar filename
created_at (timestamp)
```

## Design Inconsistencies Fixed

### Material 3 Compliance Issues Addressed
1. **Button Radius**: Changed from Material 2 default to 9999px (fully rounded) for modern Material 3 look
2. **Input Fields**: Updated to 12px radius with proper focus state borders (2px teal)
3. **Card Elevation**: Set to 0 with manual shadow definition for consistent look
4. **Color System**: Implemented full Material 3 semantic color naming (surfaceContainerHighest, etc.)
5. **Typography**: Aligned letter spacing and weights with Material 3 spec
6. **Focus States**: Added teal focus border for inputs (2px width per M3 spec)

## Future Enhancements

1. Add dark/light mode toggle (design tokens ready)
2. Implement forgot password flow
3. Add form field validation animations
4. Implement gradient animations on auth screens
5. Add haptic feedback to buttons
6. Implement biometric authentication
7. Add animation transitions between screens

## File Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_theme.dart
│   ├── errors/
│   │   └── domain_errors.dart
│   └── result.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_remote_datasource_impl.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── auth_cubit.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── signup_page.dart
│   │       └── widgets/
│   │           ├── auth_text_field.dart
│   │           └── avatar_selector.dart
│   └── rooms/ ...
└── app.dart
```

## Usage Guide

### Accessing Colors
```dart
import 'core/theme/app_colors.dart';

Color tealPrimary = AppColors.primaryColor;
Color darkBg = AppColors.backgroundColor;
```

### Accessing Typography
```dart
import 'core/theme/app_typography.dart';

TextStyle heading = AppTypography.headlineLarge;
TextStyle body = AppTypography.bodyMedium;
```

### Using Theme in Widgets
```dart
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

### Building Custom Components
Reference the existing buttons and inputs in:
- `lib/features/auth/presentation/widgets/auth_text_field.dart`
- `lib/features/auth/presentation/widgets/avatar_selector.dart`
