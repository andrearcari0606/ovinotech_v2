import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PremiumCard extends StatefulWidget {

  final Widget child;

  final EdgeInsets? padding;

  final VoidCallback? onTap;

  final double radius;

  final bool dark;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.radius = 24,
    this.dark = false,
  });

  @override
  State<PremiumCard> createState() =>
      _PremiumCardState();
}

class _PremiumCardState
    extends State<PremiumCard> {

  bool pressed = false;

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkCard
        : Colors.white;

    return AnimatedScale(

      duration: const Duration(
        milliseconds: 120,
      ),

      scale: pressed ? 0.985 : 1,

      child: AnimatedContainer(

        duration: const Duration(
          milliseconds: 220,
        ),

        curve: Curves.easeOutCubic,

        decoration: BoxDecoration(

          color: backgroundColor,

          borderRadius:
              BorderRadius.circular(
            widget.radius,
          ),

          border: Border.all(

            color: isDark

                ? AppColors.glassBorder

                : Colors.black.withOpacity(
                    0.035,
                  ),

            width: 1,
          ),

          boxShadow: [

            BoxShadow(

              color: Colors.black.withOpacity(

                isDark
                    ? 0.22
                    : 0.045,
              ),

              blurRadius: pressed
                  ? 16
                  : 28,

              spreadRadius: -4,

              offset: Offset(
                0,
                pressed ? 6 : 14,
              ),
            ),

            BoxShadow(

              color: Colors.white
                  .withOpacity(
                isDark ? 0 : 0.65,
              ),

              blurRadius: 10,

              spreadRadius: -6,

              offset: const Offset(
                0,
                -4,
              ),
            ),
          ],
        ),

        child: Material(

          color: Colors.transparent,

          child: InkWell(

            borderRadius:
                BorderRadius.circular(
              widget.radius,
            ),

            splashColor:
                Colors.transparent,

            highlightColor:
                Colors.transparent,

            onHighlightChanged:
                (value) {

              setState(() {
                pressed = value;
              });
            },

            onTap: widget.onTap,

            child: Padding(

              padding:

                  widget.padding ??

                  const EdgeInsets.all(
                    18,
                  ),

              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}