import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';
import 'settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(LiratnaApp());
}

class LiratnaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ليرتنا',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> governorates = [
    'دمشق', 'ريف دمشق', 'حلب', 'حمص', 'اللاذقية', 'طرطوس'
  ];

  Map<String, Map<String, int>> exchangeRates = {
    'دمشق': {'buy': 15200, 'sell': 15300},
    'ريف دمشق': {'buy': 15150, 'sell': 15250},
    'حلب': {'buy': 15000, 'sell': 15100},
    'حمص': {'buy': 14900, 'sell': 15000},
    'اللاذقية': {'buy': 14850, 'sell': 14950},
    'طرطوس': {'buy': 14800, 'sell': 14900},
  };

  @override
  void initState() {
    super.initState();
    _loadGovernorateAndNotify();
  }

  Future<void> _loadGovernorateAndNotify() async {
    final prefs = await SharedPreferences.getInstance();
    final selected = prefs.getString('selected_governorate') ?? 'دمشق';
    final rate = exchangeRates[selected];
    if (rate != null) {
      await NotificationService.showNotification(
        'سعر الدولار في $selected',
        'شراء: ${rate['buy']} / مبيع: ${rate['sell']}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ليرتنا'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsPage()),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: governorates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(governorates[index]),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // لاحقًا نضيف صفحة التفاصيل
            },
          );
        },
      ),
    );
  }
}