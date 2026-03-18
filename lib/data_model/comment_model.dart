class CommentResponse {
  final List<Comment> data;

  CommentResponse({required this.data});

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawList = [];
    final payload = json['data'];
    if (payload is List<dynamic>) {
      rawList = payload;
    } else if (payload is Map<String, dynamic>) {
      // Try every common key the backend might use.
      rawList = (payload['comments'] ??
              payload['data'] ??
              payload['items'] ??
              payload['results'] ??
              []) as List<dynamic>;
    }
    final list = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => Comment.fromJson(e))
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


