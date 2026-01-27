import 'package:adminapp/providers/chats/chat_support_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:adminapp/widget/custom_table.dart';

class ChatSupportTableView extends StatefulWidget {
  const ChatSupportTableView({super.key});

  @override
  State<ChatSupportTableView> createState() => _ChatSupportTableViewState();
}

class _ChatSupportTableViewState extends State<ChatSupportTableView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatSupportProvider>().fetchChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatSupportProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    /// Map DB data to table format - FIXED
    final tableData = provider.chats.map((c) {
      return {
        'id': c['id'],
        'name': c['name'] ?? 'Unknown',          
        'email': c['email'] ?? 'N/A',           
        'message': c['message'] ?? '',
        'date': c['created_at'],
      };
    }).toList();

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ResponsiveTableView(
            title: 'Chat Support Messages',
            data: tableData,
            headerActions: [
              ElevatedButton.icon(
                onPressed: () => provider.refreshChats(),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text("Refresh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  side: const BorderSide(color: Colors.black12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
            headers: const [
              'Name',
              'Email',
              'Message',
              'Date',
            ],
            rowBuilder: (context, header, value, item) {
              switch (header) {
                case 'Date':
                  final dt = DateTime.parse(value.toString());
                  return Text(
                    "${dt.day}/${dt.month}/${dt.year}",
                    style: const TextStyle(fontSize: 12),
                  );

                default:
                  return SelectableText(
                    value.toString(),
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}