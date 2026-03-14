import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'REVENUECAT_IOS_API_KEY', obfuscate: true, defaultValue: '')
  static final String revenuecatIosApiKey = _Env.revenuecatIosApiKey;

  @EnviedField(varName: 'REVENUECAT_ANDROID_API_KEY', obfuscate: true, defaultValue: '')
  static final String revenuecatAndroidApiKey = _Env.revenuecatAndroidApiKey;
}
