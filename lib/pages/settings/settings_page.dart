import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: notificationsOn,
            title: const Text('Уведомления'),
            onChanged: (value) => setState(() => notificationsOn = value),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Тема приложения'),
            subtitle: const Text('Светлая'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('О приложении'),
            subtitle: const Text('PolyglotJoy v1.0'),
          ),
        ],
      ),
    );
  }
}
