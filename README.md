# Pressable Widget Package

## Overview

The Pressable package provides a customizable widget that adds various press effects to any child widget. It offers both ripple and scaling effects, giving you the ability to enhance the user interaction experience in your Flutter applications.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  pressable: ^0.0.1
```

Then, run `flutter pub get` to install the package.

## Usage

Import the package in your Dart file:

```dart
import 'package:pressable/pressable.dart';
```

### Basic Example

Here's a simple example of using the `Pressable` widget with a scaling effect:

```
Pressable(
  onPress: () {
    print('Widget pressed!');
  },
  child: Container(
    padding: EdgeInsets.all(16.0),
    color: Colors.blue,
    child: Text(
      'Press me',
      style: TextStyle(color: Colors.white),
    ),
  ),
)
```

## Pressable Effects

### RippleEffect

The `RippleEffect` provides a ripple effect on press. It has customizable properties such as color and mode.

#### Properties

- **duration**: Duration of the ripple effect.
- **color**: Color of the ripple effect.
- **mode**: Mode of the ripple effect (background, content, contentSaturated).

#### Example

```
Pressable(
  effect: RippleEffect(
    color: Colors.blueAccent,
    mode: RippleEffectMode.background,
  ),
  child: Container(
    padding: EdgeInsets.all(16.0),
    color: Colors.red,
    child: Text(
      'Ripple Effect',
      style: TextStyle(color: Colors.white),
    ),
  ),
)
```

### ScaleEffect

The `ScaleEffect` provides a scaling effect on press. It can also be combined with a ripple effect for a more dynamic interaction.

#### Properties

- **duration**: Duration of the scaling effect.
- **scaleFactor**: The scale factor to reduce the size of the widget on press.
- **rippleEffect**: Optional ripple effect to combine with the scaling effect.

#### Factory Constructors

- **d50**: Scale effect with a duration of 50 milliseconds.
- **d100**: Scale effect with a duration of 100 milliseconds.
- **d150**: Scale effect with a duration of 150 milliseconds.
- **withRipple**: Scale effect with a customizable ripple effect.
- **withSaturatedRipple**: Scale effect with a saturated ripple effect.

#### Example

```
Pressable(
  effect: ScaleEffect.withRipple(
    scaleFactor: 0.9,
    rippleEffect: RippleEffect(color: Colors.green),
  ),
  child: Container(
    padding: EdgeInsets.all(16.0),
    color: Colors.orange,
    child: Text(
      'Scale with Ripple',
      style: TextStyle(color: Colors.white),
    ),
  ),
)
```

## Complete Example

Here’s a more comprehensive example demonstrating the use of both `RippleEffect` and `ScaleEffect`:

```
import 'package:flutter/material.dart';
import 'package:pressable/pressable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pressable Example'),
        ),
        body: Center(
          child: Pressable(
            onPress: () {
              print('Pressed!');
            },
            effect: ScaleEffect.withRipple(
              scaleFactor: 0.95,
              rippleEffect: RippleEffect(
                color: Colors.blue.withOpacity(0.3),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.blue,
              child: Text(
                'Press Me',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## Contributions

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request on [GitHub](https://github.com/Yousef-Shaiban/pressable).

##  License

This project is licensed under the MIT License - see the LICENSE file for details.

---

With this package, you can easily add interactive press effects to your Flutter widgets, enhancing the user experience in your apps. Enjoy using Pressable!

---
