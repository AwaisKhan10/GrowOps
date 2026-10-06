import '../../app_state.dart';

/// Rich demo dataset for client presentations — mirrors the Lovable prototype.
abstract final class DemoSeedData {
  static List<String> strains() => [
        'Wedding Cake',
        'OG Kush',
        'Gorilla Glue',
        'Blue Dream',
        'Purple Haze',
        'Northern Lights',
      ];

  static List<StrainItem> strainItems() => [
        StrainItem(name: 'Wedding Cake', type: 'Hybrid', flowerDays: '63d flower'),
        StrainItem(name: 'OG Kush', type: 'Hybrid', flowerDays: '56d flower'),
        StrainItem(name: 'Gorilla Glue', type: 'Hybrid', flowerDays: '63d flower'),
        StrainItem(name: 'Blue Dream', type: 'Sativa', flowerDays: '70d flower'),
      ];

  static List<String> inputs() => [
        'Bud Plumper',
        'CalMag',
        'A+B Grow',
        'A+B Bloom',
        'Mammoth P',
        'Mycorrhizae',
        'Beneficial Bacteria',
        'Hydrogen Peroxide',
      ];

  static List<InputItem> inputItems() => [
        InputItem(name: 'Bud Plumper', unit: 'ml'),
        InputItem(name: 'CalMag', unit: 'ml'),
        InputItem(name: 'A+B Grow', unit: 'ml'),
        InputItem(name: 'A+B Bloom', unit: 'ml'),
        InputItem(name: 'Mammoth P', unit: 'ml'),
        InputItem(name: 'Mycorrhizae', unit: 'g'),
        InputItem(name: 'Beneficial Bacteria', unit: 'g'),
        InputItem(name: 'Hydrogen Peroxide', unit: 'ml'),
      ];

  static List<String> wasteReasons() => [
        'Mould',
        'Pest damage',
        'Over-dry',
        'Contamination',
        'Other',
      ];

  static List<LogField> logFields() => [
        LogField(name: 'Watering', enabled: true, type: 'Number', unit: 'L', emoji: '💧'),
        LogField(name: 'Temperature', enabled: true, type: 'Number', unit: '°C', emoji: '🌡️'),
        LogField(name: 'Humidity', enabled: true, type: 'Number', unit: '%', emoji: '💨'),
        LogField(name: 'EC / pH', enabled: true, type: 'Number', unit: 'EC', emoji: '🧪'),
        LogField(name: 'Pest Check', enabled: true, type: 'Yesno', emoji: '🐛'),
        LogField(name: 'Photo', enabled: true, type: 'Photo', emoji: '📷'),
        LogField(name: 'Notes', enabled: true, type: 'Notes', emoji: '📝'),
      ];

