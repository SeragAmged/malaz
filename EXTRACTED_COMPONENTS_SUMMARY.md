# Extracted Reusable Components from Auth Screens

## Overview
This document lists all reusable components that have been extracted (or should be extracted) from the auth screens. These components promote code reuse, maintainability, and consistency across the app.

---

## ✅ Already Extracted Components

### 1. **AuthTextField** 
**Location:** `lib/features/auth/presentation/widgets/auth_text_field.dart`

**Purpose:** Reusable text input field with built-in validation, password toggle, and consistent styling.

**Features:**
- Label with custom styling
- Optional hint text
- Icon support (prefix)
- Password visibility toggle
- Built-in form validation
- Customizable keyboard type and text input action

**Used in:** SignUpPage, SignInPage, ForgotPasswordPage, ResetPasswordPage

**Props:**
```dart
required String label
String? hintText
TextEditingController? controller
bool obscureText = false
TextInputType keyboardType = TextInputType.text
IconData? prefixIcon
String? Function(String?)? validator
void Function(String)? onChanged
TextInputAction? textInputAction
```

---

### 2. **AuthHeader**
**Location:** `lib/features/auth/presentation/widgets/auth_header.dart`

**Purpose:** Consistent header component for auth screens with icon, title, and subtitle.

**Features:**
- Icon with circular background
- Large title text
- Secondary subtitle text
- Centered alignment
- Responsive padding

**Used in:** ForgotPasswordPage, ResetPasswordPage

**Props:**
```dart
required Widget icon
required String title
required String subtitle
```

---

### 3. **AvatarSelector**
**Location:** `lib/features/auth/presentation/widgets/avatar_selector.dart`

**Purpose:** Grid-based avatar selection with visual feedback.

**Features:**
- 3-column grid layout
- Network image caching
- Selection state visualization
- Circular avatar design with selection highlight
- Loading and error states

**Used in:** SignUpPage

**Props:**
```dart
required int selectedAvatarIndex
required ValueChanged<int> onAvatarSelected
required List<String> avatarUrls
```

---

### 4. **InfoBox**
**Location:** `lib/features/auth/presentation/widgets/info_box.dart`

**Purpose:** Informational box displaying a list of items with icon and title.

**Features:**
- Icon and title header
- Numbered list items
- Custom styling and borders
- Flexible content layout

**Used in:** ForgotPasswordPage, ResetPasswordPage

**Props:**
```dart
required IconData icon
required String title
required List<String> items
```

---

## 🎯 Components to Extract

### 1. **AuthLoadingButton** (NEW)
**Current Location:** Inline in SignUpPage (lines 228-261) and SignInPage (lines 168-198)

**Purpose:** Reusable button that shows loading indicator while action is in progress.

**Current Pattern:**
```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    return FilledButton(
      onPressed: state.isLoading ? null : _handleSignUp,
      child: state.isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.w,
              child: CircularProgressIndicator(...)
            )
          : Text('SIGN UP', style: ...)
    );
  },
);
```

**Extracted Component Props:**
```dart
required String label
required VoidCallback onPressed
bool isLoading = false
TextStyle? textStyle
```

---

### 2. **BlurredCircleDecoration** (NEW)
**Current Location:** Inline in SignUpPage (lines 96-111) and SignInPage (lines 67-82)

**Purpose:** Reusable decorative blurred circle background element.

**Current Pattern:**
```dart
Positioned(
  bottom: -200.h,
  right: -80.w,
  child: ImageFiltered(
    imageFilter: ImageFilter.blur(sigmaX: 60.w, sigmaY: 60.h),
    child: Container(
      width: 300.w,
      height: 300.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor.withValues(alpha: 0.3),
      ),
    ),
  ),
);
```

**Extracted Component Props:**
```dart
required double width
required double height
required Offset position // {dx, dy}
double? blurSigma = 60.0
Color? color = AppColors.primaryColor
double? colorAlpha = 0.3
```

---

### 3. **AuthBranding** (NEW)
**Current Location:** Inline in SignUpPage (lines 128-155) and SignInPage (lines 96-123)

**Purpose:** Consistent app branding section with logo and headline.

**Current Pattern:**
```dart
Text('MALAZ', style: AppTextStyles.titleLarge.copyWith(...)
RichText(
  text: TextSpan(
    children: [
      TextSpan(text: 'Start your ', ...),
      TextSpan(text: 'Journey', ...),
    ],
  ),
);
```

