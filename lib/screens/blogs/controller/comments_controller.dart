import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/data_model/comment_model.dart';
import 'package:astrobharataiuser/screens/blogs/service/blog_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsController extends BaseController {
  final String blogId;
  final BlogService _service = BlogService();

  CommentsController(this.blogId);

  final RxList<Comment> comments = <Comment>[].obs;
  final RxBool loading = false.obs;
  final RxBool submitting = false.obs;
  final RxString input = ''.obs;

  /// TextEditingController so the TextField in the sheet can be cleared
  /// programmatically after a comment is posted.
  final TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  Future<void> load() async {
    loading.value = true;
    try {
      final list = await _service.getComments(blogId);
      comments.assignAll(list);
    } catch (e) {
      debugPrint('Error loading comments: $e');
    } finally {
      loading.value = false;
    }
  }

  Future<void> add(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    submitting.value = true;
    try {
      final ok = await _service.addComment(blogId: blogId, content: trimmed);
      if (ok) {
        // Clear input and text field immediately so the user sees it was sent.
        input.value = '';
        textEditingController.clear();
        // Reload comment list so the new comment appears instantly.
        await load();
        showSuccessMessage(
          title: 'Success',
          message: 'Comment added successfully',
        );
      }
    } catch (e) {
      debugPrint('Error adding comment: $e');
    } finally {
      submitting.value = false;
    }
  }
}
