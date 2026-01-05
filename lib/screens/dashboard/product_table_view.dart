import 'package:adminapp/reusable/custom_input.dart';
import 'package:adminapp/reusable/custom_table.dart';
import 'package:adminapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ProductTableView extends StatelessWidget {
  const ProductTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT TABLE
          Expanded(
            child: CustomTable(
              headers: const [
                'Id',
                'Name',
                'Brand',
                'Description',
                'Price',
                'Stock',
                'Category',
                'Image',
                'Action',
              ],
              rows: [
                [
                  '1',
                  'Rolex',
                  'Luxury',
                  'Submariner',
                  '\$5000',
                  '12',
                  'Watch',
                  Image.asset('assets/mainlogo.png', width: 40, height: 40),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit_outlined,
                          color: AppColors.success,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 24),

          /// RIGHT FORM (Fixed 440px)
          SizedBox(
            width: 440,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),             
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomInput(labelText: "Name"),
                        SizedBox(height: 10),
                        CustomInput(labelText: "Brand"),
                        SizedBox(height: 10),
                        CustomInput(labelText: "Description"),
                        SizedBox(height: 10),
                        CustomInput(labelText: "Price"),
                        SizedBox(height: 10),
                        CustomInput(labelText: "Stock"),
                        SizedBox(height: 10),
                        CustomInput(labelText: "Category"),
                        SizedBox(height: 10),
                        CustomInput(labelText: "Image"),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text('Save Product'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
