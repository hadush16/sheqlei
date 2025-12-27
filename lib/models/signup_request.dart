class SignUpRequest {
  final bool isCompany;
  final String name;
  final String email;
  final String password;

  // Company only
  final String? companyName;
  final String? website;
  final String? representative;

  SignUpRequest({
    required this.isCompany,
    required this.name,
    required this.email,
    required this.password,
    this.companyName,
    this.website,
    this.representative,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": isCompany ? "company" : "professional",
      "name": name,
      "email": email,
      "password": password,
      if (isCompany) ...{
        "company_name": companyName,
        "website": website,
        "representative": representative,
      },
    };
  }
}
