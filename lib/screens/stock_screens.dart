import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_state.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    var items = app.stock;
    final q = app.searchStock.toLowerCase();
    if (q.isNotEmpty) {
      items = items
          .where(
            (s) =>
                s.strain.toLowerCase().contains(q) ||
                s.size.toLowerCase().contains(q) ||
                s.sku.toLowerCase().contains(q) ||
                s.batchCode.toLowerCase().contains(q) ||
                s.harvest.toLowerCase().contains(q),
          )
          .toList();
    }
    final qty = app.stock.fold<int>(0, (p, e) => p + e.qty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GoHeader(
          title: 'Stock',
          subtitle: '${app.stock.length} items · $qty in stock',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              TextField(
                onChanged: (v) {
                  app.searchStock = v;
                  app.notifyListeners();
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: '"Gorilla 3.5g" or "harvested in May"',
                ),
              ),
              const SizedBox(height: 12),
              ...items.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _StockCard(
                    item: s,
                    onTap: () => app.go('/inventory/${s.id}'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StockCard extends StatelessWidget {
  const _StockCard({required this.item, required this.onTap});

  final StockItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GoCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              item.size,
              style: AppTextStyles.title(color: AppColors.emphasisOf(context))
                  .copyWith(
                fontSize: 20,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.strain,
                  style: AppTextStyles.title(color: AppColors.inkOf(context))
                      .copyWith(fontSize: 17),
                ),
                const SizedBox(height: 3),
                Text(
                  item.sku,
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 11.5,
                    color: AppColors.mutedOf(context),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.harvest} · ${item.batchCode}',
                  style: AppTextStyles.bodySmall(
                    color: AppColors.mutedOf(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.chipFillOf(context),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.size,
                  style: AppTextStyles.label(color: AppColors.inkOf(context))
                      .copyWith(fontSize: 11),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '${item.qty}',
                style: AppTextStyles.display(color: AppColors.inkOf(context))
                    .copyWith(fontSize: 26, height: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StockDetailScreen extends StatelessWidget {
  const StockDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final item = app.stock.firstWhere((s) => s.id == id, orElse: () => app.stock.first);

    return GoPageScaffold(
      title: item.strain,
      subtitle: item.size,
      children: [
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.sku,
                style: GoogleFonts.sourceCodePro(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Text('${item.harvest} · ${item.batchCode}'),
              const SizedBox(height: 8),
              Text(
                '${item.qty} packages in stock',
                style: AppTextStyles.title(),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => app.go('/trace/${item.sku}'),
                  child: const Text('View package QR / trace'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
