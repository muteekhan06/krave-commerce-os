# KRAVE Commerce OS — Flutter 4-App Mobile Suite

Enterprise-grade Flutter codebase powering 4 independent restaurant-owned applications from a single unified repository.

## 📱 The 4 Applications Included

| Target | Description | Standalone Entrypoint |
|---|---|---|
| 📱 **Customer App** | Branded diner storefront with animated burger hero carousel, modifier customizer, DinePass cashback wallet, SBP Raast QR, and live animated delivery tracking. | `lib/apps/customer/main_customer.dart` |
| 📟 **Kitchen Display (KDS)** | High-contrast kitchen prep tablet with station routing (Grill/Fryer/Expedite), color-coded aging timers (<5m, 5-10m, >10m alarm), 1-tap bump workflow, and ESC/POS 80mm thermal receipt stream. | `lib/apps/kds/main_kds.dart` |
| 🛵 **Rider Fleet App** | Field courier mobile app with Online/Offline duty switch, Google Maps navigation, 3-stage handover protocol (Arrived ➔ Bagged ➔ Delivered), and physical COD cash ledger. | `lib/apps/rider/main_rider.dart` |
| 📊 **Merchant Owner OS** | Executive control panel with PKR 170,000 commission disintermediation metric, 12h peak sales velocity chart, live order queue, emergency 86/sold-out menu toggle, and surge mode. | `lib/apps/owner/main_owner.dart` |

---

## 🚀 How to Run

### Universal Multi-App Launcher Hub
Launch the master app which allows previewing and switching between all 4 applications:
```bash
cd flutter_app
flutter pub get
flutter run lib/main.dart
```

### Launch Standalone Apps (Direct Boot with Animated Brand Splash)
```bash
# 1. Customer Storefront App
flutter run lib/apps/customer/main_customer.dart

# 2. Kitchen Display System (Tablet or Phone)
flutter run lib/apps/kds/main_kds.dart

# 3. Rider Delivery Fleet App
flutter run lib/apps/rider/main_rider.dart

# 4. Merchant Owner OS
flutter run lib/apps/owner/main_owner.dart
```

---

## 📦 Building Standalone APKs for Android

```bash
# Build Customer Storefront APK
flutter build apk -t lib/apps/customer/main_customer.dart --release

# Build Kitchen KDS Tablet APK
flutter build apk -t lib/apps/kds/main_kds.dart --release

# Build Rider Courier APK
flutter build apk -t lib/apps/rider/main_rider.dart --release

# Build Merchant OS APK
flutter build apk -t lib/apps/owner/main_owner.dart --release
```

---

## 🎨 In-App Brand Animation Sequence
Every application boots with `AnimatedRestaurantSplash`:
1. Radial ambient crimson glow expands from center.
2. The KRAVE `KR` emblem animates with elastic scale & bounce.
3. Brand lettering fades in with dynamic letter-spacing expansion.
4. Role badge (`DIRECT CUSTOMER PWA`, `KITCHEN KDS STATION`, etc.) illuminates with green live dot.
5. Smooth fade transition enters into the selected application.
