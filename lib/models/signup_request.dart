class SignUpRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirm;
  final String accountType; // 'user' or 'employer'
  final String? companyName;
  final String? website;

  SignUpRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.accountType,
    this.companyName,
    this.website,
  });

  // For Professional Signup
  Map<String, dynamic> toUserJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "passwordConfirm": passwordConfirm,
      "accountType": "user", // MUST BE PRESENT
    };
  }

  // For Company Signup
  Map<String, dynamic> toCompanyJson() {
    return {
      "company": {"name": companyName, "domain": website},
      "representative": {
        "full_name": name,
        "email": email,
        "password": password,
        "passwordConfirm": passwordConfirm,
        "accountType": "employer", // MUST BE PRESENT
      },
    };
  }
}
