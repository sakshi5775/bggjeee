import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/blog_model.dart';
import 'package:astrobharataiuser/screens/blogs/service/blog_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBlogsController extends BaseController {
  final BlogService _blogService = BlogService();
  final BannerService _bannerService = BannerService();

  final RxList<Blog> blogs = <Blog>[].obs;
  final RxList<Blog> featuredBlogs = <Blog>[].obs;
  final RxList<BannerItem> blogBanners = <BannerItem>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxString selectedCategory = 'all'.obs;
  final RxString selectedFilter = 'all'.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxBool isSearching = false.obs;

  late PageController featuredPageController;

  final List<String> filterOptions = [
    'all',
    'published',
    'draft',
    'under_review',
  ];

  @override
  void onInit() {
    super.onInit();
    featuredPageController = PageController(viewportFraction: 0.85);
    loadCategories();
    loadBlogs();
    loadBanners();
  }

  @override
  void onClose() {
    featuredPageController.dispose();
    super.onClose();
  }

  void onFeaturedPageChanged(int index) {
    // Track page changes if needed in the future
  }

  Future<void> loadCategories() async {
    try {
      final categoriesList = await _blogService.getCategories();
      if (categoriesList != null) {
        categories.value = categoriesList;
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> loadBanners() async {
    try {
      var list = await _bannerService.getBannersByCategory('appblog');
      if (list.isEmpty) {
        list = await _bannerService.getBannersByCategory('blogs');
      }
      blogBanners.assignAll(list);
    } catch (e) {
      debugPrint('Error loading blog banners: $e');
    }
  }

  Future<void> loadBlogs({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        blogs.clear();
        hasMoreData.value = true;
      }

      if (!hasMoreData.value) return;

      setLoadingState(true);

      final response = await _blogService.getBlogs(
        page: currentPage.value,
        status: selectedFilter.value == 'all' ? null : selectedFilter.value,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        category: selectedCategory.value == 'all'
            ? null
            : selectedCategory.value,
      );

      if (response != null && response.data != null) {
        final allBlogs = response.data ?? [];

        // Filter by category on client side if needed (in case API doesn't support it)
        List<Blog> filteredBlogs = allBlogs;
        if (selectedCategory.value != 'all') {
          filteredBlogs = allBlogs.where((blog) {
            if (blog.categories == null || blog.categories!.isEmpty)
              return false;
            return blog.categories!.any(
              (cat) =>
                  cat.slug == selectedCategory.value ||
                  cat.id == selectedCategory.value,
            );
          }).toList();
        }

        // Only show published blogs
        filteredBlogs = filteredBlogs
            .where(
              (blog) =>
                  blog.status == 'published' && !(blog.isDeleted ?? false),
            )
            .toList();

        // Separate featured and regular blogs
        if (refresh) {
          featuredBlogs.value = filteredBlogs
              .where((blog) => blog.isFeatured == true)
              .toList();
          blogs.value = filteredBlogs;
        } else {
          blogs.addAll(filteredBlogs);
        }

        hasMoreData.value = response.pagination?.hasNextPage ?? false;
        if (hasMoreData.value) {
          currentPage.value++;
        }
      }
    } catch (e) {
      blogs.clear();
      showErrorMessage(title: "Error", message: "Failed to load blogs");
    } finally {
      setLoadingState(false);
    }
  }

  void filterBlogs(String filter) {
    selectedFilter.value = filter;
    loadBlogs(refresh: true);
  }

  void filterByCategory(String categorySlug) {
    if (selectedCategory.value == categorySlug) return;
    selectedCategory.value = categorySlug;
    currentPage.value = 1;
    blogs.clear();
    featuredBlogs.clear();
    hasMoreData.value = true;
    loadBlogs(refresh: true);
  }

  void searchBlogs(String query) {
    if (searchQuery.value == query) return;
    searchQuery.value = query;
    currentPage.value = 1;
    blogs.clear();
    featuredBlogs.clear();
    hasMoreData.value = true;
    loadBlogs(refresh: true);
  }

  void clearSearch() {
    if (searchQuery.value.isEmpty) return;
    searchQuery.value = '';
    currentPage.value = 1;
    blogs.clear();
    featuredBlogs.clear();
    hasMoreData.value = true;
    loadBlogs(refresh: true);
  }

  Future<void> deleteBlog(String blogId) async {
    try {
      final success = await _blogService.deleteBlog(blogId);
      if (success) {
        blogs.removeWhere((blog) => blog.id == blogId);
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: "Failed to delete blog");
    }
  }

  void refreshBlogs() {
    loadBlogs(refresh: true);
  }

  String getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return 'Published';
      case 'draft':
        return 'Draft';
      case 'under_review':
        return 'Under Review';
      default:
        return status;
    }
  }

  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return 'success';
      case 'draft':
        return 'warning';
      case 'under_review':
        return 'info';
      default:
        return 'secondary';
    }
  }
}
