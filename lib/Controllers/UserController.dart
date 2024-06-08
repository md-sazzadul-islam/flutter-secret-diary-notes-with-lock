import 'package:secret_diary/model/User.dart';
import 'package:secret_diary/repositories/UserRepository.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var allUser = <User>[].obs;
  UserRepository userRepository = UserRepository();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllUser();
  }

  fetchAllUser() async {
    var user = await userRepository.getUser();
    allUser.value = user;
  }

  addUser(User user) {
    userRepository.add(user);
    fetchAllUser();
  }

  updateUser(User user) {
    userRepository.update(user);
    fetchAllUser();
  }

  deleteUser(int id) {
    userRepository.delete(id);
    fetchAllUser();
  }
}
