import 'package:flutter/material.dart';

import '../app_state.dart';
import '../core/theme/app_text_styles.dart';
import '../theme.dart';
import '../widgets.dart';

class ReportsRouter extends StatelessWidget {
  const ReportsRouter({super.key, required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    if (route == '/reports') return const ReportsHubScreen();
    if (route.contains('active')) return const ActiveBatchesReportScreen();
    if (route.contains('batch-history')) return const BatchHistoryReportScreen();
    if (route.contains('environment')) {
      return const EnvironmentReportScreen();
    }
    if (route.contains('dashboards/production') ||
        route.contains('production-dashboard')) {
      return const ProductionDashboardScreen();
    }
    if (route.contains('production') && !route.contains('dashboard')) {
      return const ProductionReportScreen();
    }
    if (route.contains('yield')) return const YieldReportScreen();
    if (route.contains('input')) return const InputUsageReportScreen();
    if (route.contains('inventory/current') ||
        (route.contains('/inventory') &&
            !route.contains('lot') &&
            !route.contains('movement'))) {
      return const InventoryReportScreen();
    }
    if (route.contains('inventory/lot') ||
        (route.contains('lot') &&
            !route.contains('trace') &&
            !route.contains('genealogy'))) {
      return const LotInventoryReportScreen();
    }
    if (route.contains('movement')) return const MovementReportScreen();
    if (route.contains('ebr')) return const EbrReportScreen();
    if (route.contains('release')) return const ReleaseStatusReportScreen();
    if (route.contains('capa')) return const CapaAgingReportScreen();
    if (route.contains('audit')) return const TrackTraceAuditScreen();
    if (route.contains('tracking')) return const TrackingTraceScreen();
    if (route.contains('genealogy')) return const BatchGenealogyScreen();
    if (route.contains('lot-trace') || route.contains('trace/lot')) {
      return const LotTraceabilityScreen();
    }
    if (route.contains('waste')) return const WasteReportScreen();
    if (route.contains('compliance')) return const ComplianceDashboardScreen();

    final title = _titleFromRoute(route);
    return GenericReportScreen(title: title, route: route);
  }

  static String _titleFromRoute(String route) {
    final slug = route.replaceAll('/reports/', '').replaceAll('/', ' · ');
    if (slug.isEmpty) return 'Report';
    return slug[0].toUpperCase() + slug.substring(1);
  }
}

// ── Shared report chrome ─────────────────────────────────────────────────────

class _ReportHeader extends StatelessWidget {
  const _ReportHeader({
    required this.title,
    this.subtitle,
    this.pdfOnly = false,
  });

  final String title;
  final String? subtitle;
  final bool pdfOnly;

  @override
  Widget build(BuildContext context) {
    return GoHeader(
      title: title,
      subtitle: subtitle,
      showBack: true,
      showSynced: false,
      showExportActions: !pdfOnly,
      trailing: pdfOnly
          ? Padding(
              padding: const EdgeInsets.only(right: 4),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      const SizedBox(width: 4),
                      Text('PDF', style: AppTextStyles.label()),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _ReportScaffold extends StatelessWidget {
  const _ReportScaffold({
    required this.title,
    required this.children,
    this.subtitle,
    this.pdfOnly = false,
  });

  final String title;
  final String? subtitle;
  final bool pdfOnly;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ReportHeader(title: title, subtitle: subtitle, pdfOnly: pdfOnly),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: children,
          ),
        ),
      ],
    );
  }
}

