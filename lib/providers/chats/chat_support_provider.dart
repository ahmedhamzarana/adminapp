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

      // Step 1: Fetch all chats
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

      // Step 2: Extract unique user_ids
      final userIds = chatList
          .map((c) => c['user_id']?.toString().trim())
          .where((id) => id != null && id.isNotEmpty)
          .toSet()
          .toList();

      debugPrint('======== USER IDS ========');
      debugPrint('$userIds');
      debugPrint('==========================');

      Map<String, dynamic> usersMap = {};

      // Step 3: Fetch users data if user_ids exist
      if (userIds.isNotEmpty) {
        final usersResponse = await supabase
            .from('tbl_users')
            .select('user_id, name, email')
            .inFilter('user_id', userIds);

        debugPrint('======== USERS RESPONSE ========');
        debugPrint('$usersResponse');
        debugPrint('================================');

        // Step 4: Create a map with user_id as key (FIX: handle nullable String)
        for (var u in usersResponse as List) {
          final userId = u['user_id']?.toString().trim();
          if (userId != null && userId.isNotEmpty) {
            usersMap[userId] = u;
          }
        }

        debugPrint('======== USERS MAP ========');
        debugPrint('$usersMap');
        debugPrint('===========================');
      } else {
        debugPrint('⚠️ No valid user_ids found');
      }

      // Step 5: Merge chat and user data
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

      debugPrint('======== FINAL CHATS ========');
      debugPrint('Total chats: ${chats.length}');
      debugPrint('$chats');
      debugPrint('=============================');
      
    } catch (e, stackTrace) {
      debugPrint('❌ Chat fetch error: $e');
      debugPrint('Stack trace: $stackTrace');
      chats = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshChats() => fetchChats();
}