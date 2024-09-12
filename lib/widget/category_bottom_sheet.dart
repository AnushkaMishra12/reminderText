import 'package:flutter/material.dart';

class CategoryBottomSheet extends StatefulWidget {
  final Map<String, Map<String, double>> categoryData;
  final void Function(Map<String, Map<String, double>>) onSave;

  const CategoryBottomSheet({
    super.key,
    required this.categoryData,
    required this.onSave,
  });

  @override
  _CategoryBottomSheetState createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late Map<String, Map<String, double>> localCategoryData;

  @override
  void initState() {
    super.initState();
    localCategoryData = Map.from(widget.categoryData);
  }

  String getCategoryLabel(double value) {
    if (value <= 20) {
      return "Bad";
    } else if (value <= 40) {
      return "Good";
    } else if (value <= 80) {
      return "Average";
    } else {
      return "Excellent";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Set values for all categories',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: localCategoryData.keys.length,
                itemBuilder: (context, index) {
                  String category = localCategoryData.keys.elementAt(index);
                  double currentValue = localCategoryData[category]!["Value"]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set value for $category (${getCategoryLabel(currentValue)})',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Slider(
                        value: currentValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: getCategoryLabel(currentValue),
                        onChanged: (val) {
                          setState(() {
                            localCategoryData[category]!["Value"] = val;
                            localCategoryData[category]!["Bad"] = (val <= 20) ? val : 0;
                            localCategoryData[category]!["Good"] = (val > 20 && val <= 40) ? val : 0;
                            localCategoryData[category]!["Average"] = (val > 40 && val <= 80) ? val : 0;
                            localCategoryData[category]!["Excellent"] = (val > 80) ? val : 0;
                          });
                        },
                      ),
                      Divider(), // Optional: Add a divider for visual separation
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(localCategoryData); // Pass updated data
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
