import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> governorates = [
    'دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية',
    'طرطوس', 'درعا', 'السويداء', 'القنيطرة', 'إدلب',
    'دير الزور', 'الرقة', 'الحسكة'
  ];

  String? selectedGovernorate;

  @override
  void initState() {
    super.initState();
    loadGovernorate();
  }

  Future<void> loadGovernorate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedGovernorate = prefs.getString('selected_governorate');
    });
  }

  Future<void> saveGovernorate(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_governorate', value);
    setState(() {
      selectedGovernorate = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الإعدادات')),
      body: ListView(
        children: [
          ListTile(
            title: Text('اختيار المحافظة'),
            subtitle: Text(selectedGovernorate ?? 'لم يتم التحديد بعد'),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => ListView(
                  children: governorates.map((gov) {
                    return ListTile(
                      title: Text(gov),
                      onTap: () {
                        saveGovernorate(gov);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}