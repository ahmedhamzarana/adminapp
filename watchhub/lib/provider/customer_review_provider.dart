import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerReviewProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _userFeedbacks = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get userFeedbacks => _userFeedbacks;

  Future<bool> submitFeedback({
    required String feedbackText,
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

      await _supabase.from('tbl_feedback').insert({
        'user_id': user.id,
        'feedback_text': feedbackText.trim(),
      });

      _isLoading = false;
      notifyListeners();
      
      await fetchUserFeedbacks();
      
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit feedback: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchUserFeedbacks() async {
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
          .from('tbl_feedback')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      _userFeedbacks = List<Map<String, dynamic>>.from(response);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch feedbacks: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}