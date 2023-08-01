class RegisterScreenData {
  String? mobileNumber;
  String? otp;
  String? firstName;
  String? lastName;
  String? email;
  String? password;

  RegisterScreenData(
      {this.mobileNumber,
      this.otp,
      this.firstName,
      this.lastName,
      this.email,
      this.password});

  RegisterScreenData copyWith(
      {String? mobileNumber,
      String? otp,
      String? firstName,
      String? lastName,
      String? email,
      String? password}) {
    return RegisterScreenData(
        mobileNumber: mobileNumber ?? this.mobileNumber,
        otp: otp ?? this.otp,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        password: password ?? this.password);
  }

  bool get isNotValid =>
      mobileNumber == null ||
      otp == null ||
      (firstName ?? '').isEmpty ||
      (lastName ?? '').isEmpty ||
      (email ?? '').isEmpty ||
      (password ?? '').isEmpty;
}

class ChangePasswordData {
  String? otp;
  String? newPassword;
  String? confirmPassword;
  bool invalidOtp;

  ChangePasswordData(
      {this.otp,
      this.newPassword,
      this.confirmPassword,
      this.invalidOtp = false});

  ChangePasswordData copyWith(
      {String? otp, String? newPassword, String? confirmPassword}) {
    return ChangePasswordData(
        otp: otp ?? this.otp,
        newPassword: newPassword ?? this.newPassword,
        confirmPassword: confirmPassword ?? this.confirmPassword);
  }

  bool get isNotValid =>
      otp == null ||
      (newPassword ?? '').isEmpty ||
      (confirmPassword ?? '').isEmpty;
}

class ResetPasswordData {
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  ResetPasswordData({
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
  });

  ResetPasswordData copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) {
    return ResetPasswordData(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  bool get enableButton =>
      (currentPassword ?? '').isNotEmpty &&
      (newPassword ?? '').isNotEmpty &&
      (confirmPassword ?? '').isNotEmpty;
}
