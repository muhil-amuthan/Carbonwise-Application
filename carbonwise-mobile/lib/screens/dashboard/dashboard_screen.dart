import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../providers/carbon_provider.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarbonProvider>().fetchLiveIntensity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarbonWise'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<CarbonProvider>().fetchLiveIntensity();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return Text(
                    'Hello, ${auth.user?.name ?? 'User'} 👋',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                'Monitor your carbon footprint in real-time',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Live Carbon Intensity Card
              Consumer<CarbonProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return _buildShimmerCard();
                  }
                  final intensity = provider.liveIntensity;
                  return _buildCarbonIntensityCard(intensity);
                },
              ),
              const SizedBox(height: 16),

              // Grid Mix Card
              Consumer<CarbonProvider>(
                builder: (context, provider, _) {
                  final intensity = provider.liveIntensity;
                  return _buildGridMixCard(intensity);
                },
              ),
              const SizedBox(height: 16),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildQuickActionCard(
                    Icons.ev_station,
                    'Best Charging',
                    AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickActionCard(
                    Icons.schedule,
                    'Schedule',
                    AppTheme.primaryCyan,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickActionCard(
                    Icons.tips_and_updates,
                    'Carbon Tips',
                    AppTheme.primaryYellow,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Carbon Saving Tips
              _buildTipsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarbonIntensityCard(dynamic intensity) {
    final value = intensity?.intensity ?? 0.0;
    final status = Helpers.getCarbonStatus(value);
    final color = Color(Helpers.getCarbonColor(value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Live Carbon Intensity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: (value / 600).clamp(0.0, 1.0),
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      value.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    const Text(
                      'gCO₂/kWh',
                      style: TextStyle(fontSize: 12, color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridMixCard(dynamic intensity) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grid Power Generation Mix',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildMixBar('Solar & Wind', intensity?.solarWindPercent ?? 0, AppTheme.primaryGreen),
            const SizedBox(height: 8),
            _buildMixBar('Hydroelectric', intensity?.hydroPercent ?? 0, AppTheme.primaryCyan),
            const SizedBox(height: 8),
            _buildMixBar('Natural Gas', intensity?.gasPercent ?? 0, AppTheme.primaryYellow),
            const SizedBox(height: 8),
            _buildMixBar('Coal Power', intensity?.coalPercent ?? 0, AppTheme.primaryRed),
          ],
        ),
      ),
    );
  }

  Widget _buildMixBar(String label, double percent, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${percent.toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(IconData icon, String label, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: AppTheme.primaryYellow),
                const SizedBox(width: 8),
                const Text(
                  'Carbon Saving Tips',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('Charge your EV during peak solar hours (10AM–2PM)'),
            _buildTipItem('Run washing machines during low-carbon windows'),
            _buildTipItem('Pre-heat water during renewable energy peaks'),
            _buildTipItem('Schedule AC pre-cooling before grid peak hours'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 16,
              color: Colors.white.withOpacity(0.1),
            ),
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
