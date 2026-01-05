import 'package:adminapp/reusable/custom_table.dart';
import 'package:flutter/material.dart';

class UsersTableView extends StatelessWidget {
  const UsersTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: CustomTable(
            headers: const [
              'Users ID',
              'Nmae',
              'Email',
              'Phone',
              'Address',
              'Status', // This will now hold our custom Chip widget
              'Action',
            ],
            rows: [
              [
                '#User-7721',
                'John Doe',
                'johndoe@example.com',
                '4545645675',
                'New yourk',
                'Active',
                ElevatedButton(onPressed: () {}, child: const Text("Details")),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
