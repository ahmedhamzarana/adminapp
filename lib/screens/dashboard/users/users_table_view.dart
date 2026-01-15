import 'package:adminapp/providers/users/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adminapp/reusable/custom_table.dart';

class UsersTableView extends StatefulWidget {
  const UsersTableView({super.key});

  @override
  State<UsersTableView> createState() => _UsersTableViewState();
}

class _UsersTableViewState extends State<UsersTableView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.users.isEmpty) {
          return const Center(child: Text("No users found"));
        }

        return Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: ResponsiveTableView(
                title: "User Management",
                data: provider.users,
                headers: const ['Avatar', 'Name', 'Email', 'Role', 'Status'],
                rowBuilder: (context, header, value, item) {
                  // ---------------- AVATAR ----------------
                  if (header == 'Avatar') {
                    final String name = item['name'] ?? '';
                    final String? imageUrl = item['image_url'];

                    if (imageUrl != null && imageUrl.isNotEmpty) {
                      return CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(imageUrl),
                      );
                    }

                    return CircleAvatar(
                      radius: 14,
                      child: Text(
                        name.isNotEmpty
                            ? name[0].toUpperCase()
                            : '?',
                      ),
                    );
                  }

                  // ---------------- NAME ----------------
                  if (header == 'Name') {
                    return Text(
                      item['name'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  }

                  // ---------------- EMAIL ----------------
                  if (header == 'Email') {
                    return Text(
                      item['email'] ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    );
                  }

                  // ---------------- ROLE ----------------
                  if (header == 'Role') {
                    return Text(item['role'] ?? '-');
                  }

                  // ---------------- STATUS ----------------
                  if (header == 'Status') {
                    final String status = item['status'] ?? 'Inactive';

                    return Text(
                      status,
                      style: TextStyle(
                        color: status == 'Active'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

