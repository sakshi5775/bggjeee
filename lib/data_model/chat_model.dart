class ChatMessage {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;
  final int? tokenCount;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.tokenCount,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? json['_id'] ?? '',
      role: json['role'] ?? '',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      tokenCount: json['tokenCount'] as int?,
    );
  }
}

class Conversation {
  final String id;
  final String personaId;
  final String title;
  final List<ChatMessage> messages;
  final int totalMessages;
  final DateTime lastMessageAt;
  final String status;
  final DateTime createdAt;

  Conversation({
    required this.id,
    required this.personaId,
    required this.title,
    required this.messages,
    required this.totalMessages,
    required this.lastMessageAt,
    required this.status,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final conversationJson = json['conversation'] ?? json;
    final messagesList = conversationJson['messages'] as List<dynamic>? ?? [];
    
    return Conversation(
      id: conversationJson['id'] ?? '',
      personaId: conversationJson['personaId'] ?? '',
      title: conversationJson['title'] ?? '',
      messages: messagesList
          .map((msg) => ChatMessage.fromJson(msg as Map<String, dynamic>))
          .toList(),
      totalMessages: conversationJson['totalMessages'] ?? 0,
      lastMessageAt: conversationJson['lastMessageAt'] != null
          ? DateTime.parse(conversationJson['lastMessageAt'])
          : DateTime.now(),
      status: conversationJson['status'] ?? 'ACTIVE',
      createdAt: conversationJson['createdAt'] != null
          ? DateTime.parse(conversationJson['createdAt'])
          : DateTime.now(),
    );
  }
}

class SendMessageResponse {
  final String conversationId;
  final String response;
  final Map<String, dynamic>? metadata;

  SendMessageResponse({
    required this.conversationId,
    required this.response,
    this.metadata,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return SendMessageResponse(
      conversationId: data['conversationId'] ?? '',
      response: data['response'] ?? '',
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }
}






