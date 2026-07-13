import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

/// Inicializa o Firebase sem impedir a abertura do app durante o setup local.
///
/// Após executar `flutterfire configure`, Android encontra as opções padrão no
/// `google-services.json`. Enquanto o arquivo não existir, [isAvailable]
/// permanece falso e o repositório usa as notícias embarcadas.
abstract final class FirebaseBootstrap {
  static bool isAvailable = false;

  static Future<void> initialize() async {
    try {
      final options = DefaultFirebaseOptions.currentPlatform;
      if (options.projectId == 'firebase-not-configured') return;
      await Firebase.initializeApp(options: options);
      isAvailable = Firebase.apps.isNotEmpty;
    } catch (_) {
      isAvailable = false;
    }
  }
}