  static List<GrowBatch> batches() => [
        GrowBatch(
          id: 'b1',
          code: 'WC-C-001',
          strain: 'Wedding Cake',
          stage: 'Flower',
          plants: 12,
          area: 'Tent 1',
          day: 58,
          progress: 0.92,
          traceCode: 'GK-WC-C-001',
          motherId: 'm1',
          motherCode: 'WC-M-001',
          started: '7/20/2026',
        ),
        GrowBatch(
          id: 'b2',
          code: 'OG-S-004',
          strain: 'OG Kush',
          stage: 'Veg',
          plants: 8,
          area: 'Tunnel A',
          day: 28,
          progress: 1.0,
          traceCode: 'GK-OG-S-004',
          started: '8/19/2026',
        ),
        GrowBatch(
          id: 'b3',
          code: 'GG-C-002',
          strain: 'Gorilla Glue',
          stage: 'Drying',
          plants: 6,
          area: 'Outdoor North',
          day: 86,
          progress: 0.86,
          traceCode: 'GK-GG-C-002',
          motherId: 'm2',
          motherCode: 'GG-M-001',
          started: '6/22/2026',
        ),
        GrowBatch(
          id: 'b4',
          code: 'BD-S-007',
          strain: 'Blue Dream',
          stage: 'Seedling',
          plants: 4,
          area: 'Tent 1',
          day: 7,
          progress: 0.50,
          traceCode: 'GK-BD-S-007',
          motherId: 'm3',
          motherCode: 'BD-M-001',
          started: '9/9/2026',
        ),
        GrowBatch(
          id: 'b5',
          code: 'WC-C-003',
          strain: 'Wedding Cake',
          stage: 'Curing',
          plants: 10,
          area: 'Tent 2',
          day: 92,
          progress: 0.94,
          traceCode: 'GK-WC-C-003',
          motherId: 'm1',
          motherCode: 'WC-M-001',
          started: '6/14/2026',
          archived: true,
        ),
        GrowBatch(
          id: 'b6',
          code: 'OG-C-011',
          strain: 'OG Kush',
          stage: 'Packaged',
          plants: 6,
          area: 'Tunnel A',
          day: 102,
          progress: 1.0,
          traceCode: 'GK-OG-C-011',
          started: '5/30/2026',
          archived: true,
        ),
        GrowBatch(
          id: 'b7',
          code: 'PH-C-005',
          strain: 'Purple Haze',
          stage: 'Harvested',
          plants: 8,
          area: 'Greenhouse B',
          day: 74,
          progress: 0.78,
          traceCode: 'GK-PH-C-005',
          started: '7/2/2026',
          archived: true,
        ),
        GrowBatch(
          id: 'b8',
          code: 'GG-C-008',
          strain: 'Gorilla Glue',
          stage: 'Flower',
          plants: 14,
          area: 'Tent 2',
          day: 52,
          progress: 0.65,
          traceCode: 'GK-GG-C-008',
          motherId: 'm2',
          motherCode: 'GG-M-001',
          started: '7/24/2026',
          archived: true,
        ),
        GrowBatch(
          id: 'b9',
          code: 'NL-C-002',
          strain: 'Northern Lights',
          stage: 'Packaged',
          plants: 5,
          area: 'Tent 1',
          day: 120,
          progress: 1.0,
          traceCode: 'GK-NL-C-002',
          started: '4/12/2026',
          archived: true,
        ),
      ];

