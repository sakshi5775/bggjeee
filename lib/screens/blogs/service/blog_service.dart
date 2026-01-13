import 'package:astrobharataiuser/apihelper/api_provider/end_points.dart';
import 'package:astrobharataiuser/apihelper/repositories/apirepository.dart';
import 'package:astrobharataiuser/core/base/api_helper_mixin.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/data_model/comment_model.dart';
import 'package:get/get.dart';

class BlogService with ApiHelperMixin {
  final ApiRepository _apiRepository = Get.find();

  Future<BlogResponse?> getBlogs({
    int page = 1,
    String? status,
    String? search,
    String? category,
    bool useAuthHeader = true,
  }) async {
    print('EndPoints.blogs: ${EndPoints.blogs}');
    try {
      final queryParams = <String, dynamic>{
        'page': page.toString(),
      };

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

      print('response: ${response.body}');
      if (response.body['success'] == true) {
        return BlogResponse.fromJson(response.body);
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to fetch blogs. Please try again.",
        );
        return null;
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: e.toString());
      return null;
    }
  }

  Future<Blog?> createBlog(CreateBlogRequest request) async {
    try {
      final response = await _apiRepository.postApi(
        EndPoints.blogs,
        request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Blog.fromJson(response.body['data']);
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to create blog. Please try again.",
        );
        return null;
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: e.toString());
      return null;
    }
  }

  Future<Blog?> updateBlog(String blogId, CreateBlogRequest request) async {
    try {
      final response = await _apiRepository.postApi(
        '${EndPoints.blogs}/$blogId',
        request.toJson(),
      );

      if (response.statusCode == 200) {
        return Blog.fromJson(response.body['data']);
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to update blog. Please try again.",
        );
        return null;
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: e.toString());
      return null;
    }
  }

  Future<bool> deleteBlog(String blogId) async {
    try {
      final response = await _apiRepository.postApi(
        '${EndPoints.blogs}/$blogId',
        {},
      );

      if (response.statusCode == 200) {
        showSuccessMessage(
          title: "Success",
          message: "Blog deleted successfully!",
        );
        return true;
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to delete blog. Please try again.",
        );
        return false;
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: e.toString());
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getCategories() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.categories);

      if (response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        return data
            .map((category) => Map<String, dynamic>.from(category))
            .toList();
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to fetch categories. Please try again.",
        );
        return null;
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getTags() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.tags);

      if (response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        return data.map((tag) => Map<String, dynamic>.from(tag)).toList();
      } else {
        showErrorMessage(
          title: "Error",
          message: "Failed to fetch tags. Please try again.",
        );
        return null;
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getPopularTags() async {
    try {
      final response = await _apiRepository.getApi(EndPoints.popularTags);
      if (response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        return data.map((tag) => Map<String, dynamic>.from(tag)).toList();
      }
      return [];
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>?> getTagBySlug(String slug) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.tagBySlug(slug));
      if (response.body['success'] == true) {
        return Map<String, dynamic>.from(response.body['data']);
      }
      return null;
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getBlogReactions(String blogId) async {
    try {
      final response = await _apiRepository.getApi(EndPoints.blogReactions(blogId));
      if (response.body['success'] == true) {
        final List<dynamic> data = response.body['data'];
        return data.map((reaction) => Map<String, dynamic>.from(reaction)).toList();
      }
      return [];
    } catch (e) {
      // Don't show error for reactions, just return empty list
      return [];
    }
  }
}

extension BlogComments on BlogService {
  Future<List<Comment>> getComments(String blogId) async {
    try {
      final response = await _apiRepository.getApi(
        EndPoints.blogComments(blogId),
      );
      if (response.body['success'] == true) {
        return CommentResponse.fromJson(response.body).data;
      }
      return [];
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
      return [];
    }
  }

  Future<bool> addComment({
    required String blogId,
    required String content,
    String? parentId,
  }) async {
    try {
      final body = {
        'content': content,
        if (parentId != null) 'parentComment': parentId,
      };
      final response = await _apiRepository.postApi(
        EndPoints.blogComments(blogId),
        body,
      );
      return response.body['success'] == true;
    } catch (e) {
      showErrorMessage(title: 'Error', message: e.toString());
      return false;
    }
  }
}
