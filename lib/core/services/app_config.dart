class AppConfig {
  static const String anthropicApiKey = String.fromEnvironment(
    'CLAUDE_API_KEY',
    defaultValue: '',
  );

  static bool get hasAnthropicKey => anthropicApiKey.isNotEmpty;
}