  static List<JournalEntry> journal() => [
        JournalEntry(
          batchId: 'b1',
          title: 'Issue found',
          subtitle: 'Slight leaf yellowing on lower fan leaves',
          when: 'Sep 15, 11:58',
          ago: '1 day ago',
          kind: 'issue',
          imageUrl: 'assets/images/activity/issue_leaves.png',
        ),
        JournalEntry(
          batchId: 'b1',
          title: 'Pruned',
          subtitle: 'Topped main colas',
          when: 'Sep 15, 11:58',
          ago: '1 day ago',
          kind: 'pruned',
          imageUrl: 'assets/images/activity/pruned_plant.png',
        ),
        JournalEntry(
          batchId: 'b1',
          title: 'Photo',
          subtitle: 'Looking dense',
          when: 'Sep 14, 11:58',
          ago: '2 days ago',
          kind: 'photo',
          imageUrl: 'assets/images/activity/photo_canopy.png',
        ),
        JournalEntry(
          batchId: 'b1',
          title: 'Check',
          subtitle: 'Snap test — almost ready',
          when: 'Sep 14, 11:58',
          ago: '2 days ago',
          meta: '62% RH',
          kind: 'check',
          imageUrl: 'assets/images/activity/check_drying.png',
        ),
        JournalEntry(
          batchId: 'b1',
          title: 'Fed nutrients',
          subtitle: 'Bloom nutrients',
          when: 'Sep 11, 11:41',
          ago: '4 days ago',
          meta: '20L',
          kind: 'fed',
        ),
        JournalEntry(
          batchId: 'b1',
          title: 'Stage change',
          subtitle: 'Moved to Flower',
          when: 'Aug 6, 11:41',
          ago: 'about 1 month ago',
          kind: 'stage',
        ),
        JournalEntry(
          batchId: 'b1',
          title: 'Stage change',
          subtitle: 'Batch created',
          when: 'Jul 19, 11:41',
          ago: 'about 2 months ago',
          kind: 'stage',
        ),
        JournalEntry(
          batchId: 'b2',
          title: 'Watered',
          subtitle: 'Full irrigation cycle',
          when: 'Sep 15, 08:20',
          ago: 'today',
          meta: '18L',
          kind: 'watered',
        ),
        JournalEntry(
          batchId: 'b2',
          title: 'Photo',
          subtitle: 'Veg canopy filling in',
          when: 'Sep 14, 16:10',
          ago: '1 day ago',
          kind: 'photo',
        ),
        JournalEntry(
          batchId: 'b3',
          title: 'Check',
          subtitle: 'Drying room check',
          when: 'Sep 15, 07:00',
          ago: 'today',
          meta: '58% RH · 21°C',
          kind: 'check',
        ),
        JournalEntry(
          batchId: 'b3',
          title: 'Harvest',
          subtitle: 'Wet 2840 g · Trim 2100 g · Waste 180 g',
          when: 'Sep 5, 14:30',
          ago: '10 days ago',
          kind: 'harvest',
        ),
        JournalEntry(
          batchId: 'b5',
          title: 'Check',
          subtitle: 'Jar burp — aroma stable',
          when: 'Sep 15, 09:15',
          ago: 'today',
          meta: '62% RH',
          kind: 'check',
        ),
        JournalEntry(
          batchId: 'b6',
          title: 'Packaged',
          subtitle: 'Generated SKUs for retail',
          when: 'Sep 1, 10:00',
          ago: '2 weeks ago',
          kind: 'packaged',
        ),
        JournalEntry(
          batchId: 'b8',
          title: 'Defoliated',
          subtitle: 'Removed lower fan leaves',
          when: 'Sep 12, 13:00',
          ago: '3 days ago',
          kind: 'defoliated',
        ),
        JournalEntry(
          batchId: 'b4',
          title: 'Watered',
          subtitle: 'Light misting',
          when: 'Sep 15, 06:45',
          ago: 'today',
          kind: 'watered',
        ),
      ];

  static List<GrowTask> tasks() => [
        GrowTask(
          id: 't1',
          title: 'Water WC-C-001',
          batchId: 'b1',
          batchLabel: 'WC-C-001 · Wedding Cake',
          confidence: 'yes',
        ),
        GrowTask(
          id: 't2',
          title: 'Check drying room (GG-C-002)',
          batchId: 'b3',
          batchLabel: 'GG-C-002 · Gorilla Glue',
          confidence: 'yes',
        ),
        GrowTask(
          id: 't4',
          title: 'Top up reservoir — Tent 1',
          batchId: 'b1',
          batchLabel: 'Tent 1',
          done: true,
        ),
        GrowTask(
          id: 't3',
          title: 'Photo log OG-S-004',
          batchId: 'b2',
          batchLabel: 'OG-S-004 · OG Kush',
        ),
        GrowTask(
          id: 't5',
          title: 'Burp jars WC-C-003',
          batchId: 'b5',
          batchLabel: 'WC-C-003 · Wedding Cake',
          confidence: 'yes',
        ),
        GrowTask(
          id: 't6',
          title: 'Scout GG-C-008 for pests',
          batchId: 'b8',
          batchLabel: 'GG-C-008 · Gorilla Glue',
        ),
        GrowTask(
          id: 't7',
          title: 'Prepare harvest plan PH-C-005',
          batchId: 'b7',
          batchLabel: 'PH-C-005 · Purple Haze',
          confidence: 'no',
        ),
        GrowTask(
          id: 't8',
          title: 'Label new stock OG-C-011',
          batchId: 'b6',
          batchLabel: 'OG-C-011 · OG Kush',
          done: true,
        ),
        GrowTask(
          id: 't9',
          title: 'Feed BD-S-007 seedling mix',
          batchId: 'b4',
          batchLabel: 'BD-S-007 · Blue Dream',
        ),
      ];

