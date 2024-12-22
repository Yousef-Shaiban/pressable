import 'package:flutter/material.dart';

final class Mutable<T> {
  T value;

  Mutable(this.value);
}

abstract class PressableEffect {
  const PressableEffect();
}

class RippleEffect extends PressableEffect {
  static const defaultRippleColor = Colors.black26;

  @immutable
  final Color? color;
  final String type;
  final BorderRadius? borderRadius;

  const RippleEffect._({
    this.color,
    required this.type,
    this.borderRadius,
  });

  factory RippleEffect.foreground({
    Color? color,
  }) =>
      RippleEffect._(color: color, type: 'foreground');

  factory RippleEffect.foregroundSaturated({
    Duration? duration,
  }) =>
      const RippleEffect._(type: 'foreground-saturated');

  factory RippleEffect.background({
    Color? color,
    BorderRadius? borderRadius,
  }) =>
      RippleEffect._(
          color: color, type: 'background', borderRadius: borderRadius);
}

class PressEffect extends PressableEffect {
  static const _defaultshrinkFactor = 0.95;

  final double shrinkFactor;
  final RippleEffect? rippleEffect;
  const PressEffect({
    this.shrinkFactor = _defaultshrinkFactor,
    this.rippleEffect,
  }) : assert(shrinkFactor <= 1.0);

  factory PressEffect.withRipple({
    double shrinkFactor = _defaultshrinkFactor,
    RippleEffect? rippleEffect,
  }) =>
      PressEffect(
        shrinkFactor: shrinkFactor,
        rippleEffect: rippleEffect ?? RippleEffect.foreground(),
      );

  factory PressEffect.withSaturatedRipple({
    double shrinkFactor = _defaultshrinkFactor,
  }) =>
      PressEffect(
        shrinkFactor: shrinkFactor,
        rippleEffect: RippleEffect.foregroundSaturated(),
      );
}

class Pressable extends StatefulWidget {
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

  final Widget child;
  final Duration? duration;
  final PressableEffect effect;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool useDisabledColorEffect;
  final Color? backgroundColor;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Mutable<Animation<double>> animation;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: widget.effect is PressEffect
            ? widget.duration ?? const Duration(milliseconds: 70)
            : widget.duration ?? const Duration(milliseconds: 100));
    animation = Mutable(Tween<double>(
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
    double v = 1 - strength * color.alpha / 255;

    return <double>[
      v, 0, 0, 0, color.red * (1 - v), // r
      0, v, 0, 0, color.green * (1 - v), // g
      0, 0, v, 0, color.blue * (1 - v), // b
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
    return color.withOpacity(color.opacity * strength);
  }

  Widget _buildRippleEffect(RippleEffect effect, Widget? child) {
    if (effect.type == 'background') {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: adjustColorStrength(
            effect.color ?? Colors.grey.withOpacity(0.15),
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
      color: widget.backgroundColor ?? Colors.white.withOpacity(0),
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
