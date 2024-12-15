import 'dart:math';

class OtpGenerator {
  // Function to generate a 6-digit OTP
  String generateOtp() {
    final random = Random();
    int otp = random.nextInt(900000) + 100000;  // Generates a 6-digit number
    return otp.toString();
  }
}
