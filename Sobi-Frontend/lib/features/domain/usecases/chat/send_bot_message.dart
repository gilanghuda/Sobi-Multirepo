import '../../repositories/chat_repository.dart';

class SendBotMessage {
  final ChatRepository repository;
  SendBotMessage(this.repository);

  Future<String> call({required String token, required String prompt}) {
    return repository.sendBotMessage(token: token, prompt: prompt);
  }
}
