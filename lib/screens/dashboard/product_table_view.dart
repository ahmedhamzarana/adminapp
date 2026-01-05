import 'package:adminapp/reusable/custom_table.dart';
import 'package:flutter/material.dart';

class ProductTableView extends StatelessWidget {
  const ProductTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
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
            SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                'https://www.alo.zone/web/image/19845/silver_rolex.jpg',
                fit: BoxFit.cover,
              ),
            ),

            ElevatedButton(onPressed: () {}, child: const Text("Edit")),
          ],
        ],
      ),
    );
  }
}
