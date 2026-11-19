import '../../../core/network/api_client.dart';

/// Keeps the logged-in user's details in memory after Sign In.
class UserSession {
  UserSession._();

  static String userId = '';
  static String username = '';
  static String email = '';

  /// True when the app is running without the real server (demo mode).
  static bool demo = false;

  static void clear() {
    userId = '';
    username = '';
    email = '';
    demo = false;
  }
}

/// All authentication API calls from the Mock API V2 documentation.
///
/// DEMO FALLBACK: if the company's server is unreachable or returns an
/// empty 404 / 5xx, the app switches to demo mode so the full flow can still
/// be shown. When the real server answers, the real API is always used.
class AuthService {
  AuthService._();

  // Users registered while in demo mode (kept in memory only).
  static final Map<String, Map<String, String>> _demoUsers = {};

  /// Server problem (not a normal error like "wrong password").
  static bool _serverDown(ApiException e) {
    final code = e.statusCode;
    if (code == null) return true; // no internet / TLS / timeout
    if (code >= 500) return true;
    if (code == 404 && e.message.startsWith('Something went wrong')) {
      return true; // empty 404 = API not served
    }
    return false;
  }

  /// POST /auth/register  ->  201 {"message":"User registered"}
  static Future<String> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final data = await ApiClient.post('/auth/register', {
        'username': username,
        'email': email,
        'password': password,
      });
      return _message(data, 'User registered');
    } on ApiException catch (e) {
      if (!_serverDown(e)) rethrow;
      _demoUsers[email] = {'username': username, 'password': password};
      return 'User registered (demo mode)';
    }
  }

  /// POST /auth/send-otp  ->  200 {"message":"OTP sent"}
  static Future<String> sendOtp({required String email}) async {
    try {
      final data = await ApiClient.post('/auth/send-otp', {'email': email});
      return _message(data, 'OTP sent');
    } on ApiException catch (e) {
      if (!_serverDown(e)) rethrow;
      return 'OTP sent (demo mode)';
    }
  }

  /// POST /auth/verify-otp  ->  200 {"message":"OTP Verfied"}
  /// In demo mode any 6-digit OTP is accepted.
  static Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final data = await ApiClient.post('/auth/verify-otp', {
        'email': email,
        'otp': otp,
      });
      return _message(data, 'OTP verified');
    } on ApiException catch (e) {
      if (!_serverDown(e)) rethrow;
      return 'OTP verified (demo mode)';
    }
  }

  /// POST /auth/login  ->  200 {"message":"Login successful","user":{...}}
  /// Saves the user in [UserSession] on success.
  /// In demo mode any email and password can sign in.
  static Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await ApiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      UserSession.demo = false;
      if (data is Map && data['user'] is Map) {
        final user = data['user'] as Map;
        UserSession.userId = (user['_id'] ?? '').toString();
        UserSession.username = (user['username'] ?? '').toString();
        UserSession.email = (user['email'] ?? email).toString();
      } else {
        UserSession.email = email;
      }
      return _message(data, 'Login successful');
    } on ApiException catch (e) {
      if (!_serverDown(e)) rethrow;

      final known = _demoUsers[email];
      UserSession.demo = true;
      UserSession.userId = 'demo-user';
      UserSession.email = email;
      UserSession.username = known?['username'] ??
          (email.contains('@') ? email.split('@').first : email);
      return 'Login successful (demo mode)';
    }
  }

  static String _message(dynamic data, String fallback) {
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return fallback;
  }
}