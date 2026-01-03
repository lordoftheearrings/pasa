import 'package:supabase_flutter/supabase_flutter.dart';

class UserSessionService {
  final SupabaseClient _supabase;

  UserSessionService(this._supabase);

  Stream<Session?> get sessionStream =>
      _supabase.auth.onAuthStateChange.map((event) => event.session);

  Session? get currentSession => _supabase.auth.currentSession;

  Future<void> handleDeepLink(Uri uri) async {
    if (uri.fragment.isNotEmpty) {
      final fragmentParams = Uri.splitQueryString(uri.fragment);
      final refreshToken = fragmentParams['refresh_token'];

      if (refreshToken != null &&
          refreshToken.isNotEmpty &&
          _supabase.auth.currentSession == null) {
        await _supabase.auth.setSession(refreshToken);
      }
    }
  }

  Future<bool> hasProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select('id')
        .eq('id', userId)
        .maybeSingle();
    return response != null;
  }
}
