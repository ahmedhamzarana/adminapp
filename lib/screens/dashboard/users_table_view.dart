import 'package:adminapp/reusable/custom_table.dart';
import 'package:flutter/material.dart';

class UsersTableView extends StatelessWidget {
  const UsersTableView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> usersData = [
      {
        'user': 'John Doe',
        'email': 'john@watch.com',
        'role': 'Admin',
        'status': 'Active',
      },
      {
        'user': 'Sarah King',
        'email': 'sarah@watch.com',
        'role': 'Editor',
        'status': 'Active',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ResponsiveTableView(
        title: "User Management",
        data: usersData,
        headers: const ['User', 'Role', 'Status'],
        rowBuilder: (context, header, value, item) {
          if (header == 'User') {
            return Row(
              children: [
                CircleAvatar(radius: 14, child: Text(value[0])),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      item['email'],
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            );
          }
          return Text(value.toString());
        },
      ),
    );
  }
}
