import 'package:ai_core_health/core/services/auth_service.dart';
import 'package:ai_core_health/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

class AppBootstrapState {
  const AppBootstrapState({
    required this.firebaseConfigured,
    required this.signedIn,
  });

  final bool firebaseConfigured;
  final bool signedIn;
}

class AppBootstrap {
  AppBootstrap._();

  static final AppBootstrap instance = AppBootstrap._();

  Future<AppBootstrapState> initialize() async {
    if (!DefaultFirebaseOptions.isConfigured) {
      return const AppBootstrapState(
        firebaseConfigured: false,
        signedIn: false,
      );
    }

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    return AppBootstrapState(
      firebaseConfigured: true,
      signedIn: AuthService.instance.currentUser != null,
    );
  }
}
