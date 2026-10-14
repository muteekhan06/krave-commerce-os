import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  // Locale & Mode
  String language = 'en'; // 'en' | 'ur'
  bool isUrdu() => language == 'ur';

  void toggleLanguage() {
    language = language == 'en' ? 'ur' : 'en';
    notifyListeners();
  }

  // Active Branch
  final List<Branch> branches = const [
    Branch(id: 'dha5', name: 'DHA Phase 5', area: 'Defence, Karachi', etaRange: '25-35', deliveryFee: 150),
    Branch(id: 'clifton', name: 'Clifton Block 5', area: 'Clifton, Karachi', etaRange: '30-40', deliveryFee: 150),
    Branch(id: 'gulshan', name: 'Gulshan-e-Iqbal', area: 'Gulshan, Karachi', etaRange: '35-45', deliveryFee: 200),
  ];

  late Branch currentBranch;

  // Fulfillment Mode: 'delivery' | 'pickup'
  String fulfillmentMode = 'delivery';

  void setFulfillmentMode(String mode) {
    fulfillmentMode = mode;
    notifyListeners();
  }

  void setBranch(Branch b) {
    currentBranch = b;
    notifyListeners();
  }

  // Master Catalog
  late List<MenuItem> catalog;

  // Cart Tray
  final List<CartItem> tray = [];
  bool promoApplied = false;
  int promoDiscountPct = 0; // 15% when DIRECT15 applied
  bool applyDinePassWallet = true;

  // Customer Loyalty & Wallet
  double walletBalance = 340.0;
  int stampCount = 3; // out of 5
  final List<LoyaltyLog> loyaltyLog = [
    const LoyaltyLog(date: 'Today, 12:35 PM', description: '5% cashback · Original Double Smash', amount: 62),
    const LoyaltyLog(date: 'Yesterday, 8:15 PM', description: '5% cashback · Nashville Hot Combo', amount: 57),
    const LoyaltyLog(date: 'Oct 12, 7:30 PM', description: 'Referral reward credited', amount: 300),
    const LoyaltyLog(date: 'Oct 11, 1:10 PM', description: '5% cashback · Duo Feast Combo', amount: 142),
  ];

  // Orders State
  late List<PlatformOrder> orders;
  int sequenceCounter = 1042;
  String? activeInFlightOrderId;

  // Kitchen KDS State
  String kdsStationFilter = 'all'; // 'all' | 'grill' | 'fryer' | 'expedite'
  bool isKitchenBusy = false;

  void toggleKitchenBusy() {
    isKitchenBusy = !isKitchenBusy;
    notifyListeners();
  }

  void setKdsStationFilter(String station) {
    kdsStationFilter = station;
    notifyListeners();
  }

  // Rider Fleet State
  bool isRiderOnline = true;
  int riderCodBagAmount = 3450;
  int riderTodayDeliveriesCount = 7;

  void toggleRiderOnline() {
    isRiderOnline = !isRiderOnline;
    notifyListeners();
  }

  Timer? _tickerTimer;

  AppState() {
    currentBranch = branches[0];
    _initCatalog();
    _initOrders();
    _startTicketTicker();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }

  void _startTicketTicker() {
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      bool shouldNotify = false;
      for (final o in orders) {
        if (o.status == OrderStatus.inbound || o.status == OrderStatus.preparing) {
          o.elapsedSeconds++;
          shouldNotify = true;
        }
      }
      if (shouldNotify) {
        notifyListeners();
      }
    });
  }

  void _initCatalog() {
    catalog = [
      MenuItem(
        id: 'smash-01',
        category: 'burgers',
        station: 'grill',
        featured: true,
        title: 'Original Double Smash',
        titleUrdu: 'اوریجنل ڈبل سمیش برگر',
        description: 'Two 100% grass-fed beef smash patties, double aged cheddar, dill pickles, secret sauce on toasted brioche.',
        price: 1250,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=80',
        badge: 'Best Seller',
        dietary: ['beef'],
        isSpicy: false,
        availableSauces: ['Krave Secret Sauce', 'Smoked Garlic Aioli', 'Classic Ketchup', 'Sriracha Mayo', 'No Sauce'],
        addons: const [
          ModifierOption(id: 'cheese', label: 'Melted American Cheddar', price: 120),
          ModifierOption(id: 'bacon', label: 'Smoked Beef Bacon', price: 220),
          ModifierOption(id: 'egg', label: 'Sunny Fried Egg', price: 80),
          ModifierOption(id: 'jalapenos', label: 'Pickled Jalapeños', price: 60),
        ],
      ),
      MenuItem(
        id: 'smash-02',
        category: 'burgers',
        station: 'grill',
        featured: true,
        title: 'Truffle Mushroom Melt',
        titleUrdu: 'ٹرفل مشروم میلٹ برگر',
        description: 'Smashed beef patty, sautéed garlic mushrooms, Swiss Gruyère cheese melt, black truffle aioli.',
        price: 1450,
        imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=600&auto=format&fit=crop&q=80',
        badge: 'Chef Choice',
        dietary: ['beef'],
        isSpicy: false,
        availableSauces: ['Truffle Aioli', 'Garlic Butter Sauce', 'Classic Ketchup', 'No Sauce'],
        addons: const [
          ModifierOption(id: 'gruyere', label: 'Extra Swiss Gruyère', price: 150),
          ModifierOption(id: 'mush', label: 'Extra Mushrooms', price: 100),
          ModifierOption(id: 'bacon', label: 'Beef Bacon Strips', price: 220),
        ],
      ),
      MenuItem(
        id: 'chicken-01',
        category: 'burgers',
        station: 'fryer',
        featured: true,
        title: 'Nashville Hot Crispy Chicken',
        titleUrdu: 'نیش وِل ہاٹ کرسپی چکن',
        description: '24hr buttermilk-soaked fried chicken thigh, fiery Cayenne chili oil glaze, sweet southern slaw, dill chips.',
        price: 1150,
        imageUrl: 'https://images.unsplash.com/photo-1625813506062-0aeb1d7a094b?w=600&auto=format&fit=crop&q=80',
        badge: 'Spicy 🌶️',
        dietary: ['chicken'],
        isSpicy: true,
        availableSauces: ['Nashville Honey Butter', 'Buttermilk Ranch', 'Classic Ketchup', 'Extra Hot Sauce', 'No Sauce'],
        addons: const [
          ModifierOption(id: 'slaw', label: 'Extra Southern Slaw', price: 60),
          ModifierOption(id: 'pepperjack', label: 'Pepper Jack Cheese', price: 120),
          ModifierOption(id: 'pickles', label: 'Extra Dill Pickles', price: 40),
        ],
      ),
      MenuItem(
        id: 'fries-01',
        category: 'combos',
        station: 'fryer',
        featured: false,
        title: 'Loaded Animal Fries',
        titleUrdu: 'اینیمل فرائز لوڈڈ',
        description: 'Skin-on golden fries smothered in melted cheddar sauce, caramelized onions, grilled beef crumbles, signature dressing.',
        price: 650,
        imageUrl: 'https://images.unsplash.com/photo-1585109649139-366815a0d713?w=600&auto=format&fit=crop&q=80',
        badge: 'Shareable',
        dietary: ['beef'],
        isSpicy: false,
        availableSauces: ['Cheddar Sauce', 'Krave Secret Sauce', 'Mayo', 'No Sauce'],
        addons: const [
          ModifierOption(id: 'extra_cheese', label: 'Extra Cheddar Sauce', price: 80),
          ModifierOption(id: 'extra_beef', label: 'Extra Beef Crumbles', price: 140),
        ],
      ),
      MenuItem(
        id: 'combo-01',
        category: 'combos',
        station: 'grill',
        featured: false,
        title: 'KRAVE Duo Feast Combo',
        titleUrdu: 'کِریو ڈو فیسٹ کومبو',
        description: '2 Original Double Smashes, 1 Large Animal Fries, 2 Gourmet Colas, 2 Smoked Garlic Aioli dips.',
        price: 2850,
        imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&auto=format&fit=crop&q=80',
        badge: 'Save 20%',
        dietary: ['beef'],
        isSpicy: false,
        availableSauces: ['Garlic Aioli', 'Krave Secret Sauce', 'No Sauce'],
        addons: const [
          ModifierOption(id: 'drink_large', label: 'Upgrade to Large Cola', price: 80),
          ModifierOption(id: 'extra_dip', label: 'Extra Dip Tub', price: 50),
        ],
      ),
      MenuItem(
        id: 'shake-01',
        category: 'shakes',
        station: 'expedite',
        featured: false,
        title: 'Lotus Biscoff Thick Shake',
        titleUrdu: 'لوٹس بسکوف تھک شیک',
        description: 'Artisanal vanilla bean custard blended with caramelized Biscoff spread, crushed Belgian biscuits, whipped cream.',
        price: 620,
        imageUrl: 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=600&auto=format&fit=crop&q=80',
        badge: 'Sweet',
        dietary: [],
        isSpicy: false,
        availableSauces: [],
        addons: const [
          ModifierOption(id: 'extra_cream', label: 'Extra Whipped Cream', price: 60),
          ModifierOption(id: 'biscoff_drizzle', label: 'Extra Biscoff Drizzle', price: 80),
        ],
      ),
    ];
  }

  void _initOrders() {
    orders = [
      PlatformOrder(
        id: 'BL-1041',
        customerName: 'Hamza Malik',
        phone: '0321-4455667',
        address: 'Plot 18-C, 24th Commercial St, DHA Phase 2 Ext',
        fulfillmentType: 'DELIVERY',
        paymentMethod: 'COD',
        status: OrderStatus.preparing,
        elapsedSeconds: 380,
        station: 'grill',
        timestamp: '12:35 PM',
        items: [
          OrderItemSummary(title: 'Original Double Smash', quantity: 2, price: 1250, modifiers: ['Double Patty', 'Extra Cheddar']),
          OrderItemSummary(title: 'Loaded Animal Fries', quantity: 1, price: 650, modifiers: []),
        ],
        subtotal: 3150,
        deliveryFee: 150,
        discount: 0,
        total: 3300,
        riderPickupState: 'assigned',
      ),
      PlatformOrder(
        id: 'BL-1040',
        customerName: 'Sara Farooq',
        phone: '0312-9988776',
        address: 'House 7, Street 12, Clifton Block 5',
        fulfillmentType: 'DELIVERY',
        paymentMethod: 'RAAST',
        status: OrderStatus.ready,
        elapsedSeconds: 720,
        station: 'fryer',
        timestamp: '12:15 PM',
        items: [
          OrderItemSummary(title: 'Nashville Hot Crispy Chicken', quantity: 1, price: 1150, modifiers: ['Extra Hot']),
          OrderItemSummary(title: 'Lotus Biscoff Thick Shake', quantity: 1, price: 620, modifiers: []),
        ],
        subtotal: 1770,
        deliveryFee: 150,
        discount: 0,
        total: 1920,
        riderPickupState: 'arrived',
      ),
    ];
  }

  // --- Cart Calculations ---
  int get trayCount => tray.fold(0, (sum, item) => sum + item.quantity);

  int get traySubtotal => tray.fold(0, (sum, item) => sum + item.totalItemPrice);

  int get promoDiscount => (traySubtotal * (promoDiscountPct / 100)).round();

  int get deliveryFee => fulfillmentMode == 'delivery' ? currentBranch.deliveryFee : 0;

  int get sstTax => (traySubtotal * 0.16).round();

  int get grossTotal => traySubtotal - promoDiscount + deliveryFee;

  int get walletDeduction {
    if (!applyDinePassWallet) return 0;
    return walletBalance > grossTotal ? grossTotal : walletBalance.toInt();
  }

  int get finalPayable => (grossTotal - walletDeduction) < 0 ? 0 : (grossTotal - walletDeduction);

  void addToTray(CartItem item) {
    tray.add(item);
    notifyListeners();
  }

  void removeFromTray(int index) {
    if (index >= 0 && index < tray.length) {
      tray.removeAt(index);
      notifyListeners();
    }
  }

  void updateTrayItemQuantity(int index, int delta) {
    if (index >= 0 && index < tray.length) {
      tray[index].quantity += delta;
      if (tray[index].quantity <= 0) {
        tray.removeAt(index);
      }
      notifyListeners();
    }
  }

  void applyPromoCode(String code) {
    if (code.trim().toUpperCase() == 'DIRECT15') {
      promoApplied = true;
      promoDiscountPct = 15;
      notifyListeners();
    }
  }

  void toggleDinePassWallet(bool val) {
    applyDinePassWallet = val;
    notifyListeners();
  }

  // --- Order Placement ---
  String placeOrder({
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
  }) {
    sequenceCounter++;
    final orderId = 'BL-$sequenceCounter';

    final newOrder = PlatformOrder(
      id: orderId,
      customerName: name.isEmpty ? 'Zaid Ahmed' : name,
      phone: phone.isEmpty ? '0300-8291042' : phone,
      address: address.isEmpty ? 'House 42-B, DHA Phase 5' : address,
      fulfillmentType: fulfillmentMode.toUpperCase(),
      paymentMethod: paymentMethod,
      status: OrderStatus.inbound,
      station: 'grill',
      timestamp: 'Just now',
      items: tray
          .map((c) => OrderItemSummary(
                title: c.item.title,
                quantity: c.quantity,
                price: c.unitPrice,
                modifiers: [
                  c.selectedPatty,
                  c.selectedBun,
                  c.selectedSauce,
                  ...c.selectedAddons,
                  if (c.isCombo) 'Combo Meal (+PKR 350)',
                ],
              ))
          .toList(),
      subtotal: traySubtotal,
      deliveryFee: deliveryFee,
      discount: promoDiscount,
      total: finalPayable,
    );

    orders.insert(0, newOrder);
    activeInFlightOrderId = orderId;

    // Credit 5% Cashback
    final cashback = (traySubtotal * 0.05).round();
    walletBalance += cashback;
    loyaltyLog.insert(
      0,
      LoyaltyLog(date: 'Just now', description: '5% Direct Cashback · Order #$orderId', amount: cashback),
    );

    // Increment stamp
    if (stampCount < 5) {
      stampCount++;
    }

    // Clear Tray
    tray.clear();
    promoApplied = false;
    promoDiscountPct = 0;

    notifyListeners();
    return orderId;
  }

  // --- Order State Machine ---
  void advanceOrderStatus(String orderId, OrderStatus nextStatus) {
    final o = orders.firstWhere((x) => x.id == orderId);
    o.status = nextStatus;

    if (nextStatus == OrderStatus.delivered && o.paymentMethod == 'COD') {
      riderCodBagAmount += o.total;
      riderTodayDeliveriesCount++;
    }

    notifyListeners();
  }

  void rejectOrder(String orderId, String reason) {
    final o = orders.firstWhere((x) => x.id == orderId);
    o.status = OrderStatus.rejected;
    o.rejectionReason = reason;
    notifyListeners();
  }

  void cancelOrder(String orderId, String reason) {
    final o = orders.firstWhere((x) => x.id == orderId);
    o.status = OrderStatus.failed;
    o.cancelReason = reason;
    notifyListeners();
  }

  void setRiderPickupState(String orderId, String state) {
    final o = orders.firstWhere((x) => x.id == orderId);
    o.riderPickupState = state;
    if (state == 'picked_up') {
      o.status = OrderStatus.dispatched;
    }
    notifyListeners();
  }

  void submitOrderRating(String orderId, int stars) {
    final o = orders.firstWhere((x) => x.id == orderId);
    o.rating = stars;
    walletBalance += 50; // Bonus
    loyaltyLog.insert(
      0,
      LoyaltyLog(date: 'Just now', description: '★ Review reward bonus', amount: 50),
    );
    notifyListeners();
  }

  void toggleItemStock(String itemId) {
    final it = catalog.firstWhere((i) => i.id == itemId);
    it.isSoldOut = !it.isSoldOut;
    notifyListeners();
  }
}
