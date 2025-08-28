# Drag-and-Drop Test Mode

## Overview

The test mode has been completely redesigned to use a modern drag-and-drop interface with grayscale-to-color image reveal animations. This creates a more engaging and interactive learning experience.

## Features

### 🎨 Grayscale-to-Color Image Reveal
- All images start in grayscale using `ColorFilter.matrix` for desaturation
- When the correct article is dropped, the image animates to full color over 500ms
- Creates a satisfying "unlocking" effect that rewards correct answers

### 🖱️ Drag-and-Drop Interface
- **Draggable Chips**: Three pill-shaped chips for "der" (blue), "die" (red), "das" (green)
- **Drop Zone**: Dashed border rectangle that accepts dragged articles
- **Visual Feedback**: Drop zone highlights and scales during drag operations
- **Tap Fallback**: Users can tap chips as an alternative to dragging

### ✨ Animation System
- **Image Scale Animation**: Slight scale effect (1.0 → 1.05 → 1.0) on correct answers
- **Shake Animation**: Elastic shake effect for incorrect answers
- **Chip Bounce**: Chips bounce in when a new question loads
- **Confetti**: Lottie animation plays on correct answers
- **Smooth Transitions**: All animations use proper easing curves

### 🎯 User Experience
- **Haptic Feedback**: Medium impact vibration on drag events
- **Auto-Advance**: Automatically moves to next question after animations
- **Progress Tracking**: Linear progress bar shows quiz completion
- **Error Handling**: Shows correct answer briefly for incorrect responses

## Technical Implementation

### Animation Controllers
```dart
late AnimationController _imageAnimationController;
late AnimationController _shakeAnimationController;
late AnimationController _confettiController;
late AnimationController _chipAnimationController;
```

### State Management
- Tracks current question, selected article, and animation states
- Prevents multiple drops during animations
- Resets image to grayscale for each new question

### Color System
- **der**: Blue (#1976D2)
- **die**: Red (#E53935)  
- **das**: Green (#43A047)

### Grayscale Filter
```dart
const ColorFilter.matrix([
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
])
```

## File Structure

```
lib/features/test/
├── test_screen.dart          # Main drag-and-drop implementation
assets/animations/
└── confetti.json            # Lottie confetti animation
```

## Dependencies

- `flutter_riverpod`: State management
- `lottie`: Animation support
- `easy_localization`: Internationalization
- `go_router`: Navigation

## Usage

1. Navigate to a topic's test mode
2. Drag one of the three article chips (der/die/das) to the drop zone
3. Correct answers reveal the image in color with confetti
4. Incorrect answers show a shake animation and reveal the correct answer
5. Quiz automatically advances to the next question

## Accessibility

- Tap-to-select fallback for users who prefer not to drag
- Haptic feedback for tactile confirmation
- Clear visual states and feedback
- Proper contrast ratios for all colors
