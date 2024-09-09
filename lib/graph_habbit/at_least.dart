import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T> onItemSelected;
  final String hintText;

  const CustomDropdown({
    required this.items,
    required this.onItemSelected,
    this.selectedItem,
    this.hintText = 'Select an item',
    super.key,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;

  @override
  void dispose() {
    if (_isDropdownOpen) {
      _closeDropdown();
    }
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
    _isDropdownOpen = true;
  }

  void _closeDropdown() {
    _overlayEntry.remove();
    _isDropdownOpen = false;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: widget.items.map((T item) {
                return ListTile(
                  title: Text(item.toString()),
                  onTap: () {
                    widget.onItemSelected(item);
                    _closeDropdown();
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.selectedItem?.toString() ?? widget.hintText,
                style: TextStyle(
                    color: widget.selectedItem == null
                        ? Colors.grey
                        : Colors.black),
              ),
              const Spacer(),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}

class AtLeast extends StatefulWidget {
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<List<String>> onDaysSelected;

  const AtLeast({
    required this.onFrequencyChanged,
    required this.onDaysSelected,
    super.key,
  });

  @override
  _AtLeastState createState() => _AtLeastState();
}

class _AtLeastState extends State<AtLeast> {
  String? _selectedFrequency;
  final Set<String> _selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: CustomDropdown<String>(
            items: const ['Every day', 'Specific day'],
            selectedItem: _selectedFrequency,
            hintText: 'Select Frequency',
            onItemSelected: (String newValue) {
              setState(() {
                _selectedFrequency = newValue;
              });
              widget.onFrequencyChanged(newValue);
              if (newValue == 'Specific day') {
                _showWeekDaySelectionDialog(context);
              } else {
                widget.onDaysSelected([]);
                _selectedDays.clear();
              }
            },
          ),
        ),
      ],
    );
  }

  void _showWeekDaySelectionDialog(BuildContext context) {
    final List<String> weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Select Days'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: weekDays.map((day) {
                      return CheckboxListTile(
                        title: Text(day),
                        value: _selectedDays.contains(day),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedDays.add(day); // Add day to set
                            } else {
                              _selectedDays.remove(day); // Remove day from set
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      widget.onDaysSelected(
                          _selectedDays.toList()); // Convert set to list
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
