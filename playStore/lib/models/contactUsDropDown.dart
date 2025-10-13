class ContactUsDropDownList {
  int? id;
  String? type;
  String? imageRequired;
  String? addedBy;
  String? addedOn;

  ContactUsDropDownList(
      {this.id, this.type, this.imageRequired, this.addedBy, this.addedOn});

  ContactUsDropDownList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    imageRequired = json['required'];
    addedBy = json['added_by'];
    addedOn = json['added_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['required'] = this.imageRequired;
    data['added_by'] = this.addedBy;
    data['added_on'] = this.addedOn;
    return data;
  }
}