class _TimeRangePills extends StatelessWidget {
  const _TimeRangePills({
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final ValueChanged<String> onSelect;

  static const items = ['7d', '30d', '90d', 'Year', 'All'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((f) {
          final on = f == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: on ? AppColors.forest : AppColors.inputFill,
              shape: const StadiumBorder(),
              child: InkWell(
                onTap: () => onSelect(f),
                customBorder: const StadiumBorder(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  child: Text(
                    f,
                    style: AppTextStyles.chip(
                      color: on ? Colors.white : AppColors.ink,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    this.sub,
    this.reserveSub = false,
  });

  final String label;
  final String value;
  final String? sub;

  /// Keeps a subtitle line so sibling cards stay the same height.
  final bool reserveSub;

  @override
  Widget build(BuildContext context) {
    final showSub = sub != null || reserveSub;
    return GoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.section(color: AppColors.mutedOf(context)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.heading(color: AppColors.inkOf(context)),
          ),
          if (showSub) ...[
            const SizedBox(height: 2),
            SizedBox(
              height: 18,
              child: sub == null
                  ? null
                  : Text(
                      sub!,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(
                        color: AppColors.mutedOf(context),
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Equal-width metric cards. Two columns on phones so labels stay intact,
/// four columns once each card is wide enough.
class _EqualMetricGrid extends StatelessWidget {
  const _EqualMetricGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 600 ? 4 : 2;
        const gap = 10.0;
        final rowCount = (children.length / columns).ceil();

        return Column(
          children: [
            for (var row = 0; row < rowCount; row++) ...[
              if (row > 0) const SizedBox(height: gap),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var col = 0; col < columns; col++) ...[
                      if (col > 0) const SizedBox(width: gap),
                      Expanded(
                        child: row * columns + col < children.length
                            ? children[row * columns + col]
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _DataTableCard extends StatelessWidget {
  const _DataTableCard({
    required this.headers,
    required this.rows,
    this.emptyMessage = 'Nothing to show yet.',
    this.columnWidths,
  });

  final List<String> headers;
  final List<List<String>> rows;
  final String emptyMessage;

  /// Optional fixed widths per column (improves mobile readability).
  final List<double>? columnWidths;

  static const _defaultWidths = <double>[108, 88, 180, 96, 96];

  /// Keeps short headers such as STATUS on one line, and dates wide enough
  /// that values like 9/15/2026 do not wrap.
  static double _columnWidth({
    required int index,
    required String header,
    required List<double>? specified,
  }) {
    final double fallback =
        index < _defaultWidths.length ? _defaultWidths[index] : 96;
    final double base = (specified != null && index < specified.length)
        ? specified[index]
        : fallback;
    final headerMin = header.toUpperCase().length * 11.0 + 28;
    return base >= headerMin ? base : headerMin;
  }

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return GoCard(
        child: SizedBox(
          height: 160,
          child: Center(
            child: Text(
              emptyMessage,
              style: AppTextStyles.bodySmall(
                color: AppColors.mutedOf(context),
              ),
            ),
          ),
        ),
      );
    }

    final widths = [
      for (var i = 0; i < headers.length; i++)
        _columnWidth(
          index: i,
          header: headers[i],
          specified: columnWidths,
        ),
    ];
    final line = AppColors.lineOf(context);
    final tableWidth = widths.fold<double>(0, (a, b) => a + b) + 28;

    return GoCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 2),
            child: SizedBox(
              width: tableWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                    child: Row(
                      children: [
                        for (var i = 0; i < headers.length; i++)
                          SizedBox(
                            width: widths[i],
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Text(
                                headers[i].toUpperCase(),
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.section(
                                  color: AppColors.mutedOf(context),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: line),
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: line),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var c = 0; c < rows[i].length; c++)
                            SizedBox(
                              width: c < widths.length ? widths[c] : 96,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  rows[i][c].isEmpty ? '—' : rows[i][c],
                                  maxLines: rows[i][c].contains(' ') ? 4 : 1,
                                  softWrap: rows[i][c].contains(' '),
                                  overflow: rows[i][c].contains(' ')
                                      ? TextOverflow.visible
                                      : TextOverflow.clip,
                                  style: AppTextStyles.body(
                                    color: AppColors.inkOf(context),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (tableWidth > MediaQuery.sizeOf(context).width - 32)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Text(
                'Swipe sideways to see all columns',
                style: AppTextStyles.label(
                  color: AppColors.mutedOf(context),
                ).copyWith(fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }
}

class _DropdownBar extends StatelessWidget {
  const _DropdownBar({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardOf(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.lineOf(context)),
      ),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body(color: AppColors.inkOf(context)),
                ),
              ),
              Icon(Icons.expand_more, color: AppColors.mutedOf(context)),
            ],
          ),
        ),
      ),
    );
  }
}

class _HubSection extends StatelessWidget {
  const _HubSection({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<_HubItem> items;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.muted),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: AppTextStyles.section(color: AppColors.muted).copyWith(
                  fontFamily: AppTextStyles.displayFontFamily,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
        ),
        GoCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(height: 1, color: AppColors.line),
                ListTile(
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(items[i].label, style: AppTextStyles.body()),
                      ),
                      if (items[i].star) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFE8A00A),
                        ),
                      ],
                    ],
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.muted,
                  ),
                  onTap: () => app.go(items[i].route),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HubItem {
  const _HubItem(this.label, this.route, {this.star = false});
  final String label;
  final String route;
  final bool star;
}

// ── Hub ──────────────────────────────────────────────────────────────────────

class ReportsHubScreen extends StatelessWidget {
  const ReportsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GoPageScaffold(
      title: 'Reports',
      children: [
        const _HubSection(
          icon: Icons.eco_outlined,
          title: 'Cultivation',
          items: [
            _HubItem('Active Batch', '/reports/cultivation/active'),
            _HubItem('Batch History', '/reports/cultivation/batch-history'),
            _HubItem(
              'Environmental Monitoring',
              '/reports/cultivation/environment',
            ),
            _HubItem('Production', '/reports/cultivation/production'),
            _HubItem('Yield', '/reports/cultivation/yield'),
            _HubItem('Input Usage', '/reports/cultivation/inputs'),
          ],
        ),
        const _HubSection(
          icon: Icons.inventory_2_outlined,
          title: 'Inventory',
          items: [
            _HubItem('Inventory', '/reports/inventory/current'),
            _HubItem('Lot Inventory', '/reports/inventory/lot'),
            _HubItem('Inventory Movement', '/reports/inventory/movement'),
          ],
        ),
        const _HubSection(
          icon: Icons.verified_user_outlined,
          title: 'Quality',
          items: [
            _HubItem(
              'Electronic Batch Record (eBR)',
              '/reports/quality/ebr',
              star: true,
            ),
            _HubItem('Release Status', '/reports/quality/release'),
            _HubItem('CAPA Aging', '/reports/quality/capa'),
          ],
        ),
        const _HubSection(
          icon: Icons.hub_outlined,
          title: 'Traceability',
          items: [
            _HubItem('Track & Trace Audit', '/reports/trace/audit-pack'),
            _HubItem('Tracking & Trace', '/reports/trace/tracking'),
            _HubItem('Batch Genealogy', '/reports/trace/genealogy'),
            _HubItem('Lot Traceability', '/reports/trace/lot'),
          ],
        ),
        const _HubSection(
          icon: Icons.delete_outline,
          title: 'Waste',
          items: [
            _HubItem('Waste', '/reports/waste'),
          ],
        ),
        const _HubSection(
          icon: Icons.dashboard_outlined,
          title: 'Dashboards',
          items: [
            _HubItem('Compliance', '/reports/dashboards/compliance'),
            _HubItem('Production', '/reports/dashboards/production'),
          ],
        ),
      ],
    );
  }
}

// ── Active Batches ───────────────────────────────────────────────────────────

class ActiveBatchesReportScreen extends StatefulWidget {
  const ActiveBatchesReportScreen({super.key});

  @override
  State<ActiveBatchesReportScreen> createState() =>
      _ActiveBatchesReportScreenState();
}

class _ActiveBatchesReportScreenState extends State<ActiveBatchesReportScreen> {
  String _query = '';
  String _stage = 'All';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    // Prototype order: newest first (BD → OG → WC → GG)
    final all = List<GrowBatch>.from(app.activeBatches)
      ..sort((a, b) => a.day.compareTo(b.day));
    var list = all;
    if (_stage != 'All') {
      list = list.where((b) => b.stage == _stage).toList();
    }
    final q = _query.toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (b) =>
                b.code.toLowerCase().contains(q) ||
                b.strain.toLowerCase().contains(q),
          )
          .toList();
    }

    int countFor(String s) =>
        s == 'All' ? all.length : all.where((b) => b.stage == s).length;

    final stages = [
      'All',
      'Germination',
      'Rooting',
      'Seedling',
      'Veg',
      'Flower',
      'Drying',
    ];
    final plants = list.fold<int>(0, (p, b) => p + b.plants);
    final inFlower = list.where((b) => b.stage == 'Flower').length;
    final oldest = list.isEmpty
        ? '—'
        : '${list.map((b) => b.day).fold<int>(0, (a, b) => a > b ? a : b)}d';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        _ReportHeader(
          title: 'Active Batches',
          subtitle: '${list.length} of ${all.length} shown',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search batch or strain',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: AppColors.card,
              shape: const StadiumBorder(
                side: BorderSide(color: AppColors.line),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Text('Newest', style: AppTextStyles.body()),
                    const Icon(Icons.expand_more, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: stages.map((s) {
              final count = countFor(s);
              final on = s == _stage;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: on ? AppColors.forest : AppColors.inputFill,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    onTap: () => setState(() => _stage = s),
                    customBorder: const StadiumBorder(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      child: Row(
                        children: [
                          Text(
                            s,
                            style: AppTextStyles.chip(
                              color: on ? Colors.white : AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: on
                                  ? const Color(0xFF3D6B42)
                                  : AppColors.card,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count',
                              style: AppTextStyles.chip(
                                color: on ? Colors.white : AppColors.ink,
                                small: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        _EqualMetricGrid(
          children: [
            _MetricCard(
              label: 'Active',
              value: '${list.length}',
              reserveSub: true,
            ),
            _MetricCard(
              label: 'Plants',
              value: '$plants',
              sub: 'in view',
              reserveSub: true,
            ),
            _MetricCard(
              label: 'In flower',
              value: '$inFlower',
              reserveSub: true,
            ),
            _MetricCard(
              label: 'Oldest',
              value: oldest,
              reserveSub: true,
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...list.map(
          (b) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BatchCard(
              batch: b,
              variant: BatchCardVariant.report,
              showMove: false,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Batch History ────────────────────────────────────────────────────────────

class BatchHistoryReportScreen extends StatelessWidget {
  const BatchHistoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final batch = app.batches.isNotEmpty
        ? app.batches.firstWhere(
            (b) => b.code.contains('WC') || b.strain.contains('Wedding'),
            orElse: () => app.batches.first,
          )
        : null;
    final code = batch?.code ?? 'WC-C-001';
    final strain = batch?.strain ?? 'Wedding Cake';

    final rows = <List<String>>[
      ['9/15/2026', 'issue', 'Slight leaf yellowing on lower fan leaves', '', ''],
      ['9/14/2026', 'photo', 'Looking dense', '', ''],
      ['9/12/2026', 'fed', 'Bloom nutrients', '20L', ''],
      ['9/9/2026', 'fed', 'Bloom nutrients', '', ''],
      ['9/6/2026', 'fed', 'Bloom nutrients', '', ''],
      ['8/7/2026', 'stage', 'Moved to Flower', '', ''],
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        _ReportHeader(
          title: 'Batch History',
          subtitle: '$code · $strain',
        ),
        const SizedBox(height: 12),
        _DropdownBar(label: '$code — $strain'),
        const SizedBox(height: 14),
        _DataTableCard(
          headers: const ['Date', 'Action', 'Note', 'Qty', 'Staff'],
          columnWidths: const [112, 88, 200, 64, 80],
          rows: rows,
        ),
      ],
    );
  }
}

// ── Environment ──────────────────────────────────────────────────────────────

class EnvironmentReportScreen extends StatefulWidget {
  const EnvironmentReportScreen({super.key});

  @override
  State<EnvironmentReportScreen> createState() =>
      _EnvironmentReportScreenState();
}

class _EnvironmentReportScreenState extends State<EnvironmentReportScreen> {
  String _range = '30d';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(
          title: 'Environmental Monitoring',
          subtitle: '0 readings',
        ),
        const SizedBox(height: 12),
        _TimeRangePills(
          selected: _range,
          onSelect: (v) => setState(() => _range = v),
        ),
        const SizedBox(height: 14),
        GoCard(
          child: SizedBox(
            height: 220,
            child: Center(
              child: Text(
                'Nothing to show yet.',
                style: AppTextStyles.bodySmall(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Production ───────────────────────────────────────────────────────────────

class ProductionReportScreen extends StatefulWidget {
  const ProductionReportScreen({super.key});

  @override
  State<ProductionReportScreen> createState() => _ProductionReportScreenState();
}

class _ProductionReportScreenState extends State<ProductionReportScreen> {
  String _range = '30d';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(title: 'Production'),
        const SizedBox(height: 12),
        _TimeRangePills(
          selected: _range,
          onSelect: (v) => setState(() => _range = v),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: const [
            _MetricCard(label: 'Plants started', value: '12'),
            _MetricCard(label: 'Harvests', value: '1'),
            _MetricCard(label: 'Wet weight', value: '1820g'),
            _MetricCard(label: 'Dry weight', value: '410g'),
            _MetricCard(label: 'Packaged', value: '200g'),
          ],
        ),
      ],
    );
  }
}

// ── Yield ────────────────────────────────────────────────────────────────────

class YieldReportScreen extends StatelessWidget {
  const YieldReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(title: 'Yield'),
        const SizedBox(height: 8),
        SectionLabel('By batch'),
        const _DataTableCard(
          headers: ['Batch', 'Strain', 'Plants', 'Wet (g)', 'Dry (g)', 'G/plant'],
          rows: [
            ['GG-C-002', 'Gorilla Glue', '6', '1820', '410', '68.3'],
          ],
        ),
        const SizedBox(height: 8),
        SectionLabel('By strain'),
        const _DataTableCard(
          headers: ['Strain', 'Batches', 'Plants', 'Dry (g)', 'G/plant'],
          rows: [
            ['Gorilla Glue', '1', '6', '410', '68.3'],
          ],
        ),
      ],
    );
  }
}

// ── Input Usage ──────────────────────────────────────────────────────────────

class InputUsageReportScreen extends StatefulWidget {
  const InputUsageReportScreen({super.key});

  @override
  State<InputUsageReportScreen> createState() => _InputUsageReportScreenState();
}

class _InputUsageReportScreenState extends State<InputUsageReportScreen> {
  String _range = '30d';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(
          title: 'Input Usage',
          subtitle: '0 products used',
        ),
        const SizedBox(height: 12),
        _TimeRangePills(
          selected: _range,
          onSelect: (v) => setState(() => _range = v),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(child: _DropdownBar(label: 'All batches')),
            SizedBox(width: 8),
            Expanded(child: _DropdownBar(label: 'All strains')),
          ],
        ),
        const SizedBox(height: 14),
        const Row(
          children: [
            Expanded(child: _MetricCard(label: 'Products', value: '0')),
            SizedBox(width: 8),
            Expanded(child: _MetricCard(label: 'Logs w/ inputs', value: '0')),
            SizedBox(width: 8),
            Expanded(
              child: _MetricCard(
                label: 'Coverage',
                value: '0%',
                sub: 'of 14 logs',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GoCard(
          child: SizedBox(
            height: 160,
            child: Center(
              child: Text(
                'Nothing to show yet.',
                style: AppTextStyles.bodySmall(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Inventory ────────────────────────────────────────────────────────────────

class InventoryReportScreen extends StatelessWidget {
  const InventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('3.5g', '1', '24'),
      ('1g', '1', '60'),
      ('7g', '1', '8'),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(
          title: 'Inventory',
          subtitle: 'Current stock by category',
        ),
        const SizedBox(height: 14),
        GoCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('PACK SIZE', style: AppTextStyles.section()),
                    ),
                    Expanded(
                      child: Text(
                        'LOTS',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.section(),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'UNITS',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.section(),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.line),
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) const Divider(height: 1, color: AppColors.line),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(rows[i].$1, style: AppTextStyles.body()),
                      ),
                      Expanded(
                        child: Text(
                          rows[i].$2,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          rows[i].$3,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.body(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── Lot Inventory ────────────────────────────────────────────────────────────

class LotInventoryReportScreen extends StatelessWidget {
  const LotInventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(title: 'Lot Inventory'),
        const SizedBox(height: 14),
        const _DataTableCard(
          headers: [
            'Lot / SKU',
            'Strain',
            'Size',
            'Qty',
            'Source batch',
            'Stage',
            'Status',
          ],
          rows: [
            [
              'GK-GG-C-002-3.5G-001',
              'Gorilla Glue',
              '3.5g',
              '24',
              'GG-C-002',
              'drying',
              'available',
            ],
            [
              'GK-GG-C-002-1G-001',
              'Gorilla Glue',
              '1g',
              '60',
              'GG-C-002',
              'drying',
              'available',
            ],
            [
              'GK-GG-C-002-7G-001',
              'Gorilla Glue',
              '7g',
              '8',
              'GG-C-002',
              'drying',
              'available',
            ],
          ],
        ),
      ],
    );
  }
}

// ── Movement ─────────────────────────────────────────────────────────────────

class MovementReportScreen extends StatefulWidget {
  const MovementReportScreen({super.key});

  @override
  State<MovementReportScreen> createState() => _MovementReportScreenState();
}

class _MovementReportScreenState extends State<MovementReportScreen> {
  String _range = '30d';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(title: 'Inventory Movement'),
        const SizedBox(height: 12),
        _TimeRangePills(
          selected: _range,
          onSelect: (v) => setState(() => _range = v),
        ),
        const SizedBox(height: 14),
        const _DataTableCard(
          headers: ['Date', 'Type', 'Batch', 'Detail'],
          rows: [
            ['9/9/2026', 'stage', 'BD-S-007', 'Batch created'],
            ['9/8/2026', 'moved', 'OG-S-004', 'Transplanted to 11L pots'],
            ['9/1/2026', 'stage', 'GG-C-002', 'Moved to drying'],
            ['8/28/2026', 'harvest', 'GG-C-002', 'Wet weight 1.8kg'],
            ['8/7/2026', 'stage', 'WC-C-001', 'Moved to Flower'],
          ],
        ),
      ],
    );
  }
}

// ── eBR ──────────────────────────────────────────────────────────────────────

class EbrReportScreen extends StatelessWidget {
  const EbrReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final batch = app.batches.isNotEmpty
        ? app.batches.firstWhere(
            (b) => b.code.contains('WC') || b.strain.contains('Wedding'),
            orElse: () => app.batches.first,
          )
        : null;
    final code = batch?.code ?? 'WC-C-001';
    final strain = batch?.strain ?? 'Wedding Cake';
    final plants = batch?.plants ?? 12;
    final stage = (batch?.stage ?? 'flower').toLowerCase();

    final logs = const [
      ('7/20/2026', 'Stage', 'Batch created'),
      ('8/7/2026', 'Stage', 'Moved to Flower'),
      ('9/6/2026', 'Fed', 'Bloom nutrients'),
      ('9/9/2026', 'Fed', 'Bloom nutrients'),
      ('9/12/2026', 'Fed', 'Bloom nutrients'),
      ('9/14/2026', 'Photo', 'Looking dense'),
      ('9/15/2026', 'Issue', 'Slight leaf yellowing on lower fan leaves'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        _ReportHeader(
          title: 'Electronic Batch Record',
          subtitle: '$code · $strain',
          pdfOnly: true,
        ),
        const SizedBox(height: 12),
        _DropdownBar(label: '$code — $strain'),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$strain · started 7/20/2026',
                style: AppTextStyles.body(),
              ),
              const SizedBox(height: 4),
              Text(
                'Stage: $stage · Plants: $plants',
                style: AppTextStyles.body(),
              ),
              const SizedBox(height: 4),
              Text('From mother: WC-M-001', style: AppTextStyles.body()),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOGS (${logs.length})',
                style: AppTextStyles.section(color: AppColors.inkOf(context)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 104,
                    child: Text(
                      'DATE',
                      style: AppTextStyles.section(
                        color: AppColors.mutedOf(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 72,
                    child: Text(
                      'ACTION',
                      style: AppTextStyles.section(
                        color: AppColors.mutedOf(context),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'NOTE',
                      style: AppTextStyles.section(
                        color: AppColors.mutedOf(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final log in logs) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 104,
                        child: Text(
                          log.$1,
                          maxLines: 1,
                          softWrap: false,
                          style: AppTextStyles.bodySmall(
                            color: AppColors.mutedOf(context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 72,
                        child: Text(
                          log.$2,
                          maxLines: 1,
                          softWrap: false,
                          style: AppTextStyles.body(
                            color: AppColors.inkOf(context),
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          log.$3,
                          style: AppTextStyles.body(
                            color: AppColors.inkOf(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HARVEST',
                style: AppTextStyles.section(color: AppColors.inkOf(context)),
              ),
              const SizedBox(height: 8),
              Text(
                'No harvests recorded.',
                style: AppTextStyles.bodySmall(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PACKAGING',
                style: AppTextStyles.section(color: AppColors.inkOf(context)),
              ),
              const SizedBox(height: 8),
              Text(
                'No packaged lots.',
                style: AppTextStyles.bodySmall(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tap the PDF icon above for the full printable Electronic Batch Record.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall(),
        ),
      ],
    );
  }
}

// ── Release / CAPA / Trace / Waste / Dashboards ───────────────────────────────

class ReleaseStatusReportScreen extends StatelessWidget {
  const ReleaseStatusReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const tableRows = [
      ['WC-C-001', 'Wedding Cake', 'flower', 'Active', '7/20/2026'],
      ['OG-S-004', 'OG Kush', 'veg', 'Active', '8/19/2026'],
      ['GG-C-002', 'Gorilla Glue', 'drying', 'Hold', '6/22/2026'],
      ['BD-S-007', 'Blue Dream', 'seedling', 'Active', '9/9/2026'],
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(title: 'Release Status'),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: const [
            _MetricCard(label: 'Active', value: '3'),
            _MetricCard(label: 'Hold', value: '1'),
            _MetricCard(label: 'Released', value: '0'),
            _MetricCard(label: 'Completed', value: '0'),
          ],
        ),
        const SizedBox(height: 14),
        const _DataTableCard(
          headers: ['Batch', 'Strain', 'Stage', 'Status', 'Started'],
          columnWidths: [108, 124, 88, 96, 108],
          rows: tableRows,
        ),
      ],
    );
  }
}

class CapaAgingReportScreen extends StatelessWidget {
  const CapaAgingReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final capas = app.tasks
        .where((t) => t.title.toUpperCase().startsWith('CAPA'))
        .toList();
    final open = capas.where((t) => !t.done).length;
    final closed = capas.where((t) => t.done).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(
          title: 'CAPA Aging',
          subtitle: "Tasks containing 'CAPA' are tracked here",
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _MetricCard(label: 'Open CAPAs', value: '$open')),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(label: 'Closed CAPAs', value: '$closed'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        GoCard(
          child: SizedBox(
            height: 180,
            child: Center(
              child: Text(
                capas.isEmpty
                    ? "No CAPAs logged. Prefix a task title with 'CAPA:' to track it here."
                    : '${capas.length} CAPA task(s) found.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrackTraceAuditScreen extends StatefulWidget {
  const TrackTraceAuditScreen({super.key});

  @override
  State<TrackTraceAuditScreen> createState() => _TrackTraceAuditScreenState();
}

class _TrackTraceAuditScreenState extends State<TrackTraceAuditScreen> {
  String _range = 'All';
  bool _signed = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(
          title: 'Track & Trace Audit',
          subtitle: 'All time',
        ),
        const SizedBox(height: 12),
        _TimeRangePills(
          selected: _range,
          onSelect: (v) => setState(() => _range = v),
        ),
        const SizedBox(height: 14),
        GoCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.verified_user_outlined, color: AppColors.forest),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'One tap, whole audit',
                      style: AppTextStyles.body(weight: FontWeight.w700)
                          .copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'The PDF pack includes the custody chain, batch / harvest / lot / sales registers, inputs used, and every exception an auditor will ask about.',
                      style: AppTextStyles.bodySmall(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock_outline, size: 20),
                  const SizedBox(width: 8),
                  Text('Audit declaration', style: AppTextStyles.title()),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'I confirm the records in this pack are a true and complete representation of the cultivation activity for the period stated.',
                style: AppTextStyles.bodySmall(),
              ),
              const SizedBox(height: 14),
              Text('Your name', style: AppTextStyles.bodySmall()),
              const SizedBox(height: 6),
              const TextField(
                decoration: InputDecoration(hintText: 'e.g. Sam Taylor'),
              ),
              const SizedBox(height: 12),
              Text('Your role', style: AppTextStyles.bodySmall()),
              const SizedBox(height: 6),
              const TextField(
                decoration: InputDecoration(hintText: 'e.g. Head Grower'),
              ),
              const SizedBox(height: 12),
              Material(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => setState(() => _signed = !_signed),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          _signed
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: AppColors.forest,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign & lock for audit',
                                style: AppTextStyles.body(
                                  weight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Add your name and role to enable signing.',
                                style: AppTextStyles.bodySmall(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.35,
          children: const [
            _MetricCard(
              label: 'Traceable to origin',
              value: '100%',
              sub: '4 batches in scope',
            ),
            _MetricCard(
              label: 'Exceptions',
              value: '0',
              sub: '0 high severity',
            ),
            _MetricCard(label: 'Harvests', value: '1'),
            _MetricCard(label: 'Packaged lots', value: '3'),
          ],
        ),
      ],
    );
  }
}

class TrackingTraceScreen extends StatelessWidget {
  const TrackingTraceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(
          title: 'Tracking & Trace',
          subtitle: 'Seed / Mother / Clone → Packaged',
        ),
        const SizedBox(height: 14),
        const _DataTableCard(
          headers: ['Source', 'Batch', 'Stage', 'Lot / SKU', 'Size', 'Qty'],
          rows: [
            ['Mother\nGG-M-001', 'GG-C-002', 'drying', 'GK-GG-C-002-3.5G-001', '3.5g', '24'],
            ['Mother\nGG-M-001', 'GG-C-002', 'drying', 'GK-GG-C-002-1G-001', '1g', '60'],
            ['Mother\nGG-M-001', 'GG-C-002', 'drying', 'GK-GG-C-002-7G-001', '7g', '8'],
          ],
        ),
      ],
    );
  }
}

class BatchGenealogyScreen extends StatelessWidget {
  const BatchGenealogyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['WC-M-001', 'WC-C-001', '—', '—', '—'],
      ['GG-M-001', 'GG-C-002', '9/6/2026', 'GK-GG-C-002-3.5G-001', '—'],
      ['GG-M-001', 'GG-C-002', '9/6/2026', 'GK-GG-C-002-1G-001', '—'],
      ['GG-M-001', 'GG-C-002', '9/6/2026', 'GK-GG-C-002-7G-001', '—'],
      ['—', 'BD-S-007', '—', '—', '—'],
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(
          title: 'Batch Genealogy',
          subtitle: 'Mothers → Clones → Batches',
        ),
        const SizedBox(height: 14),
        const _DataTableCard(
          headers: ['Mother', 'Batch', 'Harvest', 'Lot', 'Invoice'],
          rows: rows,
        ),
      ],
    );
  }
}

class LotTraceabilityScreen extends StatelessWidget {
  const LotTraceabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const lot = 'GK-GG-C-002-3.5G-001';
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(
          title: 'Lot Traceability',
          subtitle: lot,
          pdfOnly: true,
        ),
        const SizedBox(height: 12),
        const _DropdownBar(
          label: '$lot — Gorilla Glue · 3.5g',
        ),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lot, style: AppTextStyles.batchCode()),
              const SizedBox(height: 4),
              Text(
                'Gorilla Glue · 3.5g · 24 units',
                style: AppTextStyles.bodySmall(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BACKWARD',
                style: AppTextStyles.section(color: AppColors.ink),
              ),
              const SizedBox(height: 10),
              _traceLine('Batch:', 'GG-C-002'),
              _traceLine('Mother:', 'GG-M-001'),
              _traceLine('Harvest:', '9/6/2026'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FORWARD — SALES',
                style: AppTextStyles.section(color: AppColors.ink),
              ),
              const SizedBox(height: 8),
              Text('Not sold yet.', style: AppTextStyles.bodySmall()),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _traceLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.body(),
          children: [
            TextSpan(text: '$label '),
            TextSpan(
              text: value,
              style: AppTextStyles.body(weight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class WasteReportScreen extends StatefulWidget {
  const WasteReportScreen({super.key});

  @override
  State<WasteReportScreen> createState() => _WasteReportScreenState();
}

class _WasteReportScreenState extends State<WasteReportScreen> {
  String _range = '90d';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(title: 'Waste'),
        const SizedBox(height: 12),
        _TimeRangePills(
          selected: _range,
          onSelect: (v) => setState(() => _range = v),
        ),
        const SizedBox(height: 14),
        GoCard(
          child: SizedBox(
            height: 220,
            child: Center(
              child: Text(
                'No waste logged in this range.',
                style: AppTextStyles.bodySmall(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductionDashboardScreen extends StatelessWidget {
  const ProductionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(title: 'Production Dashboard', pdfOnly: true),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.45,
          children: const [
            _MetricCard(label: 'Active batches', value: '4'),
            _MetricCard(label: 'Plants', value: '30'),
            _MetricCard(label: 'Harvests (30d)', value: '1'),
            _MetricCard(label: 'Inventory units', value: '92'),
            _MetricCard(label: 'Yield (30d)', value: '410g'),
            _MetricCard(label: 'Waste events (30d)', value: '0'),
          ],
        ),
      ],
    );
  }
}

class ComplianceDashboardScreen extends StatelessWidget {
  const ComplianceDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const _ReportHeader(title: 'Compliance Dashboard', pdfOnly: true),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.25,
          children: const [
            _MetricCard(label: 'Open CAPAs', value: '0'),
            _MetricCard(label: 'Closed CAPAs', value: '0'),
            _MetricCard(
              label: 'Harvests w/o source',
              value: '0',
              sub: 'Traceability alert',
            ),
            _MetricCard(
              label: 'Lots w/o invoice',
              value: '3',
              sub: 'Not yet sold',
            ),
          ],
        ),
        const SizedBox(height: 14),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BATCH STATUS MIX',
                style: AppTextStyles.section(color: AppColors.ink).copyWith(
                  fontFamily: AppTextStyles.displayFontFamily,
                ),
              ),
              const SizedBox(height: 12),
              _mixRow('Active', 3),
              const SizedBox(height: 8),
              _mixRow('Hold', 1),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _mixRow(String label, int count) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body())),
        Text('$count', style: AppTextStyles.body()),
      ],
    );
  }
}

class GenericReportScreen extends StatelessWidget {
  const GenericReportScreen({
    super.key,
    required this.title,
    required this.route,
  });

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        _ReportHeader(title: title),
        const SizedBox(height: 14),
        GoCard(
          child: SizedBox(
            height: 180,
            child: Center(
              child: Text(
                'Nothing to show yet.',
                style: AppTextStyles.bodySmall(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
