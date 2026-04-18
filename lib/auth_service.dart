import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  SupabaseClient get _supabase => Supabase.instance.client;

  // 1. INITIALIZE ACCOUNT (Sign Up + Save Profile)
  Future<AuthResponse> signUp({required String email, required String password, required String fullName}) async {
    // Step A: Create the secure auth user
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    // Step B: If successful, create their public profile in the database
    if (response.user != null) {
      await _supabase.from('profiles').insert({
        'id': response.user!.id,
        'full_name': fullName,
        'email': email,
      });
    }

    return response;
  }

  // 2. AUTHENTICATE (Login)
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // 3. TERMINATE SESSION (Sign Out)
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Check who is currently logged in
  User? get currentUser => _supabase.auth.currentUser;
}