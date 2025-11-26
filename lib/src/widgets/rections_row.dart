import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/flutter_chat_reactions.dart';
import 'package:flutter_chat_reactions/src/widgets/reactions_button.dart';

class ReactionsRow extends StatefulWidget {
  /// Creates a reactions row widget.
  const ReactionsRow({
    super.key,
    required this.reactions,
    required this.alignment,
    required this.onReactionTap,
    required this.controller,
    required this.messageId,
    this.maxReactionsToShow = 7,
  });

  final List<String> reactions;
  final Alignment alignment;
  final Function(String, int) onReactionTap;
  final ReactionsController controller;
  final String messageId;
  final int maxReactionsToShow;

  @override
  State<ReactionsRow> createState() => _ReactionsRowState();
}

class _ReactionsRowState extends State<ReactionsRow> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final hasMoreItems = widget.reactions.length > widget.maxReactionsToShow;
    final itemsToShow = _showAll
        ? widget.reactions
        : widget.reactions.take(widget.maxReactionsToShow).toList();

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: _showAll ? _buildGridView() : _buildRow(itemsToShow, hasMoreItems),
    );
  }

  Widget _buildRow(List<String> reactions, bool hasMoreItems) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < reactions.length; i++)
            ReactionButton(
              reaction: reactions[i],
              index: i,
              onTap: widget.onReactionTap,
              isOwnReaction: _isOwnReaction(reactions[i]),
            ),
          if (hasMoreItems)
            IconButton(
                onPressed: () {
                  setState(() {
                    _showAll = true;
                  });
                },
                icon: const Icon(Icons.add)),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    const int crossAxisCount = 8;
    const double crossAxisSpacing = 1;
    const double childAspectRatio = 1;
    const double mainAxisSpacing = 1;
    const double containerWidth = 300;
    return SizedBox(
      width: containerWidth,
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: widget.reactions.length,
        itemBuilder: (context, index) {
          return ReactionButton(
            reaction: widget.reactions[index],
            index: index,
            onTap: widget.onReactionTap,
            isOwnReaction: _isOwnReaction(widget.reactions[index]),
          );
        },
      ),
    );
  }

  bool _isOwnReaction(String reaction) =>
      widget.controller.hasUserReacted(widget.messageId, reaction);

}
