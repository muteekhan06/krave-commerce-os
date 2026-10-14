import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/models/models.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';

class KdsAppScreen extends StatelessWidget {
  const KdsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    final filteredOrders = state.orders.where((o) {
      if (o.status == OrderStatus.delivered || o.status == OrderStatus.rejected || o.status == OrderStatus.failed) {
        return false;
      }
      if (state.kdsStationFilter == 'all') return true;
      return o.station == state.kdsStationFilter;
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
              child: const Text('KDS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kitchen Display System', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('${state.currentBranch.name} • Active Prep Queue', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.surface400)),
              ],
            ),
          ],
        ),
        actions: [
          // Surge Busy Mode Toggle
          IconButton(
            tooltip: 'Surge Mode (Busy)',
            icon: Icon(
              state.isKitchenBusy ? Icons.warning_amber : Icons.speed,
              color: state.isKitchenBusy ? AppColors.amber400 : AppColors.surface400,
            ),
            onPressed: () => state.toggleKitchenBusy(),
          ),
          // Siren Sound Test
          IconButton(
            tooltip: 'Test Siren Alarm',
            icon: const Icon(Icons.volume_up, color: AppColors.surface300),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🔊 High-decibel kitchen alarm chime triggered!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Busy warning banner (if active)
          if (state.isKitchenBusy)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              color: AppColors.amber500,
              child: Center(
                child: Text(
                  '⚠️ KITCHEN SURGE BUSY MODE ACTIVE: Customer ETA extended by 25 mins',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 10, color: Colors.black),
                ),
              ),
            ),

          // Station Filter Pills
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.surface900,
            child: Row(
              children: [
                _buildStationChip(context, state, 'all', 'All Stations'),
                const SizedBox(width: 8),
                _buildStationChip(context, state, 'grill', 'Grill Flat-Top'),
                const SizedBox(width: 8),
                _buildStationChip(context, state, 'fryer', 'Deep Fryer'),
                const SizedBox(width: 8),
                _buildStationChip(context, state, 'expedite', 'Expediter'),
              ],
            ),
          ),

          // Ticket Stream
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.celebration, color: AppColors.emerald400, size: 48),
                        const SizedBox(height: 12),
                        Text('Kitchen Queue Clear!', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('All orders cooked, bagged and dispatched.', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.surface500)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, i) {
                      final order = filteredOrders[i];
                      return _buildKdsTicketCard(context, state, order);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationChip(BuildContext context, AppState state, String id, String label) {
    final isSelected = state.kdsStationFilter == id;
    return InkWell(
      onTap: () => state.setKdsStationFilter(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand700 : AppColors.surface800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.surface300,
          ),
        ),
      ),
    );
  }

  Widget _buildKdsTicketCard(BuildContext context, AppState state, PlatformOrder order) {
    // Ticket aging calculation
    final mins = order.elapsedSeconds ~/ 60;
    final secs = order.elapsedSeconds % 60;
    final formattedTime = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    Color timerColor = AppColors.surface400;
    Color timerBg = AppColors.surface800;
    if (order.elapsedSeconds > 600) {
      timerColor = AppColors.brand500;
      timerBg = AppColors.brand950;
    } else if (order.elapsedSeconds > 300) {
      timerColor = AppColors.amber400;
      timerBg = const Color(0xFF451A03);
    }

    return Card(
      color: AppColors.surface900,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: order.status == OrderStatus.inbound ? AppColors.brand600 : AppColors.surface800,
          width: order.status == OrderStatus.inbound ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top ticket bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('#${order.id}', style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.brand400)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: order.paymentMethod == 'COD' ? AppColors.amber500.withOpacity(0.2) : AppColors.emerald500.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.paymentMethod,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: order.paymentMethod == 'COD' ? AppColors.amber400 : AppColors.emerald400,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: timerBg, borderRadius: BorderRadius.circular(6)),
                  child: Text('⏱ $formattedTime', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.bold, color: timerColor)),
                ),
              ],
            ),
            const Divider(color: AppColors.surface800, height: 20),

            // Item rows
            ...order.items.map((it) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${it.quantity}x ${it.title}', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                        Text('PKR ${it.price * it.quantity}', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.surface400)),
                      ],
                    ),
                    if (it.modifiers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 14, top: 2),
                        child: Text(
                          '↳ ${it.modifiers.join(', ')}',
                          style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.amber400),
                        ),
                      ),
                  ],
                ),
              );
            }),

            const Divider(color: AppColors.surface800, height: 20),

            // Customer info & actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.customerName, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    Text(order.fulfillmentType, style: const TextStyle(color: AppColors.surface400, fontSize: 10)),
                  ],
                ),
                Row(
                  children: [
                    // Reject button (if inbound)
                    if (order.status == OrderStatus.inbound)
                      IconButton(
                        tooltip: 'Reject Order',
                        icon: const Icon(Icons.close, color: AppColors.brand500),
                        onPressed: () => _showRejectModal(context, state, order.id),
                      ),

                    // Thermal Receipt Preview
                    IconButton(
                      tooltip: 'Print Thermal KOT',
                      icon: const Icon(Icons.print, color: AppColors.surface300),
                      onPressed: () => _showThermalPreview(context, order),
                    ),

                    const SizedBox(width: 6),

                    // Main 1-Tap Advance Action
                    _buildAdvanceButton(context, state, order),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvanceButton(BuildContext context, AppState state, PlatformOrder order) {
    if (order.status == OrderStatus.inbound) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.brand700),
        onPressed: () => state.advanceOrderStatus(order.id, OrderStatus.preparing),
        child: const Text('Accept ➔ Grill'),
      );
    } else if (order.status == OrderStatus.preparing) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber500, foregroundColor: Colors.black),
        onPressed: () => state.advanceOrderStatus(order.id, OrderStatus.ready),
        child: const Text('Mark Ready'),
      );
    } else if (order.status == OrderStatus.ready) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald600),
        onPressed: () => state.advanceOrderStatus(order.id, OrderStatus.dispatched),
        child: const Text('Hand to Rider'),
      );
    }
    return const SizedBox.shrink();
  }

  void _showRejectModal(BuildContext context, AppState state, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface900,
        title: const Text('Decline Order', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Out of Smash Patties', style: TextStyle(color: Colors.white)),
              onTap: () {
                state.rejectOrder(orderId, 'Out of Stock');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Kitchen Surge Overload', style: TextStyle(color: Colors.white)),
              onTap: () {
                state.rejectOrder(orderId, 'Kitchen Overload');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThermalPreview(BuildContext context, PlatformOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('*** KITCHEN ORDER TICKET ***', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Ticket #${order.id}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ...order.items.map((it) => Text('${it.quantity}x ${it.title}')),
            const Divider(),
            Text('Total: PKR ${order.total} (${order.paymentMethod})'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Dismiss')),
        ],
      ),
    );
  }
}
