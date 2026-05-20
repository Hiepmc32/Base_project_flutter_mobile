class TimeOTP {
  // Chu kỳ smartotp: 60s
  static const int smartOtpInterval = 60;

  // Lấy thời gian còn lại của mã OTP
  int get remainSeconds => getRemainSeconds();

  // Lấy thời gian còn lại của mã OTP
  int getRemainSeconds() {
    final int time = DateTime.now().millisecondsSinceEpoch;
    final int remainSeconds =
        smartOtpInterval -
        (((time ~/ 1000).round()) % smartOtpInterval).floor();
    return remainSeconds;
  }
}
