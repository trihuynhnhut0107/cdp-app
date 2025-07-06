import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cdp_app/color_palette.dart';

class EmojiRatingBar extends StatelessWidget {
  final double initialRating;
  final bool isVertical;
  final Function(double) onRatingUpdate;
  final String question; // Add question parameter

  const EmojiRatingBar({
    super.key,
    required this.initialRating,
    required this.isVertical,
    required this.onRatingUpdate,
    required this.question, // Add question to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 220, // Adjust as needed
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  question,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  maxLines: 3,
                ),
              ),
              RatingBar.builder(
                initialRating: initialRating,
                direction: isVertical ? Axis.vertical : Axis.horizontal,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(Icons.sentiment_very_dissatisfied,
                          color: accentColor);
                    case 1:
                      return Icon(Icons.sentiment_dissatisfied,
                          color: accentColor.withOpacity(0.8));
                    case 2:
                      return Icon(Icons.sentiment_neutral, color: primaryDark);
                    case 3:
                      return Icon(Icons.sentiment_satisfied,
                          color: analogousGreen);
                    case 4:
                      return Icon(Icons.sentiment_very_satisfied,
                          color: analogousGreen.withOpacity(0.8));
                    default:
                      return const SizedBox.shrink();
                  }
                },
                onRatingUpdate: onRatingUpdate,
                updateOnDrag: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
