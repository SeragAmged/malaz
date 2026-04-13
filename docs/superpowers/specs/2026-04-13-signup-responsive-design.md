---
name: Make signup page responsive
description: Apply flutter_screenutil responsive units and AppTextStyles consistently to the signup page
type: design
---

# Signup Page Responsive Design

## Overview
Make the signup page responsive to different portrait phone screen sizes by:
1. Applying flutter_screenutil responsive units (`.r`, `.h`, `.w`) to all hardcoded pixel values
2. Using `AppTextStyles` exclusively for text styling instead of inline modifications

## Scope: Portrait phones only

Different phone sizes should maintain visual proportions and readability through responsive scaling.

## Current Issues

- **Hardcoded padding**: `const EdgeInsets.symmetric(horizontal: 24, vertical: 32)` and `const EdgeInsets.all(32)`
- **Hardcoded spacing**: `const SizedBox(height: 24)`, `const SizedBox(height: 40)`, etc.
- **Inconsistent responsive usage**: Confirmation view uses `.r`, `.h` but main form doesn't
- **AvatarSelector**: Uses hardcoded `const EdgeInsets.only(left: 4, bottom: 16)` and `const EdgeInsets.all(8)`
- **Text styling**: Some `.copyWith()` modifications on AppTextStyles that should be simplified

## Changes

### 1. SignUpPage main form
- SafeArea padding: `24` → `24.w` (horizontal), `32` → `32.h` (vertical)
- Form container padding: `32` → `32.r`
- Spacing between sections: `24` → `24.h`, `40` → `40.h`, `32` → `32.h`, `16` → `16.h`, `12` → `12.h`
- Text styling: Keep AppTextStyles, minimize `.copyWith()` modifications

### 2. AvatarSelector widget
- Label padding: `4` → `4.w`, `16` → `16.h`
- Inner padding: `8` → `8.r`
- Grid spacing: Keep responsive but verify alignment

### 3. Confirmation view
- Already uses `.r`, `.h`, `.w` — ensure consistency maintained

### 4. Text sizes
- Use existing AppTextStyles consistently
- Remove unnecessary `.copyWith()` calls where possible

## Implementation Order

1. Update SignUpPage padding and spacing with responsive units
2. Update AvatarSelector hardcoded values
3. Review text styling and AppTextStyles usage
4. Test on various portrait screen sizes

## Definition of Done

- All hardcoded pixel values replaced with responsive units
- Text styling uses AppTextStyles exclusively
- Page scales smoothly across portrait phone sizes
- No hardcoded `const EdgeInsets` with pixel values
