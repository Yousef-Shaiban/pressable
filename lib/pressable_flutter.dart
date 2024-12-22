import 'package:flutter/material.dart';

final class _Mutable<T> {
  T value;

  _Mutable(this.value);
}

/// Base class for all pressable effects
abstract class PressableEffect {
  /// base constructor
  const PressableEffect();
}

/// Effect that shows a ripple animation when pressed
class RippleEffect extends PressableEffect {
  /// Default color for the ripple effect (black with 26% opacity)
  static const defaultRippleColor = Colors.black26;

  /// The color of the ripple effect
  final Color? color;

  /// The type of ripple effect ('foreground', 'background', or 'foreground-saturated')
  final String type;

  /// Optional border radius for background ripple effects
  final BorderRadius? borderRadius;

  /// Creates a ripple effect with the specified parameters
  const RippleEffect._({
    this.color,
    required this.type,
    this.borderRadius,
  });

  /// Creates a foreground ripple effect
  factory RippleEffect.foreground({
    Color? color,
  }) =>
      RippleEffect._(color: color, type: 'foreground');

  /// Creates a saturated foreground ripple effect
  factory RippleEffect.foregroundSaturated({
    Duration? duration,
  }) =>
      const RippleEffect._(type: 'foreground-saturated');

  /// Creates a background ripple effect
  factory RippleEffect.background({
    Color? color,
    BorderRadius? borderRadius,
  }) =>
      RippleEffect._(
          color: color, type: 'background', borderRadius: borderRadius);
}

/// Effect that scales the widget when pressed
class PressEffect extends PressableEffect {
  static const _defaultshrinkFactor = 0.95;

  /// The scale factor when pressed (between 0 and 1)
  final double shrinkFactor;

  /// Optional ripple effect to combine with the press effect
  final RippleEffect? rippleEffect;

  /// Creates a press effect with the specified parameters
  const PressEffect({
    this.shrinkFactor = _defaultshrinkFactor,
    this.rippleEffect,
  }) : assert(shrinkFactor <= 1.0);

  /// Creates a press effect with optional ripple
  factory PressEffect.withRipple({
    double shrinkFactor = _defaultshrinkFactor,
    RippleEffect? rippleEffect,
  }) =>
      PressEffect(
        shrinkFactor: shrinkFactor,
        rippleEffect: rippleEffect ?? RippleEffect.foreground(),
      );

  /// Creates a press effect with a saturated ripple
  factory PressEffect.withSaturatedRipple({
    double shrinkFactor = _defaultshrinkFactor,
  }) =>
      PressEffect(
        shrinkFactor: shrinkFactor,
        rippleEffect: RippleEffect.foregroundSaturated(),
      );
}

/// A widget that responds to press interactions with customizable visual effects
class Pressable extends StatefulWidget {
  /// Creates a pressable widget with the specified parameters
  const Pressable({
    super.key,
    required this.child,
    this.effect = const PressEffect(),
    this.onPress,
    this.onLongPress,
    this.enabled = true,
    this.useDisabledColorEffect = true,
    this.backgroundColor,
    this.duration,
  });

  /// The widget below this widget in the tree
  final Widget child;

  /// Duration of the press animation
  final Duration? duration;

  /// The effect to apply when pressed
  final PressableEffect effect;

  /// Called when the widget is tapped
  final VoidCallback? onPress;

  /// Called when the widget is long-pressed
  final VoidCallback? onLongPress;

  /// Whether the widget is interactive
  final bool enabled;

  /// Whether to apply a desaturation effect when disabled
  final bool useDisabledColorEffect;

