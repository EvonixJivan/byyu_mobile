class DioResult<T> {
  int? statusCode;
  String? status;
  String? message;
  T? data;

  DioResult({this.statusCode, this.data, this.status});
  DioResult.fromJson(dynamic response, T recordList) {
    try {
      status = response.data['status'].toString();
      message = response.data['message'];
      statusCode = response.statusCode;
      data = recordList;
    } catch (e) {
      print(
          "Exception - dioResult.dart - DioResult.fromJson():" + e.toString());
    }
  }
}

class DioResultExtra<T> {
  int? statusCode;
  String? status;
  String? message;
  dynamic extraValue;
  T? data;

  DioResultExtra({this.statusCode, this.data, this.status, this.extraValue});
  DioResultExtra.fromJson(dynamic response, T recordList) {
    try {
      status = response.data['status'].toString();
      message = response.data['message'];
      statusCode = response.statusCode;
      extraValue = response;
      data = recordList;
    } catch (e) {
      print(
          "Exception - dioResult.dart - DioResult.fromJson():" + e.toString());
    }
  }
}
