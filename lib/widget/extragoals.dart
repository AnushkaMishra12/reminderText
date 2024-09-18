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
    this.hintText = 'Select extra goals',
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

class ExtraGoalsDropdown extends StatefulWidget {
  final String selectedGoal;
  final ValueChanged<String> onGoalChanged;
  final String hintText;

  const ExtraGoalsDropdown({
    required this.selectedGoal,
    required this.onGoalChanged,
    this.hintText = 'Select extra goals',
    super.key,
  });

  @override
  _ExtraGoalsDropdownState createState() => _ExtraGoalsDropdownState();
}

class _ExtraGoalsDropdownState extends State<ExtraGoalsDropdown> {
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.selectedGoal.isEmpty ? null : widget.selectedGoal;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      items: const [
        'Water',
        'Bills',
        'Study',
        'Sleep',
        'Wak=lk'
      ],
      selectedItem: _selectedGoal,
      hintText: widget.hintText,
      onItemSelected: (String newValue) {
        setState(() {
          _selectedGoal = newValue;
        });
        widget.onGoalChanged(newValue);
      },
    );
  }
}
