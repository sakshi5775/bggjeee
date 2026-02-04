import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/data_model/comment_model.dart';
import 'package:get/get.dart';

class BlogService {
  final ApiRepository _apiRepository = Get.find();

  Future<BlogResponse?> getBlogs({
    int page = 1,
    String? status,
    String? search,
    String? category,
    bool useAuthHeader = true,
  }) async {
    final queryParams = <String, dynamic>{'page': page.toString()};

    if (status != null && status.isNotEmpty && status != 'all') {
      queryParams['status'] = status;
    }

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    if (category != null && category.isNotEmpty && category != 'all') {
      queryParams['category'] = category;
    }

    final response = await _apiRepository.getApi(
      EndPoints.blogs,
      query: queryParams,
      useAuthHeader: useAuthHeader,
    );

    if (response.body['success'] == true) {
      return BlogResponse.fromJson(response.body);
    }

    throw response.body?['message']?.toString() ?? 'Failed to fetch blogs';
  }

  Future<Blog?> createBlog(CreateBlogRequest request) async {
    final response = await _apiRepository.postApi(
      EndPoints.blogs,
      request.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Blog.fromJson(response.body['data']);
    }

    throw response.body?['message']?.toString() ?? 'Failed to create blog';
  }

  Future<Blog?> updateBlog(String blogId, CreateBlogRequest request) async {
    final response = await _apiRepository.postApi(
      '${EndPoints.blogs}/$blogId',
      request.toJson(),
    );

    if (response.statusCode == 200) {
      return Blog.fromJson(response.body['data']);
    }

    throw response.body?['message']?.toString() ?? 'Failed to update blog';
  }

  Future<bool> deleteBlog(String blogId) async {
    final response = await _apiRepository.postApi(
      '${EndPoints.blogs}/$blogId',
      {},
    );

    if (response.statusCode == 200) {
      return true;
    }

    throw response.body?['message']?.toString() ?? 'Failed to delete blog';
  }

  Future<List<Map<String, dynamic>>?> getCategories() async {
    final response = await _apiRepository.getApi(EndPoints.categories);

    if (response.body['success'] == true) {
      final List<dynamic> data = response.body['data'];
      return data
          .map((category) => Map<String, dynamic>.from(category))
          .toList();
    }

    throw response.body?['message']?.toString() ?? 'Failed to fetch categories';
  }

  Future<List<Map<String, dynamic>>?> getTags() async {
    final response = await _apiRepository.getApi(EndPoints.tags);

    if (response.body['success'] == true) {
      final List<dynamic> data = response.body['data'];
      return data.map((tag) => Map<String, dynamic>.from(tag)).toList();
    }

    throw response.body?['message']?.toString() ?? 'Failed to fetch tags';
  }

  Future<List<Map<String, dynamic>>?> getPopularTags() async {
    final response = await _apiRepository.getApi(EndPoints.popularTags);
    if (response.body['success'] == true) {
      final List<dynamic> data = response.body['data'];
      return data.map((tag) => Map<String, dynamic>.from(tag)).toList();
    }

    throw response.body?['message']?.toString() ??
        'Failed to fetch popular tags';
  }

  Future<Map<String, dynamic>?> getTagBySlug(String slug) async {
    final response = await _apiRepository.getApi(EndPoints.tagBySlug(slug));
    if (response.body['success'] == true) {
      return Map<String, dynamic>.from(response.body['data']);
    }

    throw response.body?['message']?.toString() ?? 'Failed to fetch tag';
  }

  Future<List<Map<String, dynamic>>?> getBlogReactions(String blogId) async {
    final response = await _apiRepository.getApi(
      EndPoints.blogReactions(blogId),
    );
    if (response.body['success'] == true) {
      final List<dynamic> data = response.body['data'];
      return data
          .map((reaction) => Map<String, dynamic>.from(reaction))
          .toList();
    }
    return [];
  }
}

extension BlogComments on BlogService {
  Future<List<Comment>> getComments(String blogId) async {
    final response = await _apiRepository.getApi(
      EndPoints.blogComments(blogId),
    );
    if (response.body['success'] == true) {
      return CommentResponse.fromJson(response.body).data;
    }

    throw response.body?['message']?.toString() ?? 'Failed to fetch comments';
  }

  Future<bool> addComment({
    required String blogId,
    required String content,
    String? parentId,
  }) async {
    final body = {
      'content': content,
      if (parentId != null) 'parentComment': parentId,
    };
    final response = await _apiRepository.postApi(
      EndPoints.blogComments(blogId),
      body,
    );

    if (response.body['success'] == true) {
      return true;
    }

    throw response.body?['message']?.toString() ?? 'Failed to add comment';
  }
}