**Extracted Component Props:**
```dart
String appName = 'MALAZ'
String headlineFirst // "Start your"
String headlineSecond // "Journey"
TextStyle? appNameStyle
TextStyle? headlineStyle
```

---

### 4. **FormContainer** (NEW)
**Current Location:** Inline in SignUpPage (lines 157-294) and SignInPage (lines 126-228)

**Purpose:** Consistent container for form content with styling.

**Current Pattern:**
```dart
Container(
  padding: EdgeInsets.all(24.r),
  decoration: BoxDecoration(
    color: AppColors.surfaceContainerHighColor,
    borderRadius: BorderRadius.circular(28.r),
  ),
  child: Column(...)
)
```

**Extracted Component Props:**
```dart
required List<Widget> children
double padding = 24.0
double borderRadius = 28.0
Color? backgroundColor
```

---

### 5. **AuthNavigationLink** (NEW)
**Current Location:** Inline in SignUpPage (lines 263-291) and SignInPage (lines 200-225)

**Purpose:** Consistent navigation link for auth screen transitions.

**Current Pattern:**
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text('Already have an account? ', ...),
    TextButton(
      onPressed: context.pop,
      child: Text('Login', ...),
    ),
  ],
);
```

**Extracted Component Props:**
```dart
required String labelText // "Already have an account? "
required String linkText // "Login"
required VoidCallback onLinkPressed
TextStyle? labelStyle
TextStyle? linkStyle
```

---

### 6. **ReadOnlyField** (NEW)
**Current Location:** Inline in ResetPasswordPage (lines 95-129)

**Purpose:** Display read-only information (like email) with icon and formatting.

**Current Pattern:**
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
  decoration: BoxDecoration(
    border: Border.all(color: AppColors.borderColor),
    borderRadius: BorderRadius.circular(8.r),
  ),
  child: Row(
    children: [
      Icon(...),
      Expanded(
        child: Column(
          children: [Text(label), Text(value)],
        ),
      ),
    ],
  ),
)
```

**Extracted Component Props:**
```dart
required String label
required String value
required IconData icon
Color? borderColor
Color? backgroundColor
```

---

### 7. **ConfirmationView** (NEW)
**Current Location:** Inline in SignUpPage (lines 308-347)

**Purpose:** Success confirmation screen after signup/password reset.

**Current Pattern:**
```dart
Center(
  child: Padding(
    padding: EdgeInsets.all(32.r),
    child: Column(
      children: [
        Icon(...),
        Text('Check Your Email', ...),
        Text('We sent a confirmation...', ...),
        FilledButton(...),
      ],
    ),
  ),
)
```

**Extracted Component Props:**
```dart
required IconData icon
required String title
required String description
required String buttonLabel
required VoidCallback onButtonPressed
double iconSize = 64.0
```

---

## Summary Table

| Component | Status | Location | Frequency |
|-----------|--------|----------|-----------|
| AuthTextField | ✅ Extracted | widgets/ | 10+ uses |
| AuthHeader | ✅ Extracted | widgets/ | 2 uses |
| AvatarSelector | ✅ Extracted | widgets/ | 1 use |
| InfoBox | ✅ Extracted | widgets/ | 2 uses |
| AuthLoadingButton | ❌ New | widgets/ | 3+ uses |
| BlurredCircleDecoration | ❌ New | widgets/ | 2 uses |
| AuthBranding | ❌ New | widgets/ | 2 uses |
| FormContainer | ❌ New | widgets/ | 2 uses |
| AuthNavigationLink | ❌ New | widgets/ | 2 uses |
| ReadOnlyField | ❌ New | widgets/ | 1 use |
| ConfirmationView | ❌ New | widgets/ | 1 use |

---

## Benefits of Extraction

✅ **Consistency** - All auth screens follow same visual patterns  
✅ **Maintainability** - Update once, applies everywhere  
✅ **Reusability** - Easy to use in new features  
✅ **Testing** - Components can be tested independently  
✅ **Code reduction** - Eliminates duplicated patterns  
✅ **Easier refactoring** - Changes propagate automatically  

---

## Implementation Priority

**Phase 1 (High Impact):**
1. AuthLoadingButton - Used in 3+ places
2. BlurredCircleDecoration - Used in 2 places
3. AuthBranding - Used in 2 places

**Phase 2 (Medium Impact):**
4. FormContainer - Used in 2 places
5. AuthNavigationLink - Used in 2 places

**Phase 3 (Lower Impact):**
6. ReadOnlyField - Used in 1 place
7. ConfirmationView - Used in 1 place

