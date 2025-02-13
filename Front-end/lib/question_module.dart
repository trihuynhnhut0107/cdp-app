import 'package:flutter/material.dart';

// class YesNoQuestion extends StatelessWidget {
//   final String question;
//   const YesNoQuestion({super.key, this.question = "Do you like Flutter?"});

//   @override
//   Widget build(BuildContext context) {
//     // Call the parent class with count 2 for Yes/No options
//     return SelectionQuestion(
//       options: ["Yes", "No"],
//       question: question,
//     );
//   }
// }

class SelectionQuestion extends StatefulWidget {
  final List<String> options; // List of options
  final String question;
  final int selection;
  final ValueChanged<int> onSelection;
  final Color color;
  const SelectionQuestion({
    super.key,
    this.options = const ["Yes", "No", "Maybe"],
    this.question = "Do you like Flutter?",
    this.color = Colors.cyan,
    required this.selection,
    required this.onSelection,
  });

  @override
  State<SelectionQuestion> createState() => _SelectionQuestionState();
}

class _SelectionQuestionState extends State<SelectionQuestion> {
  get colorScheme => Theme.of(context).colorScheme;
  late int selectedOption = widget.selection;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: colorScheme.primary,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(30.0), // Set the rounded corners here
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Makes the column size wrap its children
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text("Current answer index: $selectedOption"),
                const SizedBox(height: 8),
                selectedOption == -1
                    ? const Text("No answer selected")
                    : Text(
                        "Selected answer: ${widget.options[selectedOption]}"), // Show the selected option
                const SizedBox(height: 16),

                // Replaced ListView with Column
                Column(
                  children: widget.options.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value;

                    return CustomRadioListTile(
                      title: option, // Use option from array
                      value: index,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          if (selectedOption != value) {
                            selectedOption = value!;
                          } else if (selectedOption == value) {
                            selectedOption = -1;
                          }
                          widget.onSelection(selectedOption);
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRadioListTile extends StatelessWidget {
  final String title; // The title of the ListTile
  final int value; // The value of the Radio button
  final int groupValue; // The selected value in the group
  final ValueChanged<int?> onChanged; // Callback for when an option is selected

  const CustomRadioListTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Set the rounded corners here
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      color: groupValue == value
          ? Colors.cyan[100]
          : null, // Highlight selected option
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(title),
              onTap: () => onChanged(value), // On tap, change the selection
            ),
          ),
        ],
      ),
    );
  }
}

class MultipleSelectionQuestion extends StatefulWidget {
  final List<String> options; // List of options
  final String question;
  final int maxSelections; // Maximum number of selections allowed
  final List<int> selection;
  final ValueChanged<List<int>> onSelection;

  const MultipleSelectionQuestion({
    super.key,
    this.options = const ["Yes", "No", "Maybe"],
    this.maxSelections = 2,
    this.question = 'Do you like Flutter?',
    required this.selection,
    required this.onSelection,
  });

  @override
  State<MultipleSelectionQuestion> createState() =>
      _MultipleSelectionQuestionState();
}

class _MultipleSelectionQuestionState extends State<MultipleSelectionQuestion> {
  late List<int> selectedOptions;

  @override
  void initState() {
    super.initState();
    // Initialize with selections from parent
    selectedOptions = List<int>.from(widget.selection);
  }

  void _toggleSelection(int index) {
    setState(() {
      if (selectedOptions.contains(index)) {
        selectedOptions.remove(index);
      } else if (selectedOptions.length < widget.maxSelections) {
        selectedOptions.add(index);
      } else {
        // Show error message when max selection is reached
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "You can only select up to ${widget.maxSelections} options."),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Notify parent of selection changes
      widget.onSelection(List<int>.from(selectedOptions));
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(30.0), // Set the rounded corners here
        ),
        margin: const EdgeInsets.all(16),
        color: colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Wrap the content in SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.question,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                selectedOptions.isEmpty
                    ? const Text("No answers selected")
                    : Text(
                        "Selected answers: ${selectedOptions.map((i) => widget.options[i]).join(", ")}"),
                const SizedBox(height: 16),
                Column(
                  children: widget.options.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value;

                    return CustomCheckboxListTile(
                      title: option,
                      value: selectedOptions.contains(index),
                      onChanged: (bool? isSelected) {
                        _toggleSelection(index);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCheckboxListTile extends StatelessWidget {
  final String title; // The title of the ListTile
  final bool value; // Whether the checkbox is checked
  final ValueChanged<bool?> onChanged; // Callback for when an option is toggled

  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(30.0), // Set the rounded corners here
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: value ? Colors.cyan[100] : null, // Highlight selected option
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(title),
              onTap: () => onChanged(!value), // Toggle on tap
            ),
          ),
        ],
      ),
    );
  }
}

class PolarQuestion extends StatefulWidget {
  final String question; // The question to ask
  final List<String> options; // The options for the polar question

  const PolarQuestion({
    super.key,
    required this.question,
    required this.options,
  });

  @override
  State<PolarQuestion> createState() => _PolarQuestionState();
}

class _PolarQuestionState extends State<PolarQuestion> {
  double _sliderValue = 0; // Slider value (0 to length of options - 1)

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.question,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _sliderValue,
              min: 0,
              max: widget.options.length - 1.toDouble(),
              divisions: widget.options.length - 1, // Dividing into options
              label: widget.options[_sliderValue.toInt()],
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Text("Selected: ${widget.options[_sliderValue.toInt()]}"),
          ],
        ),
      ),
    );
  }
}

class OpenQuestion extends StatefulWidget {
  final String question;
  final int characterLimit;
  const OpenQuestion(
      {super.key,
      this.question = "This is an open question",
      this.characterLimit = 100});

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {
  final TextEditingController _controller = TextEditingController();

  @override
  // void dispose() {
  //   FocusScope.of(context).unfocus(); // Dismiss keyboard when widget is removed
  //   _controller.dispose(); // Properly dispose of the controller
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
      child: Center(
        child: Card(
          color: colorScheme.primary,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        labelText: 'Enter text here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // rounded corners for the border
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4, // allows for multiline input
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
