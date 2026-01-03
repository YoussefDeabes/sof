class ApiKeys {
  static const String baseUrl = "https://api.stackexchange.com/2.3";

  const ApiKeys._();

  /// Headers
  static const accept = "Accept";
  static const acceptLanguage = "Accept-Language";
  static const applicationJson = "application/json";
  static const contentType = "content-type";

  // StackExchange API endpoints
  static const String users = "$baseUrl/users";
}
