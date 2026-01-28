class CommentResponse {
  final List<Comment> data;

  CommentResponse({required this.data});

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
    return CommentResponse(data: list);
  }
}

class Comment {
  final String? id;
  final String? userName;
  final String? userEmail;
  final String? content;
  final String? createdAt;
  final List<Comment> replies;

  Comment({
    this.id,
    this.userName,
    this.userEmail,
    this.content,
    this.createdAt,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? json['_id'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      content: json['content'],
      createdAt: json['createdAt'],
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}


