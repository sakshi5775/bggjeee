import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/comment_model.dart';
import 'package:astrobharataiuser/screens/blogs/service/blog_service.dart';
import 'package:get/get.dart';

class CommentsController extends BaseController {
  final String blogId;
  final BlogService _service = BlogService();

  CommentsController(this.blogId);

  final RxList<Comment> comments = <Comment>[].obs;
  final RxBool loading = false.obs;
  final RxString input = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    final list = await _service.getComments(blogId);
    comments.assignAll(list);
    loading.value = false;
  }

  Future<void> add(String text) async {
    if (text.trim().isEmpty) return;
    final ok = await _service.addComment(blogId: blogId, content: text.trim());
    if (ok) {
      input.value = '';
      await load();
      showSuccessMessage(
        title: 'Success',
        message: 'Comment added successfully',
      );
    }
  }
}
