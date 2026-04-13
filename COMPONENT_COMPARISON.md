# Before & After: Component Extraction Examples

## 1. AuthLoadingButton

### Before (Sign In Page)
```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    return FilledButton(
      onPressed: state.isLoading ? null : _handleLogin,
      child: state.isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.onSecondaryContainerColor,
                ),
              ),
            )
          : Text(
              'LOGIN',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.onPrimaryColor,
                letterSpacing: 1.4,
              ),
            ),
    );
  },
);
```

### After (Sign In Page)
```dart
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    return AuthLoadingButton(
      label: 'LOGIN',
      onPressed: _handleLogin,
      isLoading: state.isLoading,
    );
  },
);
```

**Reduction:** 21 lines → 6 lines ✅

---

## 2. BlurredCircleDecoration

### Before (Sign Up Page)
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
)
```

### After (Sign Up Page)
```dart
BlurredCircleDecoration(
  width: 300.w,
  height: 300.h,
  bottom: -200.h,
  right: -80.w,
)
```

**Reduction:** 13 lines → 5 lines ✅

---

## 3. AuthBranding

### Before (Sign Up Page)
```dart
SizedBox(height: 24.h),
Text(
  'MALAZ',
  style: AppTextStyles.titleLarge.copyWith(
    color: AppColors.primaryColor,
    letterSpacing: 4.2,
  ),
),
SizedBox(height: 16.h),
RichText(
  textAlign: TextAlign.center,
  text: TextSpan(
    children: [
      TextSpan(
        text: 'Start your ',
        style: AppTextStyles.headlineLarge.copyWith(
          height: 1.25,
          letterSpacing: -0.80,
          fontWeight: FontWeight.w400,
        ),
      ),
      TextSpan(
        text: 'Journey',
        style: AppTextStyles.headlineLarge,
      ),
    ],
  ),
),
SizedBox(height: 40.h),
```

### After (Sign Up Page)
```dart
AuthBranding(
  headlineFirst: 'Start your ',
  headlineSecond: 'Journey',
),
SizedBox(height: 40.h),
```

**Reduction:** 27 lines → 5 lines ✅

---

## 4. FormContainer

### Before (Sign Up Page)
```dart
Container(
  padding: EdgeInsets.all(24.r),
  decoration: BoxDecoration(
    color: AppColors.surfaceContainerHighColor,
    borderRadius: BorderRadius.circular(28.r),
  ),
  child: Column(
    children: [
      // form fields...
    ],
  ),
)
```

### After (Sign Up Page)
```dart
FormContainer(
  children: [
    // form fields...
  ],
)
```

**Reduction:** 10 lines → 4 lines ✅

---

## 5. AuthNavigationLink

### Before (Sign Up Page)
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'Already have an account? ',
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondaryColor,
      ),
    ),
    TextButton(
      onPressed: context.pop,
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(
        'Login',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ],
)
```

### After (Sign Up Page)
```dart
AuthNavigationLink(
  labelText: 'Already have an account? ',
  linkText: 'Login',
  onLinkPressed: () => context.pop(),
)
```

**Reduction:** 21 lines → 4 lines ✅

---

## 6. ReadOnlyField

### Before (Reset Password Page)
```dart
Container(
  padding: EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 12.h,
  ),
  decoration: BoxDecoration(
    border: Border.all(color: AppColors.borderColor),
    borderRadius: BorderRadius.circular(8.r),
  ),
  child: Row(
    children: [
      Icon(
        Icons.email_outlined,
        color: AppColors.textTertiaryColor,
        size: 18.r,
      ),
      SizedBox(width: 12.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email Address',
              style: AppTextStyles.labelMedium,
            ),
            Text(
              state.user?.email ?? 'No email found',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    ],
  ),
)
```

### After (Reset Password Page)
```dart
ReadOnlyField(
  label: 'Email Address',
  value: state.user?.email ?? 'No email found',
  icon: Icons.email_outlined,
)
```

**Reduction:** 36 lines → 4 lines ✅

---

## 7. ConfirmationView

### Before (Sign Up Page)
```dart
Center(
  child: Padding(
    padding: EdgeInsets.all(32.r),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.mark_email_read_outlined,
          size: 64.r,
          color: AppColors.backgroundColor,
        ),
        SizedBox(height: 24.h),
        Text(
          'Check Your Email',
          style: AppTextStyles.displayLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          'We sent a confirmation link to\n${_emailController.text.trim()}\n\nPlease verify your email to continue.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32.h),
        SizedBox(
          width: double.infinity,
          height: 56.h,
          child: FilledButton(
            onPressed: () => context.pop(),
            child: const Text('Back to Sign In'),
          ),
        ),
      ],
    ),
  ),
)
```

### After (Sign Up Page)
```dart
ConfirmationView(
  icon: Icons.mark_email_read_outlined,
  title: 'Check Your Email',
  description: 'We sent a confirmation link to\n${_emailController.text.trim()}\n\nPlease verify your email to continue.',
  buttonLabel: 'Back to Sign In',
  onButtonPressed: () => context.pop(),
)
```

**Reduction:** 39 lines → 6 lines ✅

---

## 📊 Summary Stats

| Component | Before Lines | After Lines | Reduction |
|-----------|--------------|-------------|-----------|
| AuthLoadingButton | 21 | 6 | 71% |
| BlurredCircleDecoration | 13 | 5 | 62% |
| AuthBranding | 27 | 5 | 81% |
| FormContainer | 10 | 4 | 60% |
| AuthNavigationLink | 21 | 4 | 81% |
| ReadOnlyField | 36 | 4 | 89% |
| ConfirmationView | 39 | 6 | 85% |
| **TOTAL** | **167** | **34** | **80%** |

---

## 🎯 Key Takeaways

1. **Massive Code Reduction** - 80% fewer lines for these patterns
2. **Consistency** - Same implementation across all pages
3. **Maintainability** - Update the component once, everywhere gets updated
4. **Testability** - Each component can be tested independently
5. **Reusability** - Can now be used in future features
6. **Readability** - Pages are now much cleaner and easier to understand

---

## 🚀 These Components Are Ready for:

- Other auth-related features
- Form-heavy pages
- Dashboard/settings pages
- Any page needing loading states
- Confirmation dialogs/screens
- Decorative elements in other features

