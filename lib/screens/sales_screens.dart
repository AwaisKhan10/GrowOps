import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets.dart';

class SalesRouter extends StatelessWidget {
  const SalesRouter({super.key, required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    if (route == '/sales/orders/new') return const NewOrderScreen();
    if (route == '/sales/invoices/new') return const NewInvoiceScreen();
    if (route.startsWith('/sales/invoices/') && route != '/sales/invoices') {
      return InvoiceDetailScreen(id: route.split('/').last);
    }
    if (route.startsWith('/sales/clients/') && route != '/sales/clients') {
      return ClientDetailScreen(id: route.split('/').last);
    }
    if (route == '/sales/invoices') return const InvoicesScreen();
    if (route == '/sales/clients') return const ClientsScreen();
    if (route == '/sales/payments') return const PaymentsScreen();
    return const OrdersScreen();
  }
}

// ── Shared Sales chrome ──────────────────────────────────────────────────────

enum _SalesTab { orders, invoices, clients, payments }

class _SalesNavTiles extends StatelessWidget {
  const _SalesNavTiles({required this.active});

  final _SalesTab active;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final tiles = [
      (
        _SalesTab.orders,
        Icons.storefront_outlined,
        'Orders',
        '/sales/orders',
      ),
      (
        _SalesTab.invoices,
        Icons.description_outlined,
        'Invoices',
        '/sales/invoices',
      ),
      (
        _SalesTab.clients,
        Icons.people_outline,
        'Stores',
        '/sales/clients',
      ),
      (
        _SalesTab.payments,
        Icons.payments_outlined,
        'Payments',
        '/sales/payments',
      ),
    ];

    // Orders tab uses "Stores"; other sales tabs use "Clients" (prototype).
    final clientsLabel = active == _SalesTab.orders ? 'Stores' : 'Clients';

    return Row(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _SalesNavTile(
              icon: tiles[i].$2,
              label: tiles[i].$1 == _SalesTab.clients ? clientsLabel : tiles[i].$3,
              selected: tiles[i].$1 == active,
              onTap: () => app.go(tiles[i].$4),
            ),
          ),
        ],
      ],
    );
  }
}

