import 'package:get/get.dart';
import 'package:byyu/models/addressModel.dart';
import 'package:byyu/models/businessLayer/apiHelper.dart';
import 'package:byyu/models/businessLayer/global.dart' as global;
import 'package:byyu/models/userModel.dart';

class UserProfileController extends GetxController {
  APIHelper apiHelper = new APIHelper();
  late CurrentUser currentUser;
  List<Address1> addressList = [];
  var isDataLoaded = false.obs;
  var isAddressDataLoaded = false.obs;

  getMyProfile() async {
    try {
      isDataLoaded(false);
      await apiHelper.myProfile().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            currentUser = result.data;
            global.currentUser = currentUser;
          } 
        }
      });
      isDataLoaded(true);
      update();
    } catch (e) {
      print("Exception - user_profile_controller.dart - _getMyProfile()a:" +
          e.toString());
    }
  }

  getUserAddressList() async {
    try {
      isAddressDataLoaded(false);
      await apiHelper.getAddressList().then((result) async {
        if (result != null) {
          if (result.status == "1") {
            addressList = result.data;
            global.addressList.clear();
            global.addressList.addAll(addressList);
            print("lgobal list ${global.addressList[0].toString()}");
          } else {
            addressList = [];
          }
        }
      });
      isAddressDataLoaded(true);
      update();
    } catch (e) {
      print(
          "Exception - user_profile_controller.dart - _init():" + e.toString());
    }
  }

  removeUserAddress(int index) async {}
}
