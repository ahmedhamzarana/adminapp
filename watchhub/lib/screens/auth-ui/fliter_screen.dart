import 'package:flutter/material.dart';
import 'package:watchhub/utils/appconstant.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  // Sample filters
  final List<String> brands = ["Rolex", "Casio", "Omega", "Titan"];
  final List<String> watchTypes = ["Luxury", "Sport", "Smart", "Classic"];
  RangeValues priceRange = const RangeValues(100, 10000);

  String? selectedBrand;
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appconstant.appmaincolor,
        title: const Text(
          "Filter Watches",
          style: TextStyle(color: Appconstant.barcolor),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedBrand = null;
                selectedType = null;
                priceRange = const RangeValues(100, 10000);
              });
            },
            child: const Text(
              "Reset",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Brand",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Wrap(
            spacing: 10,
            children: brands.map((brand) {
              final isSelected = selectedBrand == brand;
              return ChoiceChip(
                label: Text(brand),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    selectedBrand = isSelected ? null : brand;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "Watch Type",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Wrap(
            spacing: 10,
            children: watchTypes.map((type) {
              final isSelected = selectedType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    selectedType = isSelected ? null : type;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            "Price Range",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          RangeSlider(
            values: priceRange,
            min: 0,
            max: 20000,
            divisions: 100,
            labels: RangeLabels(
              "\$${priceRange.start.round()}",
              "\$${priceRange.end.round()}",
            ),
            onChanged: (range) {
              setState(() {
                priceRange = range;
              });
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Appconstant.barcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // 🔹 Apply filters logic here
                print("Selected Brand: $selectedBrand");
                print("Selected Type: $selectedType");
                print("Price Range: ${priceRange.start} - ${priceRange.end}");
                Navigator.pop(context); // Close filter screen
              },
              child: const Text(
                "Apply Filters",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
