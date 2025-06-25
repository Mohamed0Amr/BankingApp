import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class MailService {
  static Future<bool> sendOtpEmail(String email, String otp) async {
    final username = 'your_email@example.com';
    final password = 'your_email_password';
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your App')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP code is: $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Message not sent: $e');
      return false;
    }
  }
}
