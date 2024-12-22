# Pressable

A highly customizable Flutter widget that provides beautiful press animations and effects for any child widget. Perfect for creating interactive UI elements with minimal effort.


## Features

- 🎯 Shrink animation on press
- 💫 Material-style ripple effects
- 🎨 Custom background/foreground color transitions
- ⚡ Configurable animation durations
- 🔒 Disabled state handling
- 🎭 Multiple effect types (Shrink, Ripple, Combined)

## Demo
<p float="left">
  <img src="https://i.imgur.com/gZTpzZq.gif" width="45%">
  <img src="https://i.imgur.com/eHZ2YLi.gif" width="45%">
</p>
<p float="left">
  <img src="https://i.imgur.com/GC2W9Qr.gif" width="45%">
  <img src="https://i.imgur.com/laUPDAs.gif" width="45%">
</p>
<p float="left">
  <img src="https://i.imgur.com/ndGEE8r.gif" width="45%">
  <img src="https://i.imgur.com/kaXKfN5.gif" width="45%">
</p>

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  pressable_flutter: <latest_version>
```

Then, run `flutter pub get` to install the package.

## Usage

Import the package in your Dart file:

```dart
import 'package:pressable_flutter/pressable_flutter.dart';
```

### Example

Here's a simple example of using the `Pressable` widget with a combined effect:

<img src="https://i.imgur.com/gZTpzZq.gif">

```dart
Pressable(
  effect: PressEffect.withRipple(),
  onPress: () => log('onPress'),
  onLongPress: () => log('onLongPress'),
  child: Container(
    height: 50,
    width: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [Colors.deepPurple.shade800, Colors.deepPurpleAccent],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(30),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Center(
      child: Text(
        'Click Me',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

## Pressable Effects

### RippleEffect

The `RippleEffect` provides a ripple effect on press. It has customizable properties such as color and borderRadius.

#### Properties

- **color**: Color of the ripple effect.
- **borderRadius**: Border radius for background ripple effect (only applicable for background type).

#### Factory Constructors

- **foreground**: Creates a foreground ripple effect with optional color.
- **foregroundSaturated**: Creates a saturated foreground ripple effect.
- **background**: Creates a background ripple effect with optional color and border radius.

#### Example

<img src="https://i.imgur.com/kaXKfN5.gif">

```dart
Pressable(
  effect: RippleEffect.foreground(),
  onPress: () => log('onPress'),
  onLongPress: () => log('onLongPress'),
  child: Container(
    height: 50,
    width: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [Colors.red.shade800, Colors.redAccent],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(30),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Center(
      child: Text(
        'Click Me',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

#### Foreground Effect

<img src="https://i.imgur.com/GC2W9Qr.gif">

```dart
Pressable(
  effect: PressEffect.withRipple(
    rippleEffect: RippleEffect.foreground(
      color: Colors.deepPurple,
    ),
  ),
  onPress: () => log('onPress'),
  onLongPress: () => log('onLongPress'),
  child: Container(
    height: 50,
    width: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey, width: 3),
    ),
    child: const Center(
      child: Text(
        'Click Me',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

#### Foreground Saturated Effect

<img src="https://i.imgur.com/ndGEE8r.gif">

```dart
Pressable(
  effect: PressEffect.withSaturatedRipple(),
  onPress: () => log('onPress'),
  onLongPress: () => log('onLongPress'),
  child: Container(
    height: 50,
    width: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const LinearGradient(
        colors: [Colors.amber, Colors.amberAccent],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(30),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Center(
      child: Text(
        'Click Me',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

#### Background Ripple

<img src="https://i.imgur.com/eHZ2YLi.gif">

```dart
Pressable(
  effect: PressEffect.withRipple(
    rippleEffect: RippleEffect.background(
      color: Colors.amberAccent,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPress: () => log('onPress'),
  onLongPress: () => log('onLongPress'),
  child: Container(
    height: 50,
    width: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey),
    ),
    child: Center(
      child: Text(
        'Click Me',
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

### PressEffect

The `PressEffect` provides a shrink effect on press. It can also be combined with a ripple effect for a more dynamic interaction.

#### Properties

- **shrinkFactor**: The shrink factor to reduce the size of the widget on press (default: 0.95).
- **rippleEffect**: Optional ripple effect to combine with the press effect.

#### Factory Constructors

- **withRipple**: Press effect with a customizable ripple effect.
- **withSaturatedRipple**: Press effect with a saturated ripple effect.

#### Example

<img src="https://i.imgur.com/laUPDAs.gif">

```dart
Pressable(
  onPress: () => log('onPress'),
  onLongPress: () => log('onLongPress'),
  child: Container(
    height: 50,
    width: 300,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        colors: [Colors.blue.shade800, Colors.blueAccent],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(30),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Center(
      child: Text(
        'Click Me',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)
```

## Additional Properties

The `Pressable` widget now includes these additional properties:

- **duration**: Custom duration for the press animation.
- **enabled**: Whether the pressable effect is enabled (default: true).
- **useDisabledColorEffect**: Whether to apply a grayscale effect when disabled (default: true).
- **backgroundColor**: Background color of the pressable area.


## Contributions

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request on [GitHub](https://github.com/Yousef-Shaiban/pressable).

##  License

This project is licensed under the MIT License - see the LICENSE file for details.

---

With this package, you can easily add interactive press effects to your Flutter widgets, enhancing the user experience in your apps. Enjoy using Pressable!

---
