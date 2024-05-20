import 'package:flutter/material.dart';

abstract class PressableEffect {
  final Duration duration;
  const PressableEffect({required this.duration});
}

enum RippleEffectMode { background, content, contentSaturated }

class RippleEffect extends PressableEffect {
  static const _defaultEffectDuration = Duration(milliseconds: 120);
  static const defaultRippleColor = Colors.white12;
  final Color? color;
  final RippleEffectMode mode;
  const RippleEffect({
    super.duration = _defaultEffectDuration,
    this.color,
    this.mode = RippleEffectMode.content,
  });
}

class ScaleEffect extends PressableEffect {
  static const _defaultScaleFactor = 0.96;
  static const _defaultEffectDuration = Duration(milliseconds: 70);

  final double scaleFactor;
  final RippleEffect? rippleEffect;
  const ScaleEffect({
    super.duration = _defaultEffectDuration,
    this.scaleFactor = _defaultScaleFactor,
    this.rippleEffect,
  }) : assert(scaleFactor <= 1.0);

  factory ScaleEffect.d50({
    double scaleFactor = _defaultScaleFactor,
    RippleEffect? rippleEffect,
  }) =>
      ScaleEffect(
        duration: const Duration(milliseconds: 50),
        scaleFactor: scaleFactor,
        rippleEffect: rippleEffect,
      );

  factory ScaleEffect.d100({
    double scaleFactor = _defaultScaleFactor,
    RippleEffect? rippleEffect,
  }) =>
      ScaleEffect(
        duration: const Duration(milliseconds: 100),
        scaleFactor: scaleFactor,
        rippleEffect: rippleEffect,
      );

  factory ScaleEffect.d150({
    double scaleFactor = _defaultScaleFactor,
    RippleEffect? rippleEffect,
  }) =>
      ScaleEffect(
        duration: const Duration(milliseconds: 150),
        scaleFactor: scaleFactor,
        rippleEffect: rippleEffect,
      );

  factory ScaleEffect.withRipple({
    Duration? duration,
    double scaleFactor = _defaultScaleFactor,
    RippleEffect? rippleEffect,
  }) =>
      ScaleEffect(
        duration: duration ?? _defaultEffectDuration,
        scaleFactor: scaleFactor,
        rippleEffect: rippleEffect ?? const RippleEffect(),
      );

  factory ScaleEffect.withSaturatedRipple({
    Duration? duration,
    double scaleFactor = _defaultScaleFactor,
  }) =>
      ScaleEffect(
        duration: duration ?? _defaultEffectDuration,
        scaleFactor: scaleFactor,
        rippleEffect:
            const RippleEffect(mode: RippleEffectMode.contentSaturated),
      );
}

class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.effect = const ScaleEffect(),
    this.onPress,
    this.onLongPress,
  });

  final Widget child;
  final PressableEffect effect;
  final VoidCallback? onPress;
  final VoidCallback? onLongPress;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> with TickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: widget.effect.duration);
    animation = Tween<double>(
            begin: 1.0,
            end: widget.effect is ScaleEffect
                ? (widget.effect as ScaleEffect).scaleFactor
                : 0)
        .animate(animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (widget.effect is ScaleEffect) {
          final rippleEffect = (widget.effect as ScaleEffect).rippleEffect;
          if (rippleEffect != null) {
            if (rippleEffect.mode == RippleEffectMode.background) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                color: rippleEffect.color
                        ?.withOpacity(animationController.value) ??
                    Colors.white.withOpacity(animationController.value * 0.15),
                child: Transform.scale(
                  scale: animation.value,
                  child: child,
                ),
              );
            }
            return ColorFiltered(
              colorFilter: ColorFilter.matrix(
                rippleEffect.mode == RippleEffectMode.content
                    ? getTintMatrix(
                        animationController.value,
                        rippleEffect.color ?? Colors.white12,
                      )
                    : getSaturationMatrix(animationController.value),
              ),
              child: Transform.scale(
                scale: animation.value,
                child: child,
              ),
            );
          } else {
            return Transform.scale(
              scale: animation.value,
              child: child,
            );
          }
        } else if (widget.effect is RippleEffect) {
          final rippleEffect = widget.effect as RippleEffect;
          if (rippleEffect.mode == RippleEffectMode.background) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              color: rippleEffect.color
                      ?.withOpacity(animationController.value) ??
                  Colors.white.withOpacity(animationController.value * 0.15),
              child: child,
            );
          }
          return ColorFiltered(
            colorFilter: ColorFilter.matrix(
              rippleEffect.mode == RippleEffectMode.content
                  ? getTintMatrix(
                      animationController.value,
                      rippleEffect.color ?? Colors.white12,
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
            Duration(
              milliseconds:
                  (widget.effect.duration.inMilliseconds * 1.7).toInt(),
            ),
          );
          animationController.animateTo(0);
        },
        onTap: widget.onPress,
        onLongPress: widget.onLongPress,
        child: widget.child,
      ),
    );
  }
}
