import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/models/models.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';

class RiderAppScreen extends StatelessWidget {
  const RiderAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final activeRuns = state.orders.where((o) {
      return o.status == OrderStatus.ready || o.status == OrderStatus.dispatched;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface950,
      appBar: AppBar(
        backgroundColor: AppColors.surface900,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: AppColors.brand700, borderRadius: BorderRadius.circular(6)),
              child: const Text('RIDER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tariq Khan', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('Suzuki GS150 • 4.9★', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.surface400)),
              ],
            ),
          ],
        ),
        actions: [
          Switch(
            value: state.isRiderOnline,
            activeColor: AppColors.emerald400,
            onChanged: (_) => state.toggleRiderOnline(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Shift Telemetry Card
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface900,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SHIFT STATUS', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.surface400)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: state.isRiderOnline ? AppColors.emerald400 : AppColors.surface500,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          state.isRiderOnline ? 'ONLINE (ACTIVE)' : 'OFFLINE',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: state.isRiderOnline ? AppColors.emerald400 : AppColors.surface500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('COD CASH IN BAG', style: GoogleFonts.jetBrainsMono(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.surface400)),
                    const SizedBox(height: 4),
                    Text(
                      'PKR ${state.riderCodBagAmount.toString()}',
                      style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.amber400),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Active Assignments Stream
          Expanded(
            child: !state.isRiderOnline
                ? Center(
                    child: Text('You are OFFLINE.\nToggle online to receive delivery dispatches.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(color: AppColors.surface500)),
                  )
                : (activeRuns.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.two_wheeler, color: AppColors.surface600, size: 54),
                            const SizedBox(height: 12),
                            Text('No active delivery runs', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('Stand by at DHA Phase 5 kitchen for incoming orders.', style: GoogleFonts.plusJakartaSans(color: AppColors.surface500, fontSize: 11)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: activeRuns.length,
                        itemBuilder: (context, i) {
                          final run = activeRuns[i];
                          return _buildRiderRunCard(context, state, run);
                        },
                      )),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderRunCard(BuildContext context, AppState state, PlatformOrder order) {
    return Card(
      color: AppColors.surface900,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Text('#${order.id}', style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.brand400)),
                Text(
                  'PKR ${order.total} (${order.paymentMethod})',
                  style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.amber400),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${order.customerName} • ${order.phone}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Address Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.surface950, borderRadius: BorderRadius.circular(10)),
              child: Text('📍 ${order.address}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface300)),
            ),
            const SizedBox(height: 12),

            // Navigation and Actions
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening Google Maps route to ${order.address}...')),
                    );
                  },
                  icon: const Icon(Icons.navigation, size: 14),
                  label: const Text('Route Map', style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRiderStepButton(context, state, order),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderStepButton(BuildContext context, AppState state, PlatformOrder order) {
    if (order.riderPickupState == 'assigned') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.brand700),
        onPressed: () => state.setRiderPickupState(order.id, 'arrived'),
        child: const Text('Step 1: Arrived at Kitchen', style: TextStyle(fontSize: 11)),
      );
    } else if (order.riderPickupState == 'arrived') {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber500, foregroundColor: Colors.black),
        onPressed: () => state.setRiderPickupState(order.id, 'picked_up'),
        child: const Text('Step 2: Bag & Dispatch ➔', style: TextStyle(fontSize: 11)),
      );
    } else {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald600),
        onPressed: () => state.advanceOrderStatus(order.id, OrderStatus.delivered),
        child: const Text('Step 3: Mark Delivered ✓', style: TextStyle(fontSize: 11)),
      );
    }
  }
}