  /// The background color of the widget
  final Color? backgroundColor;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final _Mutable<Animation<double>> animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: widget.effect is PressEffect
            ? widget.duration ?? const Duration(milliseconds: 70)
            : widget.duration ?? const Duration(milliseconds: 100));
    animation = _Mutable(Tween<double>(
            begin: 1.0,
            end: widget.effect is PressEffect
                ? (widget.effect as PressEffect).shrinkFactor
                : 0)
        .animate(animationController));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Pressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      animationController.duration =
          widget.duration ?? const Duration(milliseconds: 70);
    }

    if ((widget.effect is PressEffect &&
            oldWidget.effect is PressEffect &&
            (oldWidget.effect as PressEffect).shrinkFactor !=
                (widget.effect as PressEffect).shrinkFactor) ||
        (widget.effect.runtimeType != widget.effect.runtimeType)) {
      animation.value = Tween<double>(
        begin: 1.0,
        end: widget.effect is PressEffect
            ? (widget.effect as PressEffect).shrinkFactor
            : 0,
      ).animate(animationController);
    }
  }

  static List<double> getTintMatrix(double strength, Color color) {
    double v = 1 - strength * color.a;

    return <double>[
      v, 0, 0, 0, color.r * 255 * (1 - v), // r
      0, v, 0, 0, color.g * 255 * (1 - v), // g
      0, 0, v, 0, color.b * 255 * (1 - v), // b
      0, 0, 0, 1, 0, // a
    ];
  }

  static List<double> getSaturationMatrix(double strength) {
    double oppositeSaturation = 1 - strength;

    double r0 = 0.33 * (1 - oppositeSaturation), r1 = oppositeSaturation + r0;
    double g0 = 0.59 * (1 - oppositeSaturation), g1 = oppositeSaturation + g0;
    double b0 = 0.11 * (1 - oppositeSaturation), b1 = oppositeSaturation + b0;

    return <double>[
      r1, g0, b0, 0, 0, // r
      r0, g1, b0, 0, 0, // g
      r0, g0, b1, 0, 0, // b
      0, 0, 0, 1, 0, // a
    ];
  }

  Color? adjustColorStrength(Color? color, double strength) {
    if (color == null) return null;

    assert(strength >= 0 && strength <= 1, 'Strength must be between 0 and 1');
    return color.withAlpha((color.a * 255 * strength).round());
  }

  Widget _buildRippleEffect(RippleEffect effect, Widget? child) {
    if (effect.type == 'background') {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: adjustColorStrength(
            effect.color ?? Colors.grey.withAlpha(38),
            animationController.value,
          ),
          borderRadius: effect.borderRadius,
        ),
        child: child,
      );
    }

    return ColorFiltered(
      colorFilter: ColorFilter.matrix(
        effect.type == 'foreground'
            ? getTintMatrix(
                animationController.value,
                effect.color ?? RippleEffect.defaultRippleColor,
              )
            : getSaturationMatrix(animationController.value),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor ?? Colors.white.withAlpha(0),
      child: widget.enabled
          ? AnimatedBuilder(
              animation: animation.value,
              builder: (context, child) {
                if (widget.effect is PressEffect) {
                  final rippleEffect =
                      (widget.effect as PressEffect).rippleEffect;
                  if (rippleEffect != null) {
                    if (rippleEffect.type == 'background') {
                      return Transform.scale(
                        scale: animation.value.value,
                        child: _buildRippleEffect(rippleEffect, child),
                      );
                    }
                    return ColorFiltered(
                      colorFilter: ColorFilter.matrix(
                        rippleEffect.type == 'foreground'
                            ? getTintMatrix(
                                animationController.value,
                                rippleEffect.color ??
                                    RippleEffect.defaultRippleColor,
                              )
                            : getSaturationMatrix(animationController.value),
                      ),
                      child: Transform.scale(
                        scale: animation.value.value,
                        child: child,
                      ),
                    );
                  } else {
                    return Transform.scale(
                      scale: animation.value.value,
                      child: child,
                    );
                  }
                } else if (widget.effect is RippleEffect) {
                  final rippleEffect = widget.effect as RippleEffect;
                  if (rippleEffect.type == 'background') {
                    return _buildRippleEffect(rippleEffect, child);
                  }
                  return ColorFiltered(
                    colorFilter: ColorFilter.matrix(
                      rippleEffect.type == 'foreground'
                          ? getTintMatrix(
                              animationController.value,
                              rippleEffect.color ??
                                  RippleEffect.defaultRippleColor,
                            )
                          : getSaturationMatrix(animationController.value),
                    ),
                    child: child,
                  );
                } else {
                  return child ?? const SizedBox.shrink();
                }
              },
              child: GestureDetector(
                onTapCancel: () => animationController.animateTo(0),
                onTapDown: (details) => animationController.animateTo(1.0),
                onTapUp: (details) async {
                  await Future.delayed(
                      (widget.duration ?? const Duration(milliseconds: 70)));
                  if (context.mounted) {
                    animationController.animateTo(0);
                  }
                },
                onTap: widget.onPress,
                onLongPress: widget.onLongPress,
                child: widget.child,
              ),
            )
          : widget.useDisabledColorEffect
              ? ColorFiltered(
                  colorFilter: ColorFilter.matrix(getSaturationMatrix(1)),
                  child: widget.child,
                )
              : widget.child,
    );
  }
}
