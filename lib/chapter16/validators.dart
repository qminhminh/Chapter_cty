import 'dart:async';

class Validators {
  // Phương thức validate email
  static final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if (email.contains('@') && email.contains('.')) {
        sink.add(email); // Nếu email hợp lệ
      } else {
        sink.addError('Email không hợp lệ');
      }
    },
  );

  // Phương thức validate password
  static final validatePassword =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length >= 6) {
        sink.add(password); // Nếu mật khẩu hợp lệ
      } else {
        sink.addError('Mật khẩu phải có ít nhất 6 ký tự');
      }
    },
  );
}
