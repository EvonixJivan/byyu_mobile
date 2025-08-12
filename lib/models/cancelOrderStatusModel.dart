class CancelStatusListModel {
  String? reason;
  int? res_id, isStatusSelected = 0;

  CancelStatusListModel();
  CancelStatusListModel.fromJson(Map<String, dynamic> json) {
    try {
      reason = json['reason'] != null ? json['reason'] : '';
      res_id = json['res_id'];
    } catch (e) {
      print("Exception - cancelorderreason.fromJson():" + e.toString());
    }
  }
}
