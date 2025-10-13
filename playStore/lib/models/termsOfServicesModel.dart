class TermsOfService {
  TermsOfService({
    this.termsId,
    this.title,
    this.description,
  });

  int? termsId;
  String? title;
  String? description;

  factory TermsOfService.fromJson(Map<String, dynamic> json) => TermsOfService(
        termsId: int.parse(json["terms_id"].toString()),
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "terms_id": termsId,
        "title": title,
        "description": description,
      };
}

class DeleteMyAccount {
  String? status;
  String? message;
  DeleteMyAccount({
    this.status,
    this.message,
  });
  factory DeleteMyAccount.fromJson(Map<String, dynamic> json) =>
      DeleteMyAccount(
        status: json["status"],
        message: json["message"],
      );
}
