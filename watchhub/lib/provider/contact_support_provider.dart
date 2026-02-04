import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactSupportProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _userMessages = [];
  String _userEmail = '';
  String _userName = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get userMessages => _userMessages;
  String get userEmail => _userEmail;
  String get userName => _userName;

  Future<void> fetchUserDetails() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('tbl_users')
          .select('name, email')
          .eq('user_id', user.id)
          .single();

      _userName = response['name'] ?? '';
      _userEmail = response['email'] ?? '';
      notifyListeners();
    } catch (e) {
      _userName = '';
      _userEmail = '';
      notifyListeners();
    }
  }

  Future<bool> submitMessage({
    required String fullName,
    required String message,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final user = _supabase.auth.currentUser;
      if (user == null) {
        _errorMessage = 'User not logged in';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _supabase.from('tbl_chatsupport').insert({
        'user_id': user.id,
        'full_name': fullName.trim(),
        'message': message.trim(),
      });

      _isLoading = false;
      notifyListeners();

      await fetchUserMessages();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to send message: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchUserMessages() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      final user = _supabase.auth.currentUser;
      if (user == null) {
        _errorMessage = 'User not logged in';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _supabase
          .from('tbl_chatsupport')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      _userMessages = List<Map<String, dynamic>>.from(response);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch messages: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}