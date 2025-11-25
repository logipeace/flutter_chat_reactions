import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

/// Single reaction button with animation
class ReactionButton extends StatelessWidget {
  /// Creates a reaction button widget.
  const ReactionButton({
    super.key,
    required this.reaction,
    required this.index,
    required this.onTap,
    required this.isOwnReaction,
  });

  final String reaction;
  final int index;
  final Function(String, int) onTap;
  final bool isOwnReaction;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      from: (index * 20).toDouble(),
      duration: const Duration(milliseconds: 200),
      delay: const Duration(milliseconds: 100),
      child: InkWell(
        onTap: () => onTap(reaction, index),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isOwnReaction
                ? Colors.blue.withValues(alpha: .2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          padding:
              EdgeInsets.fromLTRB(4.0, reaction == '♥️' ? 5 : 2.0, 4.0, 2.0),
          child: Text(
            reaction,
            style: const TextStyle(fontSize: 22, color: Colors.red),
          ),
        ),
      ),
    );
  }
}
