import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/data_model/course_model.dart';
import 'package:astrobharataiuser/data_model/webinar_model.dart'; // Added
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart'; // Added
import 'package:astrobharataiuser/screens/user_dashboard/service/banner_service.dart';
import 'package:astrobharataiuser/data_model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoursesController extends BaseController
    with GetTickerProviderStateMixin {
  final CoursesService _coursesService = CoursesService();
  final WebinarService _webinarService = WebinarService();
  final BannerService _bannerService = BannerService(); // Added BannerService

  // Courses list
  final RxList<CourseModel> courses = <CourseModel>[].obs;

  // Banners
  final RxList<BannerItem> learningBanners = <BannerItem>[].obs;
  final RxBool isLoadingBanners = false.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxBool isLoadingMore = false.obs;

  // Filters
  final RxBool? isPublished = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString instructorQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Category selection (0: All, 1: Courses, 2: E-Books)
  final RxInt selectedCategory = 0.obs;

  // Live webinar
  final Rx<WebinarModel?> liveWebinar = Rx<WebinarModel?>(
    null,
  ); // Changed to WebinarModel
  final RxBool hasLiveWebinar = false.obs;
  final RxInt liveWebinarViewers = 0.obs; // Store viewer count from webinar

  // Stats
  final RxInt eBooksCount = 0.obs; // Count courses with courseType = "E-Book"
  final RxInt studentsCount = 0.obs; // Will be fetched from API if available

  // Course-type bottom sheet state
  final RxList<CourseModel> courseTypeCourses = <CourseModel>[].obs;
  final RxBool isCourseTypeLoading = false.obs;
  final RxString courseTypeError = ''.obs;

  // Description expanded state per course id (for Read More / Show Less)
  final RxMap<String, bool> descExpandedMap = <String, bool>{}.obs;

  // Bounce animation controllers — one per courseType step
  static const List<String> _courseTypes = [
    'introcourse',
    'diplomacourse',
    'bachelorcourse',
    'mastercourse',
    'grandmaster',
  ];
  final Map<String, AnimationController> _bounceControllers = {};
  final RxMap<String, double> bounceScaleMap =
      <String, double>{}.obs; // 0.0-1.0 for each courseType

  @override
  void onInit() {
    super.onInit();
    // Initialise one bounce AnimationController per courseType
    for (final ct in _courseTypes) {
      final ac = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        lowerBound: 0.94,
        upperBound: 1.0,
      )..value = 1.0;
      _bounceControllers[ct] = ac;
      bounceScaleMap[ct] = 1.0;
      ac.addListener(() => bounceScaleMap[ct] = ac.value);
    }
    loadBanners();
    loadCourses(refresh: true);
    searchController.addListener(_performSearch);
    _updateLiveWebinar();
  }

  @override
  void onClose() {
    for (final ac in _bounceControllers.values) {
      ac.dispose();
    }
    searchController.removeListener(_performSearch);
    searchController.dispose();
    super.onClose();
  }

  // Toggle description expanded state for a course card
  void toggleDescExpanded(String courseId) {
    descExpandedMap[courseId] = !(descExpandedMap[courseId] ?? false);
  }

  // Trigger bounce animation for a journey card
  Future<void> triggerBounce(String courseType) async {
    final ac = _bounceControllers[courseType];
    if (ac == null) return;
    await ac.reverse();
    await ac.forward();
  }

  // Load courses
  Future<void> loadCourses({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        courses.clear();
        hasMoreData.value = true;
        isLoadingMore.value = false;
        setLoadingState(true);
      } else {
        if (!hasMoreData.value || isLoadingMore.value) {
          return;
        }
        isLoadingMore.value = true;
      }

      final response = await _coursesService.getCourses(
        page: refresh ? 1 : currentPage.value,
        limit: 10,
        isPublished: isPublished?.value,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        instructor: instructorQuery.value.isNotEmpty
            ? instructorQuery.value
            : null,
      );

      if (response != null) {
        if (refresh) {
          courses.value = response.courses;
        } else {
          courses.addAll(response.courses);
        }

        // Update pagination
        hasMoreData.value = response.pagination.hasNextPage;
        if (response.pagination.nextPage != null) {
          currentPage.value = response.pagination.nextPage!;
        } else {
          currentPage.value = response.pagination.currentPage + 1;
        }

        // Update stats
        _updateStats();

        // Update live webinar
        _updateLiveWebinar();
      }
    } catch (e) {
      showErrorMessage(title: "Error", message: "Failed to load courses: $e");
    } finally {
      if (refresh) {
        setLoadingState(false);
      } else {
        isLoadingMore.value = false;
      }
    }
  }

  // Load more courses
  Future<void> loadMore() async {
    if (hasMoreData.value && !isLoadingMore.value) {
      await loadCourses(refresh: false);
    }
  }

  // Fetch courses filtered by courseType (for the learning journey bottom sheet)
  Future<void> fetchCoursesByType(String courseType) async {
    isCourseTypeLoading.value = true;
    courseTypeError.value = '';
    courseTypeCourses.clear();
    try {
      final response = await _coursesService.getCourses(
        isPublished: true,
        courseType: courseType,
        limit: 20,
      );
      courseTypeCourses.value = response?.courses ?? [];
    } catch (e) {
      courseTypeError.value = e.toString();
    } finally {
      isCourseTypeLoading.value = false;
    }
  }

  // Perform search
  void _performSearch() {
    searchQuery.value = searchController.text;
    // Search will be triggered by onChanged in the view
  }

  // Refresh
  @override
  Future<void> refresh() async {
    await loadCourses(refresh: true);
  }

  // Get filtered courses based on selected category
  List<CourseModel> getFilteredCourses() {
    switch (selectedCategory.value) {
      case 0: // Courses only
        // Filter courses (exclude E-Books if courseType field exists)
        // For now, return all courses as CourseModel doesn't have courseType
        return courses;
      case 1: // E-Books only
        // Filter E-Books if courseType field exists
        // For now, return empty as CourseModel doesn't have courseType
        return [];
      default: // All (0)
        return courses;
    }
  }

  // Update stats from courses
  void _updateStats() {
    // Count E-Books - Check if API provides courseType in response
    // For now, count based on slug or title containing "ebook" or "e-book"
    eBooksCount.value = courses.where((course) {
      final titleLower = course.title.toLowerCase();
      final slugLower = course.slug.toLowerCase();
      return titleLower.contains('ebook') ||
          titleLower.contains('e-book') ||
          slugLower.contains('ebook') ||
          slugLower.contains('e-book');
    }).length;

    // Students count - if API provides it, use it; otherwise keep default
    // This could be fetched from a separate stats API if available
    studentsCount.value = 0; // Will be updated if API provides this
  }

  // Update live webinar course
  void _updateLiveWebinar() async {
    try {
      final liveWebinars = await _webinarService.getLiveWebinars();
      if (liveWebinars.isNotEmpty) {
        liveWebinar.value = liveWebinars.first;
        hasLiveWebinar.value = true;

        // Update viewer count
        int viewers = 0;
        if (liveWebinar.value?.viewerStats?.currentViewers != null) {
          viewers = liveWebinar.value!.viewerStats!.currentViewers!;
        }
        liveWebinarViewers.value = viewers;
      } else {
        liveWebinar.value = null;
        hasLiveWebinar.value = false;
        liveWebinarViewers.value = 0;
      }
    } catch (e) {
      debugPrint("Error fetching live webinar banner: $e");
      liveWebinar.value = null;
      hasLiveWebinar.value = false;
    }
  }

  // Load banners
  Future<void> loadBanners() async {
    isLoadingBanners.value = true;
    try {
      var list = await _bannerService.getBannersByCategory('applearning');
      if (list.isEmpty) {
        list = await _bannerService.getBannersByCategory('learning-portal');
      }
      learningBanners.assignAll(list);
    } catch (e) {
      debugPrint("Error fetching learning banners: $e");
    } finally {
      isLoadingBanners.value = false;
    }
  }
}
