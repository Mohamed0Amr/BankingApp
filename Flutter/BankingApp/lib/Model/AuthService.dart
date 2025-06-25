class AuthService {
  static String? _currentUserId;
  static String? _authToken;
  static DateTime? _tokenExpiry;

  // Getters
  static String? get currentUserId => _currentUserId;

  // ✅ Always return token if it's not null (no expiry check)
  static String? get token => _authToken;

  // Async getters
  static Future<String?> getCurrentUserId() async => _currentUserId;
  static Future<String?> getToken() async => _authToken;

  // Set authentication data (with optional expiry)
  static void setAuthData(String userId, String token, [int? expiresIn]) {
    _currentUserId = userId;
    _authToken = token;
    print('Auth data set - UserID: $userId, Token: ${token.substring(0, 10)}...');
    _tokenExpiry = expiresIn != null
        ? DateTime.now().add(Duration(seconds: expiresIn))
        : null;
  }

  // Clear authentication data
  static void clearAuthData() {
    _currentUserId = null;
    _authToken = null;
    _tokenExpiry = null;
  }

  // Optional: use this if you still want to check expiry elsewhere
  static bool get isTokenExpired =>
      _tokenExpiry != null && _tokenExpiry!.isBefore(DateTime.now());

  // Check if user is authenticated (no expiry check)
  static bool get isAuthenticated => _currentUserId != null && _authToken != null;
}
