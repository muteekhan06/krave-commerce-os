class ModifierOption {
  final String id;
  final String label;
  final int price;

  const ModifierOption({required this.id, required this.label, required this.price});
}

class MenuItem {
  final String id;
  final String category;
  final String station;
  final bool featured;
  final String title;
  final String titleUrdu;
  final String description;
  final int price;
  final String imageUrl;
  bool isSoldOut;
  final String? badge;
  final List<String> dietary;
  final bool isSpicy;
  final List<String> availableSauces;
  final List<ModifierOption> addons;

  MenuItem({
    required this.id,
    required this.category,
    required this.station,
    required this.featured,
    required this.title,
    required this.titleUrdu,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isSoldOut = false,
    this.badge,
    required this.dietary,
    required this.isSpicy,
    required this.availableSauces,
    required this.addons,
  });
}

class CartItem {
  final String id;
  final MenuItem item;
  int quantity;
  final int unitPrice;
  final String selectedPatty;
  final String selectedBun;
  final String selectedSauce;
  final String? selectedSpice;
  final List<String> selectedAddons;
  final bool isCombo;
  final String kitchenNote;

  CartItem({
    required this.id,
    required this.item,
    required this.quantity,
    required this.unitPrice,
    required this.selectedPatty,
    required this.selectedBun,
    required this.selectedSauce,
    this.selectedSpice,
    required this.selectedAddons,
    required this.isCombo,
    this.kitchenNote = '',
  });

  int get totalItemPrice => unitPrice * quantity;
}

enum OrderStatus {
  inbound,
  preparing,
  ready,
  dispatched,
  delivered,
  rejected,
  failed,
}

class OrderItemSummary {
  final String title;
  final int quantity;
  final int price;
  final List<String> modifiers;

  OrderItemSummary({
    required this.title,
    required this.quantity,
    required this.price,
    required this.modifiers,
  });
}

class PlatformOrder {
  final String id;
  final String customerName;
  final String phone;
  final String address;
  final String fulfillmentType; // 'DELIVERY' | 'PICKUP'
  final String paymentMethod;    // 'COD' | 'RAAST'
  OrderStatus status;
  int elapsedSeconds;
  final String station;          // 'grill' | 'fryer' | 'expedite'
  final String timestamp;
  final List<OrderItemSummary> items;
  final int subtotal;
  final int deliveryFee;
  final int discount;
  final int total;
  int? rating;
  String? cancelReason;
  String? rejectionReason;
  String riderPickupState; // 'assigned' | 'arrived' | 'picked_up'

  PlatformOrder({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.fulfillmentType,
    required this.paymentMethod,
    required this.status,
    this.elapsedSeconds = 0,
    required this.station,
    required this.timestamp,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    this.rating,
    this.cancelReason,
    this.rejectionReason,
    this.riderPickupState = 'assigned',
  });
}

class Branch {
  final String id;
  final String name;
  final String area;
  final String etaRange;
  final int deliveryFee;

  const Branch({
    required this.id,
    required this.name,
    required this.area,
    required this.etaRange,
    required this.deliveryFee,
  });
}

class LoyaltyLog {
  final String date;
  final String description;
  final int amount;

  const LoyaltyLog({required this.date, required this.description, required this.amount});
}
