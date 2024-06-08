import 'package:secret_diary/model/Passcode.dart';
import 'package:secret_diary/repositories/PasscodeRepository.dart';
import 'package:get/get.dart';

class PasscodeController extends GetxController {
  var allPasscode = <Passcode>[].obs;
  PasscodeRepository passcodeRepository = PasscodeRepository();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllPasscode();
  }

  fetchAllPasscode() async {
    var passcode = await passcodeRepository.getPasscode();
    allPasscode.value = passcode;
  }

  addPasscode(Passcode passcode) {
    passcodeRepository.add(passcode);
    fetchAllPasscode();
  }

  updatePasscode(Passcode passcode) {
    passcodeRepository.update(passcode);
    fetchAllPasscode();
  }

  deletePasscode(int id) {
    passcodeRepository.delete(id);
    fetchAllPasscode();
  }
}
