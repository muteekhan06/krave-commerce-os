import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/models/models.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';

class CustomerAppScreen extends StatefulWidget {
  const CustomerAppScreen({super.key});

  @override
  State<CustomerAppScreen> createState() => _CustomerAppScreenState();
}

class _CustomerAppScreenState extends State<CustomerAppScreen> {
  int _currentTabIndex = 0; // 0: Menu, 1: Rewards, 2: Track, 3: Support
  String _selectedCategory = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.surface50,
      appBar: _buildAppBar(context, state),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentTabIndex,
            children: [
              _buildMenuTab(context, state),
              _buildRewardsTab(context, state),
              _buildTrackTab(context, state),
              _buildSupportTab(context, state),
            ],
          ),

          // Floating Thumb-Zone Tray Button
          if (state.trayCount > 0 && _currentTabIndex == 0)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _buildFloatingTrayBar(context, state),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, state),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AppState state) {
    return AppBar(
      backgroundColor: AppColors.surface950,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.brand700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'KR',
                style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'KRAVE Burgers',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: AppColors.brand700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'DIRECT',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showBranchSelector(context, state),
                child: Row(
                  children: [
                    Text(
                      '${state.currentBranch.name} • ',
                      style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.surface400),
                    ),
                    Text(
                      'Open Now',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.emerald400,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: AppColors.surface400, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => state.toggleLanguage(),
          child: Text(
            state.isUrdu() ? 'English' : 'اردو',
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTab(BuildContext context, AppState state) {
    final filtered = state.catalog.where((item) {
      final matchesCat = _selectedCategory == 'all' || item.category == _selectedCategory;
      final matchesQuery = _searchQuery.isEmpty ||
          item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Hero Banner & Fulfillment Switcher
          _buildHeroBanner(context, state),

          // Featured Items Carousel
          _buildFeaturedCarousel(context, state),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search burgers, loaded fries, shakes...',
                hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.surface400),
                prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.surface500),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.surface200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.surface200),
                ),
              ),
            ),
          ),

          // Sticky Category Chips
          _buildCategoryChips(context),

          // Active In-Flight Order Indicator (if active)
          if (state.activeInFlightOrderId != null)
            _buildInFlightOrderBanner(context, state),

          // Menu Catalog List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: filtered.map((item) => _buildMenuItemCard(context, state, item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context, AppState state) {
    return Container(
      color: AppColors.surface950,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.brand700,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SAVE 15% VS AGGREGATORS',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Artisanal Smash Burgers',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.amber400, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '4.9 (480+ reviews) • ${state.currentBranch.etaRange} mins • PKR ${state.currentBranch.deliveryFee} Deliv',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface300),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=160&auto=format&fit=crop&q=80',
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fulfillment Switcher Toggle (Delivery vs Pickup)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surface800),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => state.setFulfillmentMode('delivery'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: state.fulfillmentMode == 'delivery' ? AppColors.brand700 : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '🛵 Delivery (${state.currentBranch.etaRange}m)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => state.setFulfillmentMode('pickup'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: state.fulfillmentMode == 'pickup' ? AppColors.brand700 : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '🛍️ Takeaway (15m)',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCarousel(BuildContext context, AppState state) {
    final featuredItems = state.catalog.where((i) => i.featured).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 14, bottom: 8),
          child: Text(
            '🔥 Chef Recommended',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.surface900,
            ),
          ),
        ),
        SizedBox(
          height: 175,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: featuredItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = featuredItems[index];
              return Container(
                width: 210,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surface200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 3)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        item.imageUrl,
                        height: 95,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.between,
                            children: [
                              Text(
                                'PKR ${item.price}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.brand700,
                                ),
                              ),
                              InkWell(
                                onTap: () => _openCustomizer(context, state, item),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.brand700,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '+ Add',
                                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    final categories = [
      {'id': 'all', 'label': 'All Dishes'},
      {'id': 'burgers', 'label': 'Smash Burgers'},
      {'id': 'combos', 'label': 'Combos & Fries'},
      {'id': 'shakes', 'label': 'Thick Shakes'},
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['id'];
          return ChoiceChip(
            label: Text(
              cat['label']!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.surface700,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.surface900,
            backgroundColor: AppColors.surface100,
            onSelected: (_) => setState(() => _selectedCategory = cat['id']!),
          );
        },
      ),
    );
  }

  Widget _buildInFlightOrderBanner(BuildContext context, AppState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.emerald500.withOpacity(0.5)),
      ),
      child: InkWell(
        onTap: () => setState(() => _currentTabIndex = 2), // switch to Track tab
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: AppColors.emerald500, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${state.activeInFlightOrderId}: Kitchen Active',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF064E3B)),
                  ),
                  Text(
                    'Tap to view live animated tracking',
                    style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF047857)),
                  ),
                ],
              ),
            ),
            Text(
              'Track →',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFF064E3B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, AppState state, MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surface200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isUrdu() ? item.titleUrdu : item.title,
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.surface500),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      'PKR ${item.price}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brand700,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: item.isSoldOut ? null : () => _openCustomizer(context, state, item),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand700,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        item.isSoldOut ? 'Sold Out' : '+ Add',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingTrayBar(BuildContext context, AppState state) {
    return InkWell(
      onTap: () => _openTrayDrawer(context, state),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.brand700,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.brand700.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${state.trayCount}',
                    style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w900,
                      color: AppColors.brand700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'View Your Tray',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'PKR ${state.finalPayable}',
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsTab(BuildContext context, AppState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DinePass Wallet Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.surface900, AppColors.surface950, AppColors.brand950],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      'KRAVE DINEPASS WALLET',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.amber400,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Icon(Icons.stars, color: AppColors.amber400, size: 22),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'PKR ${state.walletBalance.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '5% Direct Cashback automatically credited on every meal',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface400),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Burger Stamp Card (Buy 4, 5th Free)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surface200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      'Burger Loyalty Stamp Card',
                      style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${state.stampCount}/5 STAMPS',
                      style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.brand700),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final isEarned = index < state.stampCount;
                    final isFreeSlot = index == 4;
                    return Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isEarned
                            ? AppColors.brand700
                            : (isFreeSlot ? AppColors.amber500.withOpacity(0.15) : AppColors.surface100),
                        borderRadius: BorderRadius.circular(12),
                        border: isFreeSlot ? Border.all(color: AppColors.amber500, style: BorderStyle.solid) : null,
                      ),
                      child: Center(
                        child: Text(
                          isEarned ? '✓' : (isFreeSlot ? '🎁 Free' : '#${index + 1}'),
                          style: GoogleFonts.plusJakartaSans(
                            color: isEarned ? Colors.white : (isFreeSlot ? AppColors.amber500 : AppColors.surface500),
                            fontWeight: FontWeight.w800,
                            fontSize: isFreeSlot ? 9 : 12,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Loyalty Transaction Ledger
          Text(
            'Cashback History',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          ...state.loyaltyLog.map(
            (log) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.surface200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(log.description, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700)),
                      Text(log.date, style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.surface500)),
                    ],
                  ),
                  Text(
                    '+PKR ${log.amount}',
                    style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.emerald500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackTab(BuildContext context, AppState state) {
    final activeOrder = state.orders.isNotEmpty ? state.orders.first : null;

    if (activeOrder == null) {
      return Center(
        child: Text('No active orders placed yet.', style: GoogleFonts.plusJakartaSans(color: AppColors.surface500)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surface200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text('Order #${activeOrder.id}', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w900)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        activeOrder.status.name.toUpperCase(),
                        style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.emerald600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ETA Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.brand50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.brand100),
                  ),
                  child: Column(
                    children: [
                      Text('ESTIMATED ARRIVAL', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.brand700)),
                      const SizedBox(height: 4),
                      Text('22 Mins', style: GoogleFonts.jetBrainsMono(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.surface900)),
                      Text('On Schedule • Direct Driver', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.surface600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 5-Stage Stepper
                _buildStepper(context, activeOrder),

                const Divider(height: 28),

                // Rider Telemetry Box
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.surface900, shape: BoxShape.circle),
                      child: const Center(child: Text('TK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tariq Khan (Direct Rider)', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800)),
                          Text('Suzuki GS150 • 4.9★', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.surface500)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling direct relay line: 0300-8291042')),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.surface900),
                      child: const Text('Call', style: TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context, PlatformOrder order) {
    final stages = [
      {'title': 'Order Placed & Validated', 'done': true},
      {'title': 'Kitchen Preparing Patties', 'done': order.status != OrderStatus.inbound},
      {'title': 'Bagged & Ready', 'done': order.status == OrderStatus.ready || order.status == OrderStatus.dispatched || order.status == OrderStatus.delivered},
      {'title': 'Rider En Route', 'done': order.status == OrderStatus.dispatched || order.status == OrderStatus.delivered},
      {'title': 'Delivered to Door', 'done': order.status == OrderStatus.delivered},
    ];

    return Column(
      children: stages.map((s) {
        final isDone = s['done'] as bool;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, color: isDone ? AppColors.emerald500 : AppColors.surface300, size: 16),
              const SizedBox(width: 10),
              Text(
                s['title'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: isDone ? FontWeight.w700 : FontWeight.w400,
                  color: isDone ? AppColors.surface900 : AppColors.surface500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSupportTab(BuildContext context, AppState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surface200),
            ),
            child: Column(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 36, color: AppColors.emerald600),
                const SizedBox(height: 12),
                Text('Direct Kitchen Manager Hotline', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  'No automated bot scripts. Speak directly with the duty manager at DHA Phase 5 on WhatsApp.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface600),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening WhatsApp manager session...')),
                    );
                  },
                  icon: const Icon(Icons.phone, size: 16),
                  label: const Text('Open Direct WhatsApp Chat'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppState state) {
    return NavigationBar(
      selectedIndex: _currentTabIndex,
      onDestinationSelected: (idx) => setState(() => _currentTabIndex = idx),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
        NavigationDestination(icon: Icon(Icons.wallet_giftcard), label: 'Rewards'),
        NavigationDestination(icon: Icon(Icons.navigation), label: 'Track'),
        NavigationDestination(icon: Icon(Icons.support_agent), label: 'Support'),
      ],
    );
  }

  void _openCustomizer(BuildContext context, AppState state, MenuItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CustomizerSheet(item: item),
    );
  }

  void _openTrayDrawer(BuildContext context, AppState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _TrayDrawerSheet(),
    );
  }

  void _showBranchSelector(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Branch'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: state.branches.map((b) {
            return ListTile(
              title: Text(b.name),
              subtitle: Text(b.area),
              trailing: Text('PKR ${b.deliveryFee}'),
              onTap: () {
                state.setBranch(b);
                Navigator.of(ctx).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Item Customizer Bottom Sheet
class _CustomizerSheet extends StatefulWidget {
  final MenuItem item;
  const _CustomizerSheet({required this.item});

  @override
  State<_CustomizerSheet> createState() => _CustomizerSheetState();
}

class _CustomizerSheetState extends State<_CustomizerSheet> {
  int _qty = 1;
  String _selectedPatty = 'Single Smash (100g)';
  int _pattyPriceDelta = 0;
  String _selectedBun = 'Brioche Bun';
  late String _selectedSauce;
  final List<String> _selectedAddons = [];
  bool _isCombo = false;

  @override
  void initState() {
    super.initState();
    _selectedSauce = widget.item.availableSauces.isNotEmpty ? widget.item.availableSauces.first : 'None';
  }

  int get _calculatedPrice {
    int base = widget.item.price + _pattyPriceDelta;
    if (_isCombo) base += 350;
    for (final add in widget.item.addons) {
      if (_selectedAddons.contains(add.label)) {
        base += add.price;
      }
    }
    return base * _qty;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header Picture
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(widget.item.imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(widget.item.title, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
                Text(widget.item.description, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface500)),
                const Divider(height: 24),

                // Patty option
                Text('1. Patty Configuration', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13)),
                RadioListTile<String>(
                  title: const Text('Single Smash (100g)'),
                  value: 'Single Smash (100g)',
                  groupValue: _selectedPatty,
                  onChanged: (v) => setState(() {
                    _selectedPatty = v!;
                    _pattyPriceDelta = 0;
                  }),
                ),
                RadioListTile<String>(
                  title: const Text('Double Smash (200g) (+PKR 350)'),
                  value: 'Double Smash (200g)',
                  groupValue: _selectedPatty,
                  onChanged: (v) => setState(() {
                    _selectedPatty = v!;
                    _pattyPriceDelta = 350;
                  }),
                ),

                const Divider(height: 24),

                // Sauce selection
                if (widget.item.availableSauces.isNotEmpty) ...[
                  Text('2. Signature Sauce', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13)),
                  Wrap(
                    spacing: 8,
                    children: widget.item.availableSauces.map((sauce) {
                      return ChoiceChip(
                        label: Text(sauce),
                        selected: _selectedSauce == sauce,
                        onSelected: (_) => setState(() => _selectedSauce = sauce),
                      );
                    }).toList(),
                  ),
                  const Divider(height: 24),
                ],

                // Combo Upgrade
                SwitchListTile(
                  title: const Text('🍟 Make it a Combo (+PKR 350)'),
                  subtitle: const Text('Includes Medium Fries + Gourmet Cola'),
                  value: _isCombo,
                  onChanged: (v) => setState(() => _isCombo = v),
                ),
              ],
            ),
          ),

          // Footer Commit
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.surface200))),
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: _qty > 1 ? () => setState(() => _qty--) : null, icon: const Icon(Icons.remove)),
                    Text('$_qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    IconButton(onPressed: () => setState(() => _qty++), icon: const Icon(Icons.add)),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      state.addToTray(
                        CartItem(
                          id: DateTime.now().toString(),
                          item: widget.item,
                          quantity: _qty,
                          unitPrice: _calculatedPrice ~/ _qty,
                          selectedPatty: _selectedPatty,
                          selectedBun: _selectedBun,
                          selectedSauce: _selectedSauce,
                          selectedAddons: _selectedAddons,
                          isCombo: _isCombo,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text('Add to Tray • PKR $_calculatedPrice'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tray Drawer Sheet
class _TrayDrawerSheet extends StatelessWidget {
  const _TrayDrawerSheet();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text('Your Order Tray', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800)),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.tray.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final item = state.tray[i];
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${item.selectedPatty} • ${item.selectedSauce}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('PKR ${item.totalItemPrice}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brand700)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => state.removeFromTray(i),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    const Text('Total Payable:'),
                    Text('PKR ${state.finalPayable}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  onPressed: () {
                    final orderId = state.placeOrder(
                      name: 'Zaid Ahmed',
                      phone: '0300-8291042',
                      address: 'House 42-B, DHA Phase 5',
                      paymentMethod: 'COD',
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order #$orderId placed successfully! Direct Cashback credited.')),
                    );
                  },
                  child: const Text('Authorize & Place Direct Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
