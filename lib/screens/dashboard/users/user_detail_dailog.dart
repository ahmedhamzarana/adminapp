import 'package:flutter/material.dart';

class UserDetailDialog extends StatelessWidget {
  const UserDetailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "John Doe",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "john.doe@example.com",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                const Divider(height: 24),

                section("User Info"),
                info("User ID", "123456"),
                info("Status", "Active"),
                info("Role", "Admin"),

                const SizedBox(height: 16),
                section("Address"),
                info("Phone", "+1 234 567 890"),
                info("City", "New York"),
                info("Zip", "10001"),
                info("Details", "123 Main St, Apt 4B"),

                const SizedBox(height: 16),
                section("Orders"),

                Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: const Text("Order #001"),
                        subtitle: const Text("2026-01-23"),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text("Rs 2500"),
                            Text(
                              "completed",
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text("Order #002"),
                        subtitle: const Text("2026-01-20"),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text("Rs 1500"),
                            Text(
                              "pending",
                              style: TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget section(String title) => Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  Widget info(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(label, style: const TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
