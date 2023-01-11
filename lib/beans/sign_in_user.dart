class SignInUser {
  String? email;
  String username;
  String password;
  String? emailCode;
  SignInUser(
      {this.email,
      required this.username,
      required this.password,
      this.emailCode});
}
