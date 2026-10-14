# 🍔 KRAVE Commerce OS
### The Production Restaurant-Owned Food Delivery Platform & 4-App Mobile Suite
> **Bypass 30% third-party aggregator commissions.** Own your customer data, digital menu, kitchen operations, rider fleet, and direct repeat business.

[![Build & Release APKs](https://github.com/muteekhan06/krave-commerce-os/actions/workflows/build-apks.yml/badge.svg)](https://github.com/muteekhan06/krave-commerce-os/actions/workflows/build-apks.yml)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.24-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)]()
[![State Bank of Pakistan](https://img.shields.io/badge/Raast_P2M-Instant_0%25_Fee-008000.svg)]()

---

## 📌 Executive Summary

Third-party food aggregator platforms (such as Foodpanda) extract **25% to 30% commission** on every order, hide customer phone numbers and ordering habits, and dilute brand identity. 

**KRAVE Commerce OS** is a turnkey, multi-tenant digital ordering system built specifically for restaurant operators. It provides:
1. **Direct Customer Storefront App (Mobile & PWA)** with 15% lower menu prices, 5% cashback, and instant SBP Raast QR.
2. **Kitchen Display System (KDS)** replacing paper chaos with station routing, ticket aging sirens, and ESC/POS thermal printing.
3. **Rider Courier Fleet App** with 3-stage handover verification and a physical COD cash ledger.
4. **Merchant Owner OS Control Panel** tracking live direct sales, peak-hour order velocity, and emergency 86/sold-out switches.

---

## 📱 The 4 Specialized Mobile Applications

```
krave-commerce-os/
│
├── 📱 App 1: Customer Storefront (iOS & Android)
│   ├── Animated Brand Splash Screen (Logo elastic scale + expanding letter-spacing)
│   ├── Artisanal Smash Burgers catalog & horizontal scroll-snap featured hero carousel
│   ├── Item Customizer (Patty weight, Brioche bun, signature sauces, add-ons, combo toggle)
│   ├── Fitts's Law floating tray drawer & SBP Raast P2M QR + COD checkout
│   ├── Animated Live Tracking (dark SVG route polyline with real-time ETA countdown)
│   └── DinePass Loyalty Wallet (5% automatic cashback) & 5-Stamp Burger Card
│
├── 📟 App 2: Kitchen Display System (Tablet & Mobile)
│   ├── High-contrast dark mode UI (AppColors.surface950)
│   ├── Station filter tabs (All Stations, Grill Flat-Top, Deep Fryer, Expediter)
│   ├── Dynamic ticket aging timers:
│   │   ├── 🟢 Green (<5m prep time)
│   │   ├── 🟡 Warning Amber (5-10m)
│   │   └── 🔴 Critical Pulsing Siren (>10m high decibel kitchen alarm)
│   ├── 1-Tap workflow: Accept ➔ Ready for Bagging ➔ Hand to Rider
│   └── Hardware ESC/POS 80mm thermal receipt generator
│
├── 🛵 App 3: Rider Courier Fleet App (Field Mobile)
│   ├── Online / Offline duty status switcher
│   ├── Physical COD Cash-in-Bag Ledger (reconciling cash handover)
│   ├── Turn-by-turn navigation link to Google Maps
│   ├── 3-Stage Handover Protocol:
│   │   ├── Step 1: "I've Arrived at Kitchen"
│   │   ├── Step 2: "Confirm Pickup & Bagging ➔"
│   │   └── Step 3: "Handover & Mark Delivered ✓"
│   └── Undelivered / incident reporting modal
│
└── 📊 App 4: Merchant Owner OS (Executive Dashboard)
    ├── Commission Disintermediation Metric (e.g. PKR 170,000 saved vs aggregators)
    ├── Real-time KPIs: Today's Sales (PKR 64,800), Active Orders, Avg Order Value
    ├── 12-Hour Order Velocity Bar Chart (visualizing 1:00 PM lunch & 8:00 PM dinner rush)
    ├── Emergency 86 / Sold-Out Menu Switcher (instant live stock sync to customer app)
    └── Surge Busy Mode (extends customer ETA during peak volume)
```

---

## 🎬 Brand Splash Animation Sequence

All 4 mobile apps boot with an orchestrated in-app sequence implemented in `AnimatedRestaurantSplash`:
1. **Radial Ambient Crimson Glow**: Background aura gently pulses.
2. **Emblem Reveal**: The KRAVE `KR` emblem animates with elastic scale (`Curves.easeOutBack`) from `0.8x` to `1.05x`.
3. **Brand Name Reveal**: `KRAVE` typography expands smoothly with dynamic letter-spacing (`1.0` ➔ `6.0`).
4. **Gold Subtitle**: `ARTISANAL SMASH BURGERS` illuminates with role badge (*"Direct Customer PWA"*, *"Kitchen KDS Station"*, etc.).
5. **Cross-Fade Transition**: Enters directly into the selected application target.

---

## 🏗️ Technical Architecture & Monorepo Structure

```
.
├── .github/
│   └── workflows/
│       └── build-apks.yml           # GitHub Actions CI/CD to build & release all 4 APKs in the cloud
├── flutter_app/                     # Complete Flutter & Dart Codebase
│   ├── pubspec.yaml                 # Flutter project configuration
│   ├── README.md                    # Flutter setup & local run guide
│   └── lib/
│       ├── main.dart                # Master Multi-App Hub & Flavor Switcher
│       ├── core/
│       │   ├── theme/app_theme.dart # Dark/Light Tailwind-matching design tokens
│       │   ├── models/models.dart   # MenuItem, CartItem, PlatformOrder, Branch, LoyaltyLog
│       │   ├── state/app_state.dart # Reactive ChangeNotifier central store & order state machine
│       │   └── widgets/             # Animated Splash Screen & Toast system
│       └── apps/
│           ├── customer/            # Customer App & standalone entry (main_customer.dart)
│           ├── kds/                 # KDS Tablet & standalone entry (main_kds.dart)
│           ├── rider/               # Rider Fleet & standalone entry (main_rider.dart)
│           └── owner/               # Merchant OS & standalone entry (main_owner.dart)
├── index.html                       # High-Fidelity Standalone Web PWA Prototype (4,541 lines)
├── FLUTTER_4_APP_ARCHITECTURE.md    # In-depth architectural blueprint
└── KRAVE_Full_Audit.md              # 46-point UX/HCI audit report
```

---

## ☁️ Automated Cloud APK Builds (GitHub Actions CI/CD)

You don't need gigabytes of Android SDK or Gradle caches on your local machine. Every time code is pushed, **GitHub Actions automatically compiles all 4 Android APKs in the cloud**:

| Generated APK Artifact | Description |
|---|---|
| 📱 **`krave-customer-app-release.apk`** | Downloadable Android app for customer direct ordering. |
| 📟 **`krave-kitchen-kds-release.apk`** | Android tablet app for kitchen line cooks and expediter station. |
| 🛵 **`krave-rider-fleet-release.apk`** | Android mobile app for delivery motorbike couriers. |
| 📊 **`krave-merchant-os-release.apk`** | Management Android app for restaurant owners and general managers. |

### How to Download the APKs from GitHub:
1. Open this repository on GitHub.
2. Click on the **Actions** tab.
3. Select the latest run under **Build & Release KRAVE Mobile APKs**.
4. Scroll to **Artifacts** at the bottom and download **`krave-commerce-os-apks`** (ZIP containing all 4 ready-to-install APK files).
5. Alternatively, create a Git Tag (e.g. `v1.0.0`) to trigger an official **GitHub Release** with direct download links.

---

## 💻 Local Development

### Prerequisites
* [Flutter SDK (3.24+)](https://flutter.dev/docs/get-started/install)
* Dart SDK (3.0+)

### Running the Apps Locally:
```bash
# 1. Clone repository
git clone https://github.com/muteekhan06/krave-commerce-os.git
cd krave-commerce-os/flutter_app

# 2. Install dependencies
flutter pub get

# 3. Launch Universal Multi-App Selector Hub:
flutter run lib/main.dart

# 4. Or launch any app directly in isolation:
flutter run lib/apps/customer/main_customer.dart # Customer App
flutter run lib/apps/kds/main_kds.dart           # Kitchen KDS
flutter run lib/apps/rider/main_rider.dart       # Rider Fleet
flutter run lib/apps/owner/main_owner.dart       # Merchant OS
```

---

## 🏷️ Versioning Strategy

This project adheres to [Semantic Versioning (SemVer)](https://semver.org/):
* **`MAJOR.MINOR.PATCH`** (e.g., `v1.0.0`)
  * `MAJOR`: Breaking changes or architectural updates.
  * `MINOR`: New features (e.g., adding POS integration or SMS OTP).
  * `PATCH`: Bug fixes, layout adjustments, and performance polish.

To trigger an automated APK release build:
```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## 📄 License & Intellectual Property

Proprietary Software © 2026 KRAVE Burgers / Infynix Technologies. All rights reserved.
Direct ordering engine designed and engineered for restaurant sovereignty.
