class RoomChatEntity {
  final String id;
  final String ownerId;
  final String targetId;
  final String category;
  final bool visible;
  final String createdAt;
  final String updatedAt;

  RoomChatEntity({
    required this.id,
    required this.ownerId,
    required this.targetId,
    required this.category,
    required this.visible,
    required this.createdAt,
    required this.updatedAt,
  });
}

class RecentChatEntity {
  final String otherUserId;
  final String roomId;
  final String lastMessage;
  final String lastAt;

  RecentChatEntity({
    required this.otherUserId,
    required this.roomId,
    required this.lastMessage,
    required this.lastAt,
  });
}

class MessageChatEntity {
  final String id;
  final String roomId;
  final String userId;
  final String text;
  final bool visible;
  final String createdAt;
  final bool isMe;

  MessageChatEntity({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.text,
    required this.visible,
    required this.createdAt,
    required this.isMe,
  });
}
