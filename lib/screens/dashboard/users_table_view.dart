import 'package:adminapp/reusable/custom_table.dart';
import 'package:flutter/material.dart';

class UsersTableView extends StatelessWidget {
  const UsersTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.topLeft,
        child: CustomTable(
          headers: const [
            'Users ID',
            'Name',
            'Email',
            'Phone',
            'Address',
            'Status',
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
    );
  }
}