  static List<StockItem> stock() => [
        StockItem(
          id: 'i1',
          strain: 'Gorilla Glue',
          size: '3.5g',
          sku: 'GK-GG-C-002-3.5G-001',
          qty: 24,
          harvest: 'Harvest Sep 6',
          batchCode: 'GG-C-002',
        ),
        StockItem(
          id: 'i2',
          strain: 'Gorilla Glue',
          size: '1g',
          sku: 'GK-GG-C-002-1G-001',
          qty: 60,
          harvest: 'Harvest Sep 6',
          batchCode: 'GG-C-002',
        ),
        StockItem(
          id: 'i3',
          strain: 'Gorilla Glue',
          size: '7g',
          sku: 'GK-GG-C-002-7G-001',
          qty: 8,
          harvest: 'Harvest Sep 6',
          batchCode: 'GG-C-002',
        ),
        StockItem(
          id: 'i4',
          strain: 'OG Kush',
          size: '3.5g',
          sku: 'GK-OG-C-011-3.5G-001',
          qty: 36,
          harvest: 'Harvest Aug 28',
          batchCode: 'OG-C-011',
        ),
        StockItem(
          id: 'i5',
          strain: 'OG Kush',
          size: '1g',
          sku: 'GK-OG-C-011-1G-001',
          qty: 48,
          harvest: 'Harvest Aug 28',
          batchCode: 'OG-C-011',
        ),
        StockItem(
          id: 'i6',
          strain: 'Wedding Cake',
          size: '3.5g',
          sku: 'GK-WC-C-003-3.5G-001',
          qty: 18,
          harvest: 'Harvest Sep 10',
          batchCode: 'WC-C-003',
        ),
        StockItem(
          id: 'i7',
          strain: 'Wedding Cake',
          size: '14g',
          sku: 'GK-WC-C-003-14G-001',
          qty: 6,
          harvest: 'Harvest Sep 10',
          batchCode: 'WC-C-003',
        ),
        StockItem(
          id: 'i8',
          strain: 'Northern Lights',
          size: '3.5g',
          sku: 'GK-NL-C-002-3.5G-001',
          qty: 12,
          harvest: 'Harvest Jul 20',
          batchCode: 'NL-C-002',
        ),
        StockItem(
          id: 'i9',
          strain: 'Blue Dream',
          size: '1g',
          sku: 'GK-BD-PRE-1G-001',
          qty: 20,
          harvest: 'Pre-pack demo',
          batchCode: 'BD-S-007',
        ),
      ];

  static List<GrowArea> areas() => [
        GrowArea(
          id: 'a1',
          name: 'Mother Room',
          kind: 'Mother',
          capacity: '12 plant capacity',
        ),
        GrowArea(
          id: 'a2',
          name: 'Clone Room',
          kind: 'Clone',
          capacity: '200 plant capacity',
        ),
        GrowArea(
          id: 'a3',
          name: 'Veg Room',
          kind: 'Veg',
          capacity: '80 plant capacity',
        ),
        GrowArea(
          id: 'a4',
          name: 'Flower Room',
          kind: 'Flower',
          capacity: '60 plant capacity',
        ),
        GrowArea(
          id: 'a5',
          name: 'Dry Room',
          kind: 'Dry',
          capacity: 'No capacity set',
        ),
        GrowArea(
          id: 'a6',
          name: 'Packaging Room',
          kind: 'Packaging',
          capacity: 'No capacity set',
        ),
      ];

  static List<MotherPlant> mothers() => [
        MotherPlant(
          id: 'm1',
          code: 'WC-M-001',
          strain: 'Wedding Cake',
          status: 'Maintenance',
        ),
        MotherPlant(
          id: 'm2',
          code: 'GG-M-001',
          strain: 'Gorilla Glue',
          status: 'Recovery',
        ),
        MotherPlant(
          id: 'm3',
          code: 'BD-M-001',
          strain: 'Blue Dream',
          status: 'Active',
        ),
        MotherPlant(
          id: 'm4',
          code: 'OG-M-002',
          strain: 'OG Kush',
          status: 'Quarantine',
        ),
      ];

