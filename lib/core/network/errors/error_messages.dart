class ErrorMessages {
  static const Map<String, Map<String, String>> errors = {
    "Internal server error": {
      "en": "Something went wrong. Please try again later.",
    },
    "No internet connection": {
      "en": "No internet connection",
    },
    "Unexpected error occurred": {
      "en": "Unexpected error occurred",
    },
    "Unexpected error": {
      "en": "Unexpected error occurred",
    },
     "Unauthorized": {
      "en": "Unauthorized request",
    },
    "Invalid": {
      "en": "Invalid request",
    },
  };

  static String getMessage(String backendMessage, String languageCode,
      {Map<String, String>? args}) {
    String message = errors[backendMessage]?[languageCode] ?? backendMessage;
    if (args != null) {
      args.forEach((key, value) {
        message = message.replaceAll('{$key}', value);
      });
    }
    return message;
  }
}