class _SalesNavTile extends StatelessWidget {
  const _SalesNavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.mint.withValues(alpha: 0.55) : AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? AppColors.forest : AppColors.line,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? AppColors.forest : AppColors.muted,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.label(
                  color: selected ? AppColors.forest : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForestCta extends StatelessWidget {
  const _ForestCta({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.forest,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(label, style: AppTextStyles.button()),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterPills extends StatelessWidget {
  const _FilterPills({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelect;

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
              color: on ? AppColors.forest : AppColors.card,
              shape: StadiumBorder(
                side: BorderSide(color: on ? AppColors.forest : AppColors.line),
              ),
              child: InkWell(
                onTap: () => onSelect(f),
                customBorder: const StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
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

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.icon,
    required this.title,
    this.subtitle,
    this.minHeight = 220,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return GoCard(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 44, color: AppColors.muted),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body(
                    color: AppColors.ink,
                    weight: FontWeight.w700,
                  ).copyWith(fontSize: 16),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Orders ───────────────────────────────────────────────────────────────────

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _filter = 'Open';

  static const _filters = [
    'Open',
    'Draft',
    'Confirmed',
    'Picking',
    'Packed',
  ];

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final filtered = app.orders.where((o) {
      if (_filter == 'Open') {
        return !const {'Draft', 'Packed', 'Shipped', 'Delivered', 'Processing'}
            .contains(o.status);
      }
      return o.status == _filter;
    }).toList();
    final openCount = app.orders
        .where(
          (o) => !const {
            'Draft',
            'Packed',
            'Shipped',
            'Delivered',
            'Processing',
          }.contains(o.status),
        )
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(
          title: 'Store orders',
          subtitle: '$openCount open',
          showBack: true,
        ),
        const SizedBox(height: 12),
        const _SalesNavTiles(active: _SalesTab.orders),
        const SizedBox(height: 14),
        _ForestCta(
          label: 'New store order',
          onTap: () => app.go('/sales/orders/new'),
        ),
        const SizedBox(height: 14),
        _FilterPills(
          items: _filters,
          selected: _filter,
          onSelect: (v) => setState(() => _filter = v),
        ),
        const SizedBox(height: 14),
        if (filtered.isEmpty)
          const _EmptyPanel(
            icon: Icons.inventory_2_outlined,
            title: 'No orders here yet',
            subtitle: 'Create an order when a store asks for stock.',
          )
        else
          GoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < filtered.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: AppColors.line),
                  ListTile(
                    title: Text(
                      filtered[i].client,
                      style: AppTextStyles.body(weight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${filtered[i].when} · ${filtered[i].status}',
                      style: AppTextStyles.bodySmall(),
                    ),
                    trailing: Text(
                      filtered[i].total,
                      style: AppTextStyles.body(weight: FontWeight.w700),
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

class NewOrderScreen extends StatelessWidget {
  const NewOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        const GoHeader(title: 'New order', showBack: true),
        const SizedBox(height: 12),
        const TextField(decoration: InputDecoration(labelText: 'Client')),
        const SizedBox(height: 8),
        const TextField(decoration: InputDecoration(labelText: 'Notes')),
        const SizedBox(height: 16),
        _ForestCta(
          label: 'Create order',
          onTap: () {
            app.orders.insert(
              0,
              StoreOrder(
                id: 'o${app.orders.length + 1}',
                client: 'Walk-in',
                status: 'Draft',
                total: 'R 0',
                when: 'Today',
              ),
            );
            app.go('/sales/orders');
          },
        ),
      ],
    );
  }
}

// ── Invoices ─────────────────────────────────────────────────────────────────

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String _filter = 'All';

  static const _filters = ['All', 'Draft', 'Sent', 'Paid', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final filtered = _filter == 'All'
        ? app.invoices
        : app.invoices.where((i) => i.status == _filter).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(
          title: 'Sales',
          subtitle: '${app.invoices.length} invoices',
          showBack: true,
        ),
        const SizedBox(height: 12),
        const _SalesNavTiles(active: _SalesTab.invoices),
        const SizedBox(height: 14),
        _ForestCta(
          label: 'Create invoice',
          onTap: () => app.go('/sales/invoices/new'),
        ),
        const SizedBox(height: 14),
        _FilterPills(
          items: _filters,
          selected: _filter,
          onSelect: (v) => setState(() => _filter = v),
        ),
        const SizedBox(height: 14),
        if (filtered.isEmpty)
          const _EmptyPanel(
            icon: Icons.description_outlined,
            title: 'No invoices yet',
            subtitle: 'Tap Create invoice to get started.',
          )
        else
          GoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < filtered.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: AppColors.line),
                  ListTile(
                    onTap: () => app.go('/sales/invoices/${filtered[i].id}'),
                    title: Text(
                      filtered[i].number,
                      style: AppTextStyles.body(weight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${filtered[i].client} · ${filtered[i].status}',
                      style: AppTextStyles.bodySmall(),
                    ),
                    trailing: Text(filtered[i].amount),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class NewInvoiceScreen extends StatelessWidget {
  const NewInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: const [
              GoHeader(title: 'New invoice', showBack: true),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(labelText: 'Client'),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
        ),
        // Full-width primary action, inset from the screen edge. The quick
        // actions FAB is hidden on sales routes so it cannot cover this bar.
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: _ForestCta(
            label: 'Create invoice',
            onTap: () {
              app.invoices.insert(
                0,
                Invoice(
                  id: 'inv${app.invoices.length + 1}',
                  number: 'INV-${1040 + app.invoices.length}',
                  client: app.clients.isNotEmpty
                      ? app.clients.first.name
                      : 'Walk-in',
                  amount: 'R 0',
                  status: 'Draft',
                ),
              );
              app.go('/sales/invoices');
            },
          ),
        ),
      ],
    );
  }
}

class InvoiceDetailScreen extends StatelessWidget {
  const InvoiceDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final inv = app.invoices.firstWhere(
      (i) => i.id == id,
      orElse: () => Invoice(
        id: id,
        number: id,
        client: '—',
        amount: 'R 0',
        status: 'Draft',
      ),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(title: inv.number, subtitle: inv.client, showBack: true),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(inv.amount, style: AppTextStyles.heading()),
              const SizedBox(height: 8),
              Text('Status: ${inv.status}'),
              const SizedBox(height: 8),
              Text('Client: ${inv.client}', style: AppTextStyles.bodySmall()),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Clients ──────────────────────────────────────────────────────────────────

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final q = _query.toLowerCase();
    final list = app.clients.where((c) {
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.email.toLowerCase().contains(q);
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(
          title: 'Clients',
          subtitle: '${app.clients.length} total',
          showBack: true,
        ),
        const SizedBox(height: 12),
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search clients',
          ),
        ),
        const SizedBox(height: 12),
        _ForestCta(
          label: 'New client',
          onTap: () {},
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const _EmptyPanel(
            icon: Icons.people_outline,
            title: 'No clients yet',
            subtitle: 'Add a store or buyer to get started.',
          )
        else
          GoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < list.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: AppColors.line),
                  ListTile(
                    onTap: () => app.go('/sales/clients/${list[i].id}'),
                    leading: CircleAvatar(
                      backgroundColor: AppColors.inputFill,
                      child: Icon(
                        Icons.person_outline,
                        color: AppColors.muted,
                      ),
                    ),
                    title: Text(
                      list[i].name,
                      style: AppTextStyles.body(weight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${list[i].email} · 0 invoices',
                      style: AppTextStyles.bodySmall(),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: AppColors.muted,
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

class ClientDetailScreen extends StatelessWidget {
  const ClientDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final c = app.clients.firstWhere(
      (e) => e.id == id,
      orElse: () => app.clients.isNotEmpty
          ? app.clients.first
          : ClientRecord(
              id: id,
              name: 'Client',
              license: '—',
              email: '—',
            ),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(title: c.name, subtitle: c.license, showBack: true),
        const SizedBox(height: 12),
        GoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.email),
              const SizedBox(height: 12),
              Text(
                'Recent orders',
                style: AppTextStyles.body(weight: FontWeight.w700),
              ),
              ...app.orders.where((o) => o.client == c.name).map(
                    (o) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('${o.when} · ${o.status}'),
                      trailing: Text(o.total),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Payments ─────────────────────────────────────────────────────────────────

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final total = app.payments.isEmpty ? r'$0.00' : '${app.payments.length} paid';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        GoHeader(
          title: 'Payments',
          subtitle: total,
          showBack: true,
        ),
        const SizedBox(height: 12),
        if (app.payments.isEmpty)
          const _EmptyPanel(
            icon: Icons.receipt_long_outlined,
            title: 'No payments yet',
            minHeight: 320,
          )
        else
          GoCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < app.payments.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: AppColors.line),
                  ListTile(
                    title: Text(
                      app.payments[i].client,
                      style: AppTextStyles.body(weight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${app.payments[i].when} · ${app.payments[i].method}',
                      style: AppTextStyles.bodySmall(),
                    ),
                    trailing: Text(app.payments[i].amount),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
