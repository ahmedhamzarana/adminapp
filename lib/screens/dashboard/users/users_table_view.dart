import 'package:adminapp/providers/users/user_provider.dart';
import 'package:adminapp/screens/dashboard/users/user_detail_dailog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adminapp/widget/custom_table.dart';

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
                headers: const [
                  'Avatar',
                  'Name',
                  'Email',
                  'Action',
                ],
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
                      backgroundColor: Colors.blue,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  }

                  // ---------------- NAME ----------------
                  if (header == 'Name') {
                    return Text(
                      item['name'] ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  }

                  // ---------------- EMAIL ----------------
                  if (header == 'Email') {
                    return Text(
                      item['email'] ?? 'N/A',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  }

                  // ---------------- ACTION ----------------
                  if (header == 'Action') {
                    return IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ChangeNotifierProvider.value(
                            value: context.read<UsersProvider>(),
                            child: UserDetailDialog(user: item),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.visibility,
                        size: 20,
                        color: Colors.indigo,
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