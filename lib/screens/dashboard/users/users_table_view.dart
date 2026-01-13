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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ResponsiveTableView(
          title: "User Management",
          data: usersData,
          headers: const ['Avatar', 'Name', 'Email', 'Role', 'Status'],
          rowBuilder: (context, header, value, item) {
            if (header == 'Avatar') {
              return CircleAvatar(radius: 14, child: Text(item['user'][0]));
            }
      
            if (header == 'Name') {
              return Text(
                item['user'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            }
      
            if (header == 'Email') {
              return Text(
                item['email'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              );
            }
      
            return Text(value.toString());
          },
        ),
      ),
    );
  }
}
