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
<img src="https://i.imgur.com/8ooc2rM.gif">

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

Here's a simple example of using the `Pressable` widget with a shrink effect:

(https://i.imgur.com/8ooc2rM.gif)

```dart
Pressable(
  effect: PressEffect(
  shrinkFactor: 0.9,
  rippleEffect: RippleEffect.background(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    ),
  ),
  duration: const Duration(milliseconds: 100),
  onPress: () => log('onPress'),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8),
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

```dart
Pressable(
  effect: RippleEffect.foreground(
      color: Colors.amber,
  ),
  onPress: () => log('onPress'),
  child: Container(
    height: 100,
    width: 100,
    color: Colors.redAccent,
  ),
)
```

#### Foreground Effect

(https://i.imgur.com/MJXl5UH.gif)

```dart
Pressable(
  effect: PressEffect(
    rippleEffect: RippleEffect.foreground(
      color: Colors.amber,
    ),
  ),
  onPress: () => log('onPress'),
  child: Container(
    height: 100,
    width: 100,
    color: Colors.redAccent,
  ),
)
```

#### Foreground Saturated Effect

(https://i.imgur.com/2knQw1a.gif)

```dart
Pressable(
  effect: PressEffect(
    rippleEffect: RippleEffect.foregroundSaturated(),
  ),
  onPress: () => log('onPress'),
  child: Container(
    height: 100,
    width: 100,
    color: Colors.redAccent,
  ),
)
```

#### Background Ripple

(https://i.imgur.com/NX5U6fT.gif)

```dart
Pressable(
  effect: PressEffect(
    rippleEffect: RippleEffect.background(
      color: Colors.white,
    ),
  ),
  onPress: () => log('onPress'),
  child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    height: 100,
    width: 100,
    color: Colors.redAccent,
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

(https://i.imgur.com/zawXONO.gif)

```dart
Pressable(
  effect: const PressEffect(
    shrinkFactor: 0.9,
  ),
  child: Container(
    height: 100,
    width: 100,
    color: Colors.redAccent,
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
