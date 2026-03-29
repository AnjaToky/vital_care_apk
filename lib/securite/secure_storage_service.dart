import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const keyName = 'secure_note_app';

  String? _cachedKey;
  Future<String>? _creatingKey;

  /// Retourne la clé existante ou en crée une nouvelle (32 octets, Base64).
  /// Protége contre les appels concurrents en réutilisant la même Future de création.
  Future<String> getOrCreateKey() async {
    if (_cachedKey != null) return _cachedKey!;
    if (_creatingKey != null) return await _creatingKey!;

    _creatingKey = _doGetOrCreateKey();
    try {
      final key = await _creatingKey!;
      _cachedKey = key;
      return key;
    } finally {
      _creatingKey = null;
    }
  }

  Future<String> _doGetOrCreateKey() async {
    final existing = await _storage.read(
      key: keyName,
      aOptions: _androidOptions(),
      iOptions: _iosOptions(),
    );
    if (existing != null && existing.isNotEmpty) return existing;

    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final newKey = base64Encode(bytes);

    await _storage.write(
      key: keyName,
      value: newKey,
      aOptions: _androidOptions(),
      iOptions: _iosOptions(),
    );
    return newKey;
  }

  /// Supprime la clé stockée et la met aussi à jour en cache.
  Future<void> deleteKey() async {
    await _storage.delete(
      key: keyName,
      aOptions: _androidOptions(),
      iOptions: _iosOptions(),
    );
    _cachedKey = null;
  }

  AndroidOptions _androidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  IOSOptions _iosOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);
}
