import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/src/controllers/reactions_controller.dart';
import 'package:flutter_chat_reactions/src/models/chat_reactions_config.dart';
import 'package:flutter_chat_reactions/src/models/menu_item.dart';
import 'package:flutter_chat_reactions/src/widgets/message_bubble.dart';
import 'package:flutter_chat_reactions/src/widgets/rections_row.dart';

/// A dialog widget that displays reactions and context menu options for a message.
///
/// This widget creates a modal dialog with three main sections:
/// - A row of reaction emojis that can be tapped
/// - The original message (displayed using a Hero animation)
/// - A context menu with customizable options
class ReactionsDialogWidget extends StatelessWidget {
  /// Unique identifier for the hero animation.
  final String messageId;

  /// The widget displaying the message content.
  final Widget messageWidget;

  /// Controller to manage reaction state.
  final ReactionsController controller;

  /// Configuration for the reactions dialog.
  final ChatReactionsConfig config;

  /// Callback triggered when a reaction is selected.
  final Function(String) onReactionTap;

  /// Callback triggered when a context menu item is selected.
  final Function(MenuItem) onMenuItemTap;

  /// Alignment of the dialog components.
  final Alignment alignment;

  /// Creates a reactions dialog widget.
  const ReactionsDialogWidget({
    super.key,
    required this.messageId,
    required this.messageWidget,
    required this.controller,
    required this.config,
    required this.onReactionTap,
    required this.onMenuItemTap,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: config.dialogBlurSigma, sigmaY: config.dialogBlurSigma),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: config.dialogPadding,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReactionsRow(
                    controller: controller,
                    messageId: messageId,
                    reactions: config.availableReactions,
                    alignment: alignment,
                    onReactionTap: (reaction, _) =>
                        _handleReactionTap(context, reaction),
                  ),
                  const SizedBox(height: 10),
                  messageWidget,
                  if (config.showContextMenu) ...[
                    ContextMenuWidget(
                      menuItems: config.menuItems,
                      alignment: alignment,
                      onMenuItemTap: (item, _) =>
                          _handleMenuItemTap(context, item),
                      customMenuItemBuilder: config.customMenuItemBuilder,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleReactionTap(BuildContext context, String reaction) {
    Navigator.of(context).pop();
    onReactionTap(reaction);
  }

  void _handleMenuItemTap(BuildContext context, MenuItem item) {
    Navigator.of(context).pop();
    onMenuItemTap(item);
  }
}

class ContextMenuWidget extends StatelessWidget {
  final List<MenuItem> menuItems;
  final Alignment alignment;
  final double menuWidth;
  final Function(MenuItem, int) onMenuItemTap;
  final Widget Function(MenuItem, VoidCallback)? customMenuItemBuilder;

  const ContextMenuWidget({
    super.key,
    required this.menuItems,
    required this.onMenuItemTap,
    this.alignment = Alignment.centerRight,
    this.menuWidth = 0.45,
    this.customMenuItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width / 5;
    return Container(
      height: menuItems.length > 4 ? (width * 2) : width,
      width: menuItems.length > 4
          ? (width * 4)
          : (width * menuItems.length.toDouble()),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .brightness == Brightness.dark
            ? const Color(0xFF2E2E2E)
            : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 0.2,
        mainAxisSpacing: 0.2,
        padding: EdgeInsets.zero,
        children: List.generate(menuItems.length, (index) {
          final item = menuItems[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onMenuItemTap(item, index),
              borderRadius: BorderRadius.circular(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.icon,
                  const SizedBox(height: 3,),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: item.fontSize ?? 14,
                      fontWeight: FontWeight.w500,),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