  static List<SeedLot> seedLots() => [
        SeedLot(id: 's1', name: 'OG-SEED-04', strain: 'OG Kush', qty: 42),
        SeedLot(id: 's2', name: 'BD-SEED-07', strain: 'Blue Dream', qty: 18),
        SeedLot(id: 's3', name: 'PH-SEED-02', strain: 'Purple Haze', qty: 30),
        SeedLot(id: 's4', name: 'NL-SEED-01', strain: 'Northern Lights', qty: 55),
      ];

  static List<StoreOrder> orders() => [
        StoreOrder(
          id: 'o1',
          client: 'Green Leaf Dispensary',
          status: 'Packed',
          total: 'R 4,200',
          when: 'Sep 12',
        ),
        StoreOrder(
          id: 'o2',
          client: 'Harbour Wellness',
          status: 'Draft',
          total: 'R 1,150',
          when: 'Sep 14',
        ),
        StoreOrder(
          id: 'o3',
          client: 'Cape Botanicals',
          status: 'Shipped',
          total: 'R 2,850',
          when: 'Sep 10',
        ),
        StoreOrder(
          id: 'o4',
          client: 'Green Leaf Dispensary',
          status: 'Delivered',
          total: 'R 6,100',
          when: 'Sep 3',
        ),
        StoreOrder(
          id: 'o5',
          client: 'Mountain View Collective',
          status: 'Processing',
          total: 'R 980',
          when: 'Sep 15',
        ),
      ];

  /// Empty by default to match Sales prototype empty states.
  static List<Invoice> invoices() => [];

  static List<ClientRecord> clients() => [
        ClientRecord(
          id: 'c1',
          name: 'Green Leaf Lounge',
          license: 'LIC-8891',
          email: 'alex@greenleaf.example',
        ),
        ClientRecord(
          id: 'c2',
          name: 'Harbour Wellness',
          license: 'LIC-2204',
          email: 'buy@harbour.example',
        ),
      ];

  /// Empty by default to match Payments prototype empty state.
  static List<Payment> payments() => [];

  /// Route-specific demo metrics for report screens.
  static List<String> reportLines(String route, AppState app) {
    final active = app.activeBatches.length;
    final stockQty = app.stock.fold<int>(0, (p, e) => p + e.qty);
    final openTasks = app.tasks.where((t) => !t.done).length;
    final drying = app.batches.where((b) => b.stage == 'Drying').length;
    final packaged = app.batches.where((b) => b.stage == 'Packaged').length;

    if (route.contains('yield')) {
      return [
        'Avg wet weight / plant: 236 g',
        'Avg trim yield / plant: 175 g',
        'Best performer: GG-C-002 (Gorilla Glue)',
        'Harvest window: Sep 1 – Sep 12',
      ];
    }
    if (route.contains('environment')) {
      return [
        'Tent 1 avg: 24°C · 58% RH',
        'Tunnel A avg: 22°C · 65% RH',
        'Drying room: 21°C · 58% RH',
        '2 climate alerts this week',
      ];
    }
    if (route.contains('movement')) {
      return [
        'Stock out: 42 units → Green Leaf',
        'Packaged: 18 units WC-C-003',
        'Transferred: 6 plants Tent 1 → Tent 2',
      ];
    }
    if (route.contains('compliance')) {
      return [
        'Trace codes linked: 100%',
        'Daily logs completed: 94%',
        'Open CAPA items: 0',
        'Audit-ready batches: 3',
      ];
    }
    if (route.contains('waste')) {
      return [
        'Trim waste (Sep): 4.2 kg',
        'Plant waste: 1.1 kg',
        'Disposed per SOP: 100%',
      ];
    }
    if (route.contains('genealogy')) {
      return [
        'Mothers tracked: ${app.mothers.length}',
        'Clone batches linked: 4',
        'Seed lots active: ${app.seedLots.length}',
      ];
    }

    return [
      '$active active batches',
      '$stockQty packaged units in inventory',
      '$openTasks open field tasks',
      '$drying lots in drying · $packaged packaged lots',
      '${app.orders.length} store orders this month',
      '${app.payments.length} payments recorded',
    ];
  }
}
