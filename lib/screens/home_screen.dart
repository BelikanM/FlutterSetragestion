import 'package:flutter/material.dart';
import '../head.dart';
import 'logout_screen.dart';
import '../screenHome/details_screen.dart';
import '../screenHome/analytics_screen.dart';
import '../screenHome/reports_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<_HomeCardData> cards = [
      _HomeCardData(
        title: "Détails",
        icon: Icons.info_outline,
        color: Colors.blue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DetailsScreen()),
          );
        },
      ),
      _HomeCardData(
        title: "Analytique",
        icon: Icons.analytics_outlined,
        color: Colors.green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
          );
        },
      ),
      _HomeCardData(
        title: "Rapports",
        icon: Icons.insert_chart_outlined,
        color: Colors.orange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReportsScreen()),
          );
        },
      ),
    ];

    return Scaffold(
      appBar: const Head(title: 'Accueil'),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade700, Colors.green.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Se déconnecter'),
              onTap: () {
                Navigator.pop(context); // fermer Drawer
                showDialog(
                  context: context,
                  builder: (context) => const LogoutScreen(),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return _HomeCard(card: card);
          },
        ),
      ),
    );
  }
}

class _HomeCardData {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _HomeCardData({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _HomeCard extends StatefulWidget {
  final _HomeCardData card;

  const _HomeCard({required this.card});

  @override
  State<_HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<_HomeCard> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.card.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Card(
          color: widget.card.color.withValues(alpha: 0.9),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.card.icon, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                Text(
                  widget.card.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
