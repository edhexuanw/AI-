import 'dart:convert';

import 'package:ai_core_health/core/models/scan_record.dart';
import 'package:ai_core_health/core/services/app_config.dart';
import 'package:http/http.dart' as http;

class ClaudeService {
  ClaudeService._();

  static final ClaudeService instance = ClaudeService._();

  Future<ScanRecord> analyzeFood({
    required List<int> imageBytes,
    required String imageLabel,
  }) async {
    if (!AppConfig.hasAnthropicKey) {
      return ScanRecord(
        id: '',
        imageLabel: imageLabel,
        summary: '未配置 Claude API Key，当前返回预览分析结果。推荐搭配蔬菜与高蛋白食物，减少精制糖。',
        calories: 420,
        protein: 26,
        carbs: 38,
        fat: 14,
        createdAt: DateTime.now(),
      );
    }

    final response = await http.post(
      Uri.parse('https://api.anthropic.com/v1/messages'),
      headers: {
        'content-type': 'application/json',
        'x-api-key': AppConfig.anthropicApiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-3-5-sonnet-latest',
        'max_tokens': 500,
        'messages': [
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text':
                    '你是营养分析助手。请识别食物并严格以 JSON 返回：'
                    '{"summary":"", "calories":0, "protein":0, "carbs":0, "fat":0}。'
                    'summary 需要用中文给出一段简洁建议。',
              },
              {
                'type': 'image',
                'source': {
                  'type': 'base64',
                  'media_type': 'image/jpeg',
                  'data': base64Encode(imageBytes),
                },
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Claude request failed: ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final content = (decoded['content'] as List).first as Map<String, dynamic>;
    final text = content['text'] as String? ?? '{}';
    final parsed = jsonDecode(text) as Map<String, dynamic>;

    return ScanRecord(
      id: '',
      imageLabel: imageLabel,
      summary: parsed['summary'] as String? ?? '',
      calories: (parsed['calories'] as num?)?.toInt() ?? 0,
      protein: (parsed['protein'] as num?)?.toInt() ?? 0,
      carbs: (parsed['carbs'] as num?)?.toInt() ?? 0,
      fat: (parsed['fat'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.now(),
    );
  }
}
