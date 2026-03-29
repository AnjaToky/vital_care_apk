import 'package:encrypt/encrypt.dart';
import 'package:vital_care/securite/secure_storage_service.dart';

class EncryptService {
  final SecureStorageService storageService;
  late final Key key;

  EncryptService._(this.storageService);

  /// Use this factory to ensure the key is loaded before using the service.
  static Future<EncryptService> create(
    SecureStorageService storageService,
  ) async {
    final s = EncryptService._(storageService);
    await s._initKey();
    return s;
  }

  Future<void> _initKey() async {
    final keyString = await storageService.getOrCreateKey();
    key = Key.fromBase64(keyString);
  }

  /// Encrypts and prefixes the IV to the ciphertext as `ivBase64:cipherBase64`.
  String encrypt(String plainText) {
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  /// Decrypts a payload encoded as `ivBase64:cipherBase64`.
  String decrypt(String encryptedText) {
    final parts = encryptedText.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid encrypted payload');
    }
    final iv = IV.fromBase64(parts[0]);
    final cipher = parts[1];
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(cipher, iv: iv);
    return decrypted;
  }
}
