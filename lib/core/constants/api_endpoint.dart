

class ApiEndpoints {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api'
  );

//   ================= TODO ENDPOINT ====================
static const String todos = '/todo';
}