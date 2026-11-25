import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'email_config.dart';

enum CodeCheck { ok, wrong, expired, tooMany }

/// Sends a 6-digit verification code by email (through EmailJS) and checks it.
/// The EmailJS template must use these variables: {{to_email}}, {{name}}, {{code}}.
class EmailVerifier {
  EmailVerifier._();

  static String? _code;
  static DateTime? _expires;
  static DateTime? _lastSent;
  static int _tries = 0;

  static const _validFor = Duration(minutes: 10);
  static const _cooldown = Duration(seconds: 30);
  static const _maxTries = 5;

  /// Seconds to wait before another code can be sent (0 = can send now).
  static int get waitSeconds {
    final last = _lastSent;
    if (last == null) return 0;
    final left = _cooldown.inSeconds - DateTime.now().difference(last).inSeconds;
    return left > 0 ? left : 0;
  }

  /// Generates a code and emails it. Returns false if the email could not be sent.
  static Future<bool> send(String email, String name) async {
    final code = (100000 + Random.secure().nextInt(900000)).toString();
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 15);
    try {
      final req = await client
          .postUrl(Uri.parse('https://api.emailjs.com/api/v1.0/email/send'))
          .timeout(const Duration(seconds: 15));
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({
        'service_id': kEmailJsServiceId,
        'template_id': kEmailJsTemplateId,
        'user_id': kEmailJsPublicKey,
        'template_params': {'to_email': email, 'name': name, 'code': code},
      }));
      final res = await req.close().timeout(const Duration(seconds: 20));
      await res.drain<void>();
      if (res.statusCode != 200) return false;
      _code = code;
      _expires = DateTime.now().add(_validFor);
      _lastSent = DateTime.now();
      _tries = 0;
      return true;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  static CodeCheck check(String entered) {
    if (_code == null || _expires == null) return CodeCheck.expired;
    if (DateTime.now().isAfter(_expires!)) {
      _code = null;
      return CodeCheck.expired;
    }
    if (_tries >= _maxTries) return CodeCheck.tooMany;
    if (entered.trim() == _code) {
      _code = null;
      return CodeCheck.ok;
    }
    _tries++;
    return CodeCheck.wrong;
  }
}
