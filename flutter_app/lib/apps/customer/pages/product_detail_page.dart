import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/models/models.dart';
import '../../../core/state/app_state.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/krave_toast.dart';

class ProductDetailPage extends StatefulWidget {
  final MenuItem item;

  const ProductDetailPage({super.key, required this.item});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  bool _isFavorite = false;

  // Customization Options
  String _selectedPatty = 'Single Smash (100g)';
  int _pattyPriceDelta = 0;

  String _selectedBun = 'Butter-Toasted Brioche';
  int _bunPriceDelta = 0;

  late String _selectedSauce;
  String _selectedSpice = 'Medium Hot (2🌶️)';
  final Set<String> _selectedAddons = {};
  int _addonsPriceTotal = 0;

  bool _isCombo = false;
  final TextEditingController _notesController = TextEditingController();

  final List<String> _quickNoteChips = const [
    'Sauce on the side',
    'Extra crispy fries',
    'Cut burger in half',
    'No pickles',
    'Extra napkins',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSauce = widget.item.availableSauces.isNotEmpty
        ? widget.item.availableSauces.first
        : 'Krave Secret Sauce';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  int get _unitPrice {
    int price = widget.item.price + _pattyPriceDelta + _bunPriceDelta + _addonsPriceTotal;
    if (_isCombo) price += 380;
    return price;
  }

  int get _totalPrice => _unitPrice * _quantity;

  void _recalcAddonsPrice() {
    int sum = 0;
    for (final addon in widget.item.addons) {
      if (_selectedAddons.contains(addon.label)) {
        sum += addon.price;
      }
    }
    setState(() {
      _addonsPriceTotal = sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Direct Savings Banner
                      _buildDirectSavingsCard(),
                      const SizedBox(height: 16),

                      // Title & Price Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.isUrdu() ? widget.item.titleUrdu : widget.item.title,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.surface900,
                                    height: 1.2,
                                  ),
                                ),
                                if (state.isUrdu())
                                  Text(
                                    widget.item.title,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppColors.surface500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'PKR ${widget.item.price}',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.brand700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Dietary & Nutritional Pills
                      _buildNutritionalTelemetry(),
                      const SizedBox(height: 16),

                      // Story Narrative Description
                      Text(
                        widget.item.description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          color: AppColors.surface700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(height: 1, color: Color(0xFFE5E7EB)),
                      const SizedBox(height: 20),

                      // Step 1: Patty / Size Tier
                      _buildSectionHeader('1. Select Patty Size Tier', 'Choose single, double, or triple patty'),
                      const SizedBox(height: 12),
                      _buildPattyTierSelector(),
                      const SizedBox(height: 24),

                      // Step 2: Artisanal Bun
                      _buildSectionHeader('2. Choose Artisanal Bun', 'Baked fresh every morning'),
                      const SizedBox(height: 12),
                      _buildBunSelector(),
                      const SizedBox(height: 24),

                      // Step 3: Signature Sauce
                      _buildSectionHeader('3. Signature Kitchen Sauce', 'House-churned recipes (select 1)'),
                      const SizedBox(height: 12),
                      _buildSauceSelector(),
                      const SizedBox(height: 24),

                      // Step 4: Spice Level
                      if (widget.item.isSpicy) ...[
                        _buildSectionHeader('4. Spice Heat Level', 'Adjust fire intensity'),
                        const SizedBox(height: 12),
                        _buildSpiceSelector(),
                        const SizedBox(height: 24),
                      ],

                      // Step 5: Gourmet Add-ons
                      if (widget.item.addons.isNotEmpty) ...[
                        _buildSectionHeader('5. Gourmet Extras & Add-ons', 'Elevate your smash experience'),
                        const SizedBox(height: 12),
                        _buildAddonsList(),
                        const SizedBox(height: 24),
                      ],

                      // Step 6: Meal Combo Upgrade
                      _buildMealComboCard(),
                      const SizedBox(height: 24),

                      // Step 7: Special Instructions
                      _buildSectionHeader('Special Kitchen Instructions', 'Tell the chef your exact preference'),
                      const SizedBox(height: 10),
                      _buildKitchenNotesInput(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Bottom Floating Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStickyBottomBar(context, state),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.surface950,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.55),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.55),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: _isFavorite ? Colors.redAccent : Colors.white,
                size: 20,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                setState(() => _isFavorite = !_isFavorite);
                KraveToast.show(
                  context,
                  message: _isFavorite ? 'Saved to Favorites ❤️' : 'Removed from Favorites',
                  type: ToastType.info,
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.55),
            child: IconButton(
              icon: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
              onPressed: () {
                HapticFeedback.lightImpact();
                Clipboard.setData(ClipboardData(text: 'Check out the ${widget.item.title} on KRAVE Direct! https://krave.pk/menu/${widget.item.id}'));
                KraveToast.show(
                  context,
                  title: 'Link Copied',
                  message: 'Direct product link copied to clipboard!',
                  type: ToastType.success,
                );
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'item_img_${widget.item.id}',
              child: Image.network(
                widget.item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surface800,
                  child: const Center(
                    child: Icon(Icons.lunch_dining_rounded, size: 64, color: AppColors.surface500),
                  ),
                ),
              ),
            ),
            // Gradient scrim
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black45,
                    Colors.transparent,
                    Colors.black68,
                  ],
                ),
              ),
            ),
            // Floating badge on hero
            if (widget.item.badge != null)
              Positioned(
                bottom: 16,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.brand700,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.item.badge!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectSavingsCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5), // Emerald light
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.emerald500.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.emerald600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.verified_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DIRECT RESTAURANT PRICING',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF065F46),
                  ),
                ),
                Text(
                  'You save PKR ${widget.item.savingsVsAggregator} vs Foodpanda / UberEats markups',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF047857),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalTelemetry() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildTelemetryChip('🥩 100% Angus Beef'),
        _buildTelemetryChip('⏱️ ${widget.item.prepTime} Fresh'),
        _buildTelemetryChip('🔥 ${widget.item.calories} kcal'),
        _buildTelemetryChip('💪 ${widget.item.proteinGrams}g Protein'),
        if (widget.item.isSpicy)
          _buildTelemetryChip('🌶️ Fiery Hot', color: Colors.red.shade100, textColor: Colors.red.shade800),
      ],
    );
  }

  Widget _buildTelemetryChip(String text, {Color? color, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surface200),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor ?? AppColors.surface700,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.surface900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: AppColors.surface500,
          ),
        ),
      ],
    );
  }

  Widget _buildPattyTierSelector() {
    final tiers = [
      {'label': 'Single Smash (100g)', 'sub': 'Classic smash on cast iron', 'delta': 0},
      {'label': 'Double Smash (200g)', 'sub': 'Chef recommended double stack', 'delta': 400},
      {'label': 'Triple Beast (300g)', 'sub': 'Carnivore beast mode', 'delta': 750},
    ];

    return Column(
      children: tiers.map((tier) {
        final isSelected = _selectedPatty == tier['label'];
        final delta = tier['delta'] as int;

        return InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              _selectedPatty = tier['label'] as String;
              _pattyPriceDelta = delta;
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFEF2F2) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.brand700 : const Color(0xFFE5E7EB),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.brand700 : AppColors.surface400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tier['label'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? AppColors.brand700 : AppColors.surface900,
                        ),
                      ),
                      Text(
                        tier['sub'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: AppColors.surface500,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  delta == 0 ? 'Included' : '+ PKR $delta',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? AppColors.brand700 : AppColors.surface600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBunSelector() {
    final buns = [
      {'label': 'Butter-Toasted Brioche', 'delta': 0},
      {'label': 'Sesame Potato Roll', 'delta': 50},
      {'label': 'Keto Lettuce Wrap', 'delta': 0},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: buns.map((bun) {
        final isSelected = _selectedBun == bun['label'];
        final delta = bun['delta'] as int;

        return ChoiceChip(
          label: Text(
            delta == 0 ? bun['label'] as String : '${bun['label']} (+PKR $delta)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.surface800,
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.surface900,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? AppColors.surface900 : const Color(0xFFD1D5DB),
            ),
          ),
          onSelected: (_) {
            HapticFeedback.selectionClick();
            setState(() {
              _selectedBun = bun['label'] as String;
              _bunPriceDelta = delta;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSauceSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.item.availableSauces.map((sauce) {
        final isSelected = _selectedSauce == sauce;
        return ChoiceChip(
          label: Text(
            sauce,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.surface800,
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.brand700,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? AppColors.brand700 : const Color(0xFFD1D5DB),
            ),
          ),
          onSelected: (_) {
            HapticFeedback.selectionClick();
            setState(() => _selectedSauce = sauce);
          },
        );
      }).toList(),
    );
  }

  Widget _buildSpiceSelector() {
    final spices = ['Mild (1🌶️)', 'Medium Hot (2🌶️)', 'Nashville Fiery (3🌶️)'];
    return Wrap(
      spacing: 8,
      children: spices.map((s) {
        final isSelected = _selectedSpice == s;
        return ChoiceChip(
          label: Text(
            s,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.surface800,
            ),
          ),
          selected: isSelected,
          selectedColor: Colors.deepOrange.shade700,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? Colors.deepOrange.shade700 : const Color(0xFFD1D5DB),
            ),
          ),
          onSelected: (_) {
            HapticFeedback.selectionClick();
            setState(() => _selectedSpice = s);
          },
        );
      }).toList(),
    );
  }

  Widget _buildAddonsList() {
    return Column(
      children: widget.item.addons.map((addon) {
        final isChecked = _selectedAddons.contains(addon.label);
        return InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              if (isChecked) {
                _selectedAddons.remove(addon.label);
              } else {
                _selectedAddons.add(addon.label);
              }
              _recalcAddonsPrice();
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isChecked ? AppColors.brand700 : const Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                  color: isChecked ? AppColors.brand700 : AppColors.surface400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    addon.label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: isChecked ? FontWeight.w800 : FontWeight.w600,
                      color: AppColors.surface900,
                    ),
                  ),
                ),
                Text(
                  '+ PKR ${addon.price}',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isChecked ? AppColors.brand700 : AppColors.surface600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMealComboCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCombo ? const Color(0xFFFFFBEB) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isCombo ? AppColors.amber500 : const Color(0xFFE5E7EB),
          width: _isCombo ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isCombo ? AppColors.amber500 : AppColors.surface100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.fastfood_rounded,
              color: _isCombo ? Colors.white : AppColors.surface600,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upgrade to Feast Combo (+PKR 380)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.surface900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Adds Skin-On Seasoned Fries + Gourmet Drink + Aioli Dip',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    color: AppColors.surface600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isCombo,
            activeColor: AppColors.amber500,
            onChanged: (v) {
              HapticFeedback.lightImpact();
              setState(() => _isCombo = v);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKitchenNotesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: _quickNoteChips.map((chip) {
            return InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (_notesController.text.isEmpty) {
                    _notesController.text = chip;
                  } else if (!_notesController.text.contains(chip)) {
                    _notesController.text += ', $chip';
                  }
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.surface300),
                ),
                child: Text(
                  '+ $chip',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.surface700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _notesController,
          maxLines: 2,
          style: GoogleFonts.plusJakartaSans(fontSize: 12),
          decoration: InputDecoration(
            hintText: 'Any allergies, preparation instructions, or preferences...',
            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.brand700, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar(BuildContext context, AppState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity Stepper
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surface300),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded, size: 18),
                  onPressed: _quantity > 1
                      ? () {
                          HapticFeedback.lightImpact();
                          setState(() => _quantity--);
                        }
                      : null,
                ),
                Text(
                  '$_quantity',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.surface900,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded, size: 18),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => _quantity++);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Add to Tray Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand700,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: AppColors.brand700.withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                final itemToAdd = CartItem(
                  id: '${widget.item.id}_${DateTime.now().millisecondsSinceEpoch}',
                  item: widget.item,
                  quantity: _quantity,
                  unitPrice: _unitPrice,
                  selectedPatty: _selectedPatty,
                  selectedBun: _selectedBun,
                  selectedSauce: _selectedSauce,
                  selectedSpice: widget.item.isSpicy ? _selectedSpice : null,
                  selectedAddons: _selectedAddons.toList(),
                  isCombo: _isCombo,
                  kitchenNote: _notesController.text.trim(),
                );

                state.addToTray(itemToAdd);

                Navigator.of(context).pop();

                KraveToast.show(
                  context,
                  title: 'Added to Tray! 🔥',
                  message: '${widget.item.title} (x$_quantity) added. Direct Cashback calculated.',
                  type: ToastType.success,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Add to Tray • PKR $_totalPrice',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
