import 'package:ai_core_health/core/models/scan_record.dart';
import 'package:ai_core_health/core/services/claude_service.dart';
import 'package:ai_core_health/core/services/firestore_service.dart';
import 'package:ai_core_health/shared/widgets/app_scaffold.dart';
import 'package:ai_core_health/shared/widgets/info_card.dart';
import 'package:ai_core_health/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.uid});

  final String uid;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _loading = false;
  String? _status;

  Future<void> _pickAndAnalyze(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 85);
    if (file == null) {
      return;
    }

    setState(() {
      _loading = true;
      _status = '正在调用 Claude 分析图片...';
    });

    try {
      final bytes = await file.readAsBytes();
      final record = await ClaudeService.instance.analyzeFood(
        imageBytes: bytes,
        imageLabel: file.name,
      );
      await FirestoreService.instance.saveScan(uid: widget.uid, record: record);
      setState(() => _status = '分析完成，结果已写入 Firebase。');
    } catch (error) {
      setState(() => _status = error.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'AI 识别',
      body: StreamBuilder<List<ScanRecord>>(
        stream: FirestoreService.instance.scanRecords(widget.uid),
        builder: (context, snapshot) {
          final records = snapshot.data ?? const [];
          return ListView(
            children: [
              const SizedBox(height: 16),
              const SectionHeader(
                title: '拍照识别食材 / 成品',
                subtitle: '将图片交给 Claude 识别并生成热量与营养建议。',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _loading
                          ? null
                          : () => _pickAndAnalyze(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text('拍照'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _loading
                          ? null
                          : () => _pickAndAnalyze(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('相册'),
                    ),
                  ),
                ],
              ),
              if (_status != null) ...[
                const SizedBox(height: 12),
                InfoCard(child: Text(_status!)),
              ],
              const SizedBox(height: 18),
              const SectionHeader(
                title: '最近识别记录',
                subtitle: '所有分析结果都保存到 Firestore。',
              ),
              const SizedBox(height: 10),
              if (records.isEmpty)
                const InfoCard(child: Text('还没有识别记录，先拍一张食物照片。')),
              for (final record in records) ...[
                const SizedBox(height: 10),
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.imageLabel,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(record.summary),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('${record.calories} kcal')),
                          Chip(label: Text('蛋白 ${record.protein}g')),
                          Chip(label: Text('碳水 ${record.carbs}g')),
                          Chip(label: Text('脂肪 ${record.fat}g')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
