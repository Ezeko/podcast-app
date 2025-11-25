import '../models/podcast_model.dart';
import '../models/episode_model.dart';
import '../models/category_model.dart';
import '../providers/api_provider.dart';

class PodcastRepository {
  final ApiProvider _apiProvider = ApiProvider();
  
  Future<List<EpisodeModel>> getTrendingEpisodes() async {
    try {
      // print('🔵 Fetching trending episodes...');
      final response = await _apiProvider.get('/api/episodes/trending');
      return _parseEpisodeResponse(response);
    } catch (e) {
      // print('❌ Get trending episodes error: $e');
      rethrow;
    }
  }

  Future<List<EpisodeModel>> getEditorPickEpisodes() async {
    try {
      // print('🔵 Fetching editor pick episodes...');
      final response = await _apiProvider.get('/api/episodes/editor-pick');
      return _parseEpisodeResponse(response);
    } catch (e) {
      // print('❌ Get editor pick episodes error: $e');
      rethrow;
    }
  }

  Future<List<EpisodeModel>> getLatestEpisodes() async {
    try {
      // print('🔵 Fetching latest episodes...');
      final response = await _apiProvider.get('/api/episodes/latest');
      return _parseEpisodeResponse(response);
    } catch (e) {
      // print('❌ Get latest episodes error: $e');
      rethrow;
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      // print('🔵 Fetching categories...');
      final response = await _apiProvider.get('/api/categories');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        // print('🔵 Raw Categories Data: $data');
        
        List<dynamic> list = [];
        
        // Handle nested structure if present
        if (data is Map) {
          if (data['data'] is List) {
             list = data['data'];
          } else if (data['categories'] is List) {
             list = data['categories'];
          }
        } else if (data is List) {
          list = data;
        }
        
        return list.map((item) => CategoryModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusMessage}');
      }
    } catch (e) {
      // print('❌ Get categories error: $e');
      rethrow;
    }
  }

  List<EpisodeModel> _parseEpisodeResponse(dynamic response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      // print('🔵 Raw Data: $data');
      
      List<dynamic> list = [];
      
      // Handle triple-nested structure if present
      if (data is Map) {
        if (data['data'] is Map && data['data']['data'] is Map && data['data']['data']['data'] is List) {
           list = data['data']['data']['data'];
        } else if (data['data'] is Map && data['data']['data'] is List) {
           list = data['data']['data'];
        } else if (data['data'] is List) {
           list = data['data'];
        } else if (data['data'] is Map && data['data']['data'] is Map) {
           // Handle single object in data.data (e.g. Editor's Pick)
           list = [data['data']['data']];
        } else if (data['data'] is Map) {
           // Handle single object in data
           list = [data['data']];
        }
      } else if (data is List) {
        list = data;
      }
      
      return list.map((item) => EpisodeModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load episodes: ${response.statusMessage}');
    }
  }
  
  Future<PodcastModel> getPodcastById(String podcastId) async {
    try {
      final response = await _apiProvider.get('/api/jollycasts/$podcastId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map) {
          // If wrapped in a data field
          if (data['data'] != null) {
            return PodcastModel.fromJson(Map<String, dynamic>.from(data['data']));
          }
          return PodcastModel.fromJson(Map<String, dynamic>.from(data));
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load podcast: ${response.statusMessage}');
      }
    } catch (e) {
      // print('Get podcast error: $e');
      rethrow;
    }
  }
  
  Future<EpisodeModel> getEpisodeById(String episodeId) async {
    try {
      final response = await _apiProvider.get('/api/episodes/$episodeId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map) {
          // If wrapped in a data field
          if (data['data'] != null) {
            return EpisodeModel.fromJson(Map<String, dynamic>.from(data['data']));
          }
          return EpisodeModel.fromJson(Map<String, dynamic>.from(data));
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load episode: ${response.statusMessage}');
      }
    } catch (e) {
      // print('Get episode error: $e');
      rethrow;
    }
  }
}
