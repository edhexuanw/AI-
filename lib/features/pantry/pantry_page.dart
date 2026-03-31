import 'package:ai_core_health/core/models/pantry_item.dart';
import 'package:ai_core_health/core/services/firestore_service.dart';
import 'package:ai_core_health/shared/widgets/app_scaffold.dart';
import 'package:ai_core_health/shared/widgets/info_card.dart';
import 'package:ai_core_health/shared/widgets/section_header.dart';
import 'package:flutter/material.dart';

class PantryPage extends StatelessWidget {
  const PantryPage({super.key, required this.uid});

  final String uid;

  Future<void> _showAddDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final quantityController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('新增冰箱食材'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '名称'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: '分类'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: '数量'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirestoreService.instance.addPantryItem(
                  uid: uid,
                  name: nameController.text.trim(),
                  category: categoryController.text.trim(),
                  quantity: quantityController.text.trim(),
                  expireAt: DateTime.now().add(const Duration(days: 4)),
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '冰箱库存',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: const Text('新增食材'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<PantryItem>>(
        stream: FirestoreService.instance.pantryItems(uid),
        builder: (context, snapshot) {
          final items = snapshot.data ?? const [];
          return ListView(
            children: [
              const SizedBox(height: 16),
              const SectionHeader(
                title: '冰箱管理',
                subtitle: '肉 / 菜 / 蛋奶 / 饮品分类浏览。',
              ),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const InfoCard(child: Text('当前没有库存，新增后会同步到 Firestore。')),
              for (final item in items) ...[
                const SizedBox(height: 10),
                InfoCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      child: Text(
                        item.category.isEmpty
                            ? '?'
                            : item.category.characters.first,
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.category} · ${item.quantity}'),
                    trailing: Text(
                      '${item.expireAt.month}/${item.expireAt.day}',
                    ),
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
