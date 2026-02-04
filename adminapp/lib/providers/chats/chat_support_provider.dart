import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatSupportProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool isLoading = false;
  List<Map<String, dynamic>> chats = [];

  Future<void> fetchChats() async {
    try {
      isLoading = true;
      notifyListeners();
      final chatResponse = await supabase
          .from('tbl_chatsupport')
          .select('id, message, created_at, full_name, user_id')
          .order('created_at', ascending: false);

      debugPrint('======== CHAT RESPONSE ========');
      debugPrint('$chatResponse');
      debugPrint('==============================');

      final chatList = chatResponse as List;

      if (chatList.isEmpty) {
        debugPrint('⚠️ No chats found in tbl_chatsupport');
        chats = [];
        return;
      }

      final userIds = chatList
          .map((c) => c['user_id']?.toString().trim())
          .where((id) => id != null && id.isNotEmpty)
          .toSet()
          .toList();

      Map<String, dynamic> usersMap = {};

      if (userIds.isNotEmpty) {
        final usersResponse = await supabase
            .from('tbl_users')
            .select('user_id, name, email')
            .inFilter('user_id', userIds);

        for (var u in usersResponse as List) {
          final userId = u['user_id']?.toString().trim();
          if (userId != null && userId.isNotEmpty) {
            usersMap[userId] = u;
          }
        }
      } else {
        debugPrint('⚠️ No valid user_ids found');
      }

      chats = chatList.map<Map<String, dynamic>>((c) {
        final userId = c['user_id']?.toString().trim() ?? '';
        final user = userId.isNotEmpty ? usersMap[userId] : null;

        debugPrint('Processing chat ${c['id']}: userId=$userId, user found=${user != null}');

        return {
          'id': c['id'],
          'message': c['message'] ?? '',
          'created_at': c['created_at'],
          'user_id': userId,
          'name': user?['name'] ?? c['full_name'] ?? 'Unknown',
          'email': user?['email'] ?? 'N/A',
        };
      }).toList();


      
    } catch (e, stackTrace) {
      debugPrint('Stack trace: $stackTrace');
      chats = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshChats() => fetchChats();
}