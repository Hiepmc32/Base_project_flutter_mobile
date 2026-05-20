import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Validates server leaf certificate fingerprints.
class SslPinningValidator {
  SslPinningValidator({
    required List<String> pinnedValues,
    required List<String> pinnedHosts,
  }) : _hexPins = _buildHexPins(pinnedValues),
       _base64Pins = _buildBase64Pins(pinnedValues),
       _hosts =
           pinnedHosts
               .map((String host) => host.trim().toLowerCase())
               .where((String host) => host.isNotEmpty)
               .toSet();

  final Set<String> _hexPins;
  final Set<String> _base64Pins;
  final Set<String> _hosts;

  bool get hasPins => _hexPins.isNotEmpty || _base64Pins.isNotEmpty;

  bool validate(X509Certificate? certificate, String host, int port) {
    if (certificate == null) {
      return false;
    }

    if (!_shouldValidateHost(host)) {
      return true;
    }

    final Digest digest = sha256.convert(certificate.der);
    final String hexValue = digest.toString().toLowerCase();
    final String base64Value = base64.encode(digest.bytes);

    return _hexPins.contains(hexValue) || _base64Pins.contains(base64Value);
  }

  bool _shouldValidateHost(String host) {
    if (_hosts.isEmpty) {
      return true;
    }

    final String normalizedHost = host.trim().toLowerCase();
    for (final String pattern in _hosts) {
      if (pattern.startsWith('*.')) {
        final String suffix = pattern.substring(1);
        if (normalizedHost.endsWith(suffix)) {
          return true;
        }
        continue;
      }

      if (normalizedHost == pattern) {
        return true;
      }
    }

    return false;
  }

  static Set<String> _buildHexPins(List<String> values) {
    final Set<String> result = <String>{};
    for (final String rawValue in values) {
      final String value = rawValue.trim();
      if (_isSha256Hex(value)) {
        result.add(value.toLowerCase());
      }
    }
    return result;
  }

  static Set<String> _buildBase64Pins(List<String> values) {
    final Set<String> result = <String>{};
    for (final String rawValue in values) {
      final String value = rawValue.trim();
      if (value.isEmpty) {
        continue;
      }

      if (value.startsWith('sha256/')) {
        final String base64Part = value.substring(7).trim();
        if (base64Part.isNotEmpty) {
          result.add(base64Part);
        }
        continue;
      }

      if (!_isSha256Hex(value)) {
        result.add(value);
      }
    }
    return result;
  }

  static bool _isSha256Hex(String value) {
    final RegExp regex = RegExp(r'^[a-fA-F0-9]{64}$');
    return regex.hasMatch(value);
  }
}
