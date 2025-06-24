import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
                      return const Icon(Icons.sentiment_very_dissatisfied,
                          color: Colors.red);
                    case 1:
                      return const Icon(Icons.sentiment_dissatisfied,
                          color: Colors.redAccent);
                    case 2:
                      return const Icon(Icons.sentiment_neutral,
                          color: Colors.amber);
                    case 3:
                      return const Icon(Icons.sentiment_satisfied,
                          color: Colors.lightGreen);
                    case 4:
                      return const Icon(Icons.sentiment_very_satisfied,
                          color: Colors.green);
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
