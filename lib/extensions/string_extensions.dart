extension PasswordValidation on String {
  bool isValidPassword() {
    return passwordPattern.hasMatch(this);
  }

  bool isValidUsername() {
    return usernamePattern.hasMatch(this);
  }
}

final passwordPattern = RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]{6,20}$');
final usernamePattern = RegExp(r'^[a-zA-Z0-9]{4,12}$');
