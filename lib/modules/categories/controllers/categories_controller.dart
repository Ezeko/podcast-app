import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/podcast_repository.dart';

enum CategoriesState { loading, success, empty, error }

class CategoriesController extends GetxController {
  final PodcastRepository _podcastRepository = PodcastRepository();
  
  final Rx<CategoriesState> state = CategoriesState.loading.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxString errorMessage = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
  
  Future<void> fetchCategories() async {
    try {
      state.value = CategoriesState.loading;
      errorMessage.value = '';
      
      final result = await _podcastRepository.getCategories();
      
      if (result.isEmpty) {
        state.value = CategoriesState.empty;
      } else {
        categories.value = result;
        state.value = CategoriesState.success;
      }
    } catch (e) {
      // print('❌ CategoriesController: Error fetching categories: $e');
      errorMessage.value = _parseError(e);
      state.value = CategoriesState.error;
    }
  }
  
  String _parseError(dynamic e) {
    if (e.toString().contains('401')) {
      return 'Please log in again to continue';
    } else if (e.toString().contains('network')) {
      return 'No internet connection';
    }
    return 'Unable to load categories';
  }
}
