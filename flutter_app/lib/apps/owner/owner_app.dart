import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/models/models.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';

class OwnerAppScreen extends StatelessWidget {
  const OwnerAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

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
              child: const Text('OWNER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KRAVE Merchant OS', style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('${state.currentBranch.name} • Executive Hub', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.surface400)),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disintermediation Commission Savings Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface900,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.emerald500.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.emerald500.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                    child: Text('DIRECT DISINTERMEDIATION', style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.emerald400)),
                  ),
                  const SizedBox(height: 8),
                  Text('PKR 170,000 Saved', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(
                    'Avoided 25% Foodpanda aggregator commissions across 450 direct orders this month.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.surface300),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // KPI Grid
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.surface900, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TODAY SALES', style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppColors.surface400)),
                        const SizedBox(height: 4),
                        Text('PKR 64,800', style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                        Text('↑ 18.4% vs last week', style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.emerald400)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.surface900, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ACTIVE ORDERS', style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppColors.surface400)),
                        const SizedBox(height: 4),
                        Text('${state.orders.length} tickets', style: GoogleFonts.jetBrainsMono(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.emerald400)),
                        Text('Avg Ticket: PKR 1,710', style: GoogleFonts.plusJakartaSans(fontSize: 9, color: AppColors.surface400)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hourly Sales Velocity (Peak Hours)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface900, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hourly Order Velocity', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                      Text('Peak: 1pm & 8pm', style: GoogleFonts.jetBrainsMono(fontSize: 10, color: AppColors.amber400)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChartBar('11a', 20, false),
                      _buildChartBar('12p', 45, false),
                      _buildChartBar('1p★', 85, true),
                      _buildChartBar('2p', 40, false),
                      _buildChartBar('4p', 25, false),
                      _buildChartBar('6p', 50, false),
                      _buildChartBar('8p★', 95, true),
                      _buildChartBar('10p', 35, false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency 86 / Sold-Out Menu Control
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface900, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kitchen 86 / Sold-Out Switcher', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text('Toggle items out of stock in real-time', style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.surface400)),
                  const SizedBox(height: 12),
                  ...state.catalog.map((item) {
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      subtitle: Text('PKR ${item.price}', style: const TextStyle(color: AppColors.surface500, fontSize: 10)),
                      trailing: Switch(
                        value: !item.isSoldOut,
                        activeColor: AppColors.emerald400,
                        onChanged: (_) => state.toggleItemStock(item.id),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(String label, double height, bool isPeak) {
    return Column(
      children: [
        Container(
          width: 22,
          height: height,
          decoration: BoxDecoration(
            color: isPeak ? AppColors.brand700 : AppColors.surface700,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            fontWeight: isPeak ? FontWeight.bold : FontWeight.normal,
            color: isPeak ? AppColors.brand500 : AppColors.surface400,
          ),
        ),
      ],
    );
  }
}
