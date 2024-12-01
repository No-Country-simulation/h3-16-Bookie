import 'package:bookie/config/openai/openai_general.dart';
import 'package:dart_openai/dart_openai.dart';

void modelsOpenai() async {
  try {
    // Obtener la lista de modelos de OpenAI
    List<OpenAIModelModel> models = await OpenAI.instance.model.list();

    // Obtener el primer modelo
    // OpenAIModelModel firstModel = models.first;

    print("OPENAIIIIIIIIIIIIIIIIIIIIIIIIIIII: $models");
    // print("OPENAIIIIIIIIIIIIIIIIIIIIIIIIIIII: ${firstModel.permission}");
  } catch (e) {
    print("OPEANIERRORRRRRRRRRRRRRRRRRRR: $e");
  }
}

Future<Stream<OpenAIStreamChatCompletionModel>> generateStory(
    {required contextStory}) async {
  try {
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          SystemMessageOpenAI.generateStory,
        ),
      ],
      role: OpenAIChatMessageRole.system,
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(contextStory),
      ],
      role: OpenAIChatMessageRole.user,
    );

    // Stream para recibir la respuesta en tiempo real
    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-4o-mini",
      messages: [systemMessage, userMessage],
      // temperature: 0.7,
    );

    return chatStream;
  } catch (e) {
    print("Error al generar historia con OpenAI: $e");
    rethrow;
  }
}

Future<Stream<OpenAIStreamChatCompletionModel>> modifyStory(
    {required String storyToModify}) async {
  try {
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          SystemMessageOpenAI.modifyStory,
        ),
      ],
      role: OpenAIChatMessageRole.system,
    );

    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(storyToModify),
      ],
      role: OpenAIChatMessageRole.user,
    );

    // Stream para recibir la respuesta en tiempo real
    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-4o-mini",
      messages: [systemMessage, userMessage],
      // temperature: 0.7,
    );

    return chatStream;
  } catch (e) {
    print("Error al modificar historia con OpenAI: $e");
    rethrow;
  }
}
