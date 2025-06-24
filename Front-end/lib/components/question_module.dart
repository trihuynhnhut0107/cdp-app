import 'package:cdp_app/models/survey_data.dart';
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
  final List<Option> options; // List of options
  final String question;
  final int selection;
  final ValueChanged<int> onSelection;
  final Color color;
  const SelectionQuestion({
    super.key,
    required this.options,
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
                // Text("Current answer index: $selectedOption"),
                // const SizedBox(height: 8),
                // selectedOption == -1
                //     ? const Text("No answer selected")
                //     : Text(
                //         "Selected answer: ${widget.options[selectedOption]}"), // Show the selected option
                const SizedBox(height: 16),

                // Replaced ListView with Column
                Column(
                  children: widget.options.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value.optionContent;

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
  final List<Option> options;
  final String question;
  final int maxSelections;
  final List<int> selectedIndexes;
  final ValueChanged<List<int>> onSelection;

  const MultipleSelectionQuestion({
    super.key,
    required this.options,
    required this.question,
    this.maxSelections = 2,
    required this.selectedIndexes,
    required this.onSelection,
  });

  @override
  State<MultipleSelectionQuestion> createState() =>
      _MultipleSelectionQuestionState();
}

class _MultipleSelectionQuestionState extends State<MultipleSelectionQuestion> {
  late List<int> _selectedOptions;

  @override
  void initState() {
    super.initState();
    _selectedOptions = List<int>.from(widget.selectedIndexes);
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedOptions.contains(index)) {
        _selectedOptions.remove(index);
      } else if (_selectedOptions.length < widget.maxSelections) {
        _selectedOptions.add(index);
      } else {
        _showError("You can select up to ${widget.maxSelections} options.");
      }
      widget.onSelection(List<int>.from(_selectedOptions));
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question),
            const SizedBox(height: 16),
            ...widget.options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value.optionContent;
              return CheckboxListTile(
                value: _selectedOptions.contains(index),
                title: Text(option),
                onChanged: (_) => _toggleSelection(index),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class OpenQuestion extends StatefulWidget {
  final String question;
  final int characterLimit;
  final ValueChanged<String> onAnswer;
  final String? initialValue;

  const OpenQuestion({
    super.key,
    required this.question,
    this.characterLimit = 300,
    required this.onAnswer,
    this.initialValue,
  });

  @override
  State<OpenQuestion> createState() => _OpenQuestionState();
}

class _OpenQuestionState extends State<OpenQuestion> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? "");
  }

  @override
  void didUpdateWidget(covariant OpenQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_controller.text.length <= widget.characterLimit) {
      widget.onAnswer(_controller.text);
    } else {
      _showError("Answer exceeds \\${widget.characterLimit} characters.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.question,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Your answer",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                onChanged: (_) => _submitAnswer(),
              ),
            ],
          ),
        ),
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
