import 'main.dart';
import 'utils/flavour_config.dart';

Future<void> main() async {
  FlavourConstants.setEnvironment(Environment.stage);
  await initializeApp();
}
