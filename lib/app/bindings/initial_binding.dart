import 'package:get/get.dart';
import '../../shared/utils/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    // Initialize storage
    await StorageService.init();
  }
}
