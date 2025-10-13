class CountryCodeList {
  int? codeId;
  String? countryName;
  int? countryCode;
  int? countryDigit;
  int? hide;

  CountryCodeList(
      {this.codeId,
      this.countryName,
      this.countryCode,
      this.countryDigit,
      this.hide});

  CountryCodeList.fromJson(Map<String, dynamic> json) {
    codeId = json['code_id'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    countryDigit = json['country_digit'];
    hide = json['hide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code_id'] = this.codeId;
    data['country_name'] = this.countryName;
    data['country_code'] = this.countryCode;
    data['country_digit'] = this.countryDigit;
    data['hide'] = this.hide;
    return data;
  }
}
