import '../../domain/entities/chat_entities.dart';

class RoomChatModel {
  final String id;
  final String ownerId;
  final String targetId;
  final String category;
  final bool visible;
  final String createdAt;
  final String updatedAt;

  RoomChatModel({
    required this.id,
    required this.ownerId,
    required this.targetId,
    required this.category,
    required this.visible,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomChatModel.fromJson(Map<String, dynamic> json) {
    return RoomChatModel(
      id: json['id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      targetId: json['target_id'] ?? '',
      category: json['category'] ?? '',
      visible: json['visible'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  RoomChatEntity toEntity() {
    return RoomChatEntity(
      id: id,
      ownerId: ownerId,
      targetId: targetId,
      category: category,
      visible: visible,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class RecentChatModel {
  final String otherUserId;
  final String roomId;
  final String lastMessage;
  final String lastAt;

  RecentChatModel({
    required this.otherUserId,
    required this.roomId,
    required this.lastMessage,
    required this.lastAt,
  });

  factory RecentChatModel.fromJson(Map<String, dynamic> json) {
    return RecentChatModel(
      otherUserId: json['other_user_id'] ?? '',
      roomId: json['room_id'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastAt: json['last_at'] ?? '',
    );
  }

  RecentChatEntity toEntity() {
    return RecentChatEntity(
      otherUserId: otherUserId,
      roomId: roomId,
      lastMessage: lastMessage,
      lastAt: lastAt,
    );
  }
}

class MessageChatModel {
  final String id;
  final String roomId;
  final String userId;
  final String text;
  final bool visible;
  final String createdAt;
  final bool isMe;

  MessageChatModel({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.text,
    required this.visible,
    required this.createdAt,
    required this.isMe,
  });

  factory MessageChatModel.fromJson(Map<String, dynamic> json) {
    return MessageChatModel(
      id: json['id'] ?? '',
      roomId: json['room_id'] ?? '',
      userId: json['user_id'] ?? '',
      text: json['text'] ?? '',
      visible: json['visible'] ?? false,
      createdAt: json['created_at'] ?? '',
      isMe: json['is_me'] ?? false,
    );
  }

  MessageChatEntity toEntity() {
    return MessageChatEntity(
      id: id,
      roomId: roomId,
      userId: userId,
      text: text,
      visible: visible,
      createdAt: createdAt,
      isMe: isMe,
    );
  }
}
