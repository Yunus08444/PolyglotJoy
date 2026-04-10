import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeMode = prefs.getString('themeMode') ?? 'Системная';

  runApp(PolyglotJoyApp(initialThemeMode: themeMode));
}

class PolyglotJoyApp extends StatefulWidget {
  final String initialThemeMode;

  const PolyglotJoyApp({super.key, required this.initialThemeMode});

  @override
  State<PolyglotJoyApp> createState() => _PolyglotJoyAppState();
}

class _PolyglotJoyAppState extends State<PolyglotJoyApp> {
  late String _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void updateTheme(String newTheme) {
    setState(() {
      _themeMode = newTheme;
    });
  }

  ThemeMode _getThemeMode() {
    switch (_themeMode) {
      case 'Светлая':
        return ThemeMode.light;
      case 'Темная':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PolyglotJoy',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _getThemeMode(),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/settings': (context) => SettingsPage(onThemeChanged: updateTheme),
        '/lesson': (context) => const LessonDetailPage(),
      },
    );
  }

  ThemeData get _lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF6366F1),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6366F1),
        secondary: Color(0xFF8B5CF6),
        tertiary: Color(0xFFEC4899),
        surface: Colors.white,
        background: Color(0xFFF5F7FB),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1A1A2E),
        titleTextStyle: TextStyle(
          color: Color(0xFF1A1A2E),
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF818CF8),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF818CF8),
        secondary: Color(0xFFA78BFA),
        tertiary: Color(0xFFF472B6),
        surface: Color(0xFF1E1E2E),
        background: Color(0xFF0F0F1A),
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Color(0xFF1E1E2E),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

// ==================== ДОМАШНЯЯ СТРАНИЦА ====================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Theme.of(context).primaryColor, const Color(0xFF8B5CF6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.translate,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'PolyglotJoy',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Ваш личный помощник в изучении языков',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Начните свое путешествие',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '8 интерактивных уроков ждут вас',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/settings'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Начать обучение',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                      child: const Text(
                        'Настройки',
                        style: TextStyle(color: Color(0xFF6366F1)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== СТРАНИЦА НАСТРОЕК ====================
class SettingsPage extends StatefulWidget {
  final Function(String) onThemeChanged;

  const SettingsPage({super.key, required this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsOn = true;
  bool _soundEffects = true;
  bool _dailyReminder = false;
  String _selectedLanguage = 'Русский';
  String _selectedLevel = 'Начинающий (A1)';
  String _themeMode = 'Системная';
  int _dailyGoal = 15;
  bool _autoPlayAudio = true;
  bool _showTranslation = true;
  String _fontSize = 'Средний';

  final List<String> _languages = ['Русский', 'English', 'العربية'];
  final List<String> _levels = [
    'Начинающий (A1)',
    'Элементарный (A2)',
    'Средний (B1)',
    'Выше среднего (B2)',
    'Продвинутый (C1)',
    'Профессиональный (C2)',
  ];
  final List<String> _themeModes = ['Светлая', 'Темная', 'Системная'];
  final List<String> _fontSizes = ['Маленький', 'Средний', 'Большой'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsOn = prefs.getBool('notificationsOn') ?? true;
      _soundEffects = prefs.getBool('soundEffects') ?? true;
      _dailyReminder = prefs.getBool('dailyReminder') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'Русский';
      _selectedLevel = prefs.getString('level') ?? 'Начинающий (A1)';
      _themeMode = prefs.getString('themeMode') ?? 'Системная';
      _dailyGoal = prefs.getInt('dailyGoal') ?? 15;
      _autoPlayAudio = prefs.getBool('autoPlayAudio') ?? true;
      _showTranslation = prefs.getBool('showTranslation') ?? true;
      _fontSize = prefs.getString('fontSize') ?? 'Средний';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsOn', _notificationsOn);
    await prefs.setBool('soundEffects', _soundEffects);
    await prefs.setBool('dailyReminder', _dailyReminder);
    await prefs.setString('language', _selectedLanguage);
    await prefs.setString('level', _selectedLevel);
    await prefs.setString('themeMode', _themeMode);
    await prefs.setInt('dailyGoal', _dailyGoal);
    await prefs.setBool('autoPlayAudio', _autoPlayAudio);
    await prefs.setBool('showTranslation', _showTranslation);
    await prefs.setString('fontSize', _fontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildSectionHeader('Уведомления и звук'),
          _buildSwitchTile(
            value: _notificationsOn,
            title: 'Push-уведомления',
            subtitle: 'Получать напоминания о занятиях',
            icon: Icons.notifications_none,
            onChanged: (value) {
              setState(() => _notificationsOn = value);
              _saveSettings();
            },
          ),
          _buildSwitchTile(
            value: _dailyReminder,
            title: 'Ежедневное напоминание',
            subtitle: 'Напоминать в 20:00',
            icon: Icons.alarm,
            onChanged: (value) {
              setState(() => _dailyReminder = value);
              _saveSettings();
            },
          ),
          _buildSwitchTile(
            value: _soundEffects,
            title: 'Звуковые эффекты',
            subtitle: 'Звуки при правильных ответах',
            icon: Icons.volume_up,
            onChanged: (value) {
              setState(() => _soundEffects = value);
              _saveSettings();
            },
          ),
          const SizedBox(height: 8),
          _buildSectionHeader('Обучение'),
          _buildListTile(
            title: 'Язык интерфейса',
            subtitle: _selectedLanguage,
            icon: Icons.language,
            onTap: () => _showLanguageDialog(),
          ),
          _buildListTile(
            title: 'Уровень владения',
            subtitle: _selectedLevel,
            icon: Icons.school,
            onTap: () => _showLevelDialog(),
          ),
          _buildListTile(
            title: 'Ежедневная цель',
            subtitle: '$_dailyGoal минут в день',
            icon: Icons.timer,
            onTap: () => _showDailyGoalDialog(),
          ),
          _buildSwitchTile(
            value: _showTranslation,
            title: 'Показывать перевод',
            subtitle: 'Отображать перевод под словами',
            icon: Icons.translate,
            onChanged: (value) {
              setState(() => _showTranslation = value);
              _saveSettings();
            },
          ),
          const SizedBox(height: 8),
          _buildSectionHeader('Внешний вид'),
          _buildListTile(
            title: 'Тема приложения',
            subtitle: _themeMode,
            icon: Icons.palette,
            onTap: () => _showThemeDialog(),
          ),
          _buildListTile(
            title: 'Размер шрифта',
            subtitle: _fontSize,
            icon: Icons.text_fields,
            onTap: () => _showFontSizeDialog(),
          ),
          const SizedBox(height: 8),
          _buildSectionHeader('О приложении'),
          _buildListTile(
            title: 'О приложении',
            subtitle: 'PolyglotJoy v1.0.0',
            icon: Icons.info_outline,
            onTap: () => _showAboutDialog(),
          ),
          _buildListTile(
            title: 'Сбросить настройки',
            subtitle: 'Вернуть все настройки по умолчанию',
            icon: Icons.restore,
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () => _resetSettings(),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'PolyglotJoy © 2026',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[600]
                    : Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(
              0.1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 22,
            color: iconColor ?? Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: textColor?.withOpacity(0.7) ?? Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: textColor ?? Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required bool value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 22, color: Theme.of(context).primaryColor),
        ),
        activeColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onChanged: onChanged,
      ),
    );
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Выберите язык интерфейса',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ..._languages.map(
            (lang) => ListTile(
              title: Text(lang),
              trailing: _selectedLanguage == lang
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = lang);
                _saveSettings();
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showLevelDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Уровень владения языком',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ..._levels.map(
            (level) => ListTile(
              title: Text(level),
              trailing: _selectedLevel == level
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () {
                setState(() => _selectedLevel = level);
                _saveSettings();
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showThemeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Выберите тему',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ..._themeModes.map(
            (mode) => ListTile(
              title: Text(mode),
              trailing: _themeMode == mode
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () {
                setState(() => _themeMode = mode);
                _saveSettings();
                widget.onThemeChanged(_themeMode);
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDailyGoalDialog() {
    int tempDailyGoal = _dailyGoal; // Временная переменная для диалога

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ежедневная цель',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Сколько минут вы хотите учить каждый день?',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'minus',
                      onPressed: () {
                        if (tempDailyGoal > 5) {
                          setStateDialog(() {
                            tempDailyGoal -= 5;
                          });
                        }
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 24),
                    Container(
                      width: 80,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            '$tempDailyGoal',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'минут',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    FloatingActionButton.small(
                      heroTag: 'plus',
                      onPressed: () {
                        if (tempDailyGoal < 120) {
                          setStateDialog(() {
                            tempDailyGoal += 5;
                          });
                        }
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Отмена'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _dailyGoal = tempDailyGoal;
                          });
                          _saveSettings();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Сохранить'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Размер шрифта',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ..._fontSizes.map(
            (size) => ListTile(
              title: Text(size),
              trailing: _fontSize == size
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () {
                setState(() => _fontSize = size);
                _saveSettings();
                Navigator.pop(context);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.translate, color: Color(0xFF6366F1)),
            SizedBox(width: 12),
            Text('PolyglotJoy'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Версия: v1.0.0'),
            SizedBox(height: 12),
            Text('Ваш личный помощник в изучении иностранных языков.'),
            SizedBox(height: 16),
            Text(
              '✨ Особенности:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('• 8 интерактивных уроков'),
            Text('• Тренировка произношения'),
            Text('• Персональные рекомендации'),
            Text('• Ежедневные напоминания'),
            SizedBox(height: 16),
            Text('Разработано с любовью для изучающих языки ♥️'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Сброс настроек'),
        content: const Text(
          'Вы уверены, что хотите сбросить все настройки к значениям по умолчанию?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                _notificationsOn = true;
                _soundEffects = true;
                _dailyReminder = false;
                _selectedLanguage = 'Русский';
                _selectedLevel = 'Начинающий (A1)';
                _themeMode = 'Системная';
                _dailyGoal = 15;
                _autoPlayAudio = true;
                _showTranslation = true;
                _fontSize = 'Средний';
              });
              await _saveSettings();
              widget.onThemeChanged(_themeMode);
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Сбросить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class LessonDetailPage extends StatelessWidget {
  const LessonDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lesson =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Урок не найден')),
        body: const Center(child: Text('Информация об уроке отсутствует')),
      );
    }

    final content = _getLessonContent(lesson['title']!);
    final gradientColors = _getGradientColors(lesson['title']!);
    final icon = _getLessonIcon(lesson['title']!);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF1A1A2E),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                lesson['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: -0.5,
                  shadows: [
                    Shadow(
                      blurRadius: 12,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -80,
                    right: -80,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -100,
                    left: -50,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(icon, size: 64, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          lesson['title']!,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                blurRadius: 12,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            lesson['subtitle']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradientColors),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(icon, size: 28, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Материалы урока',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1),
                        const SizedBox(height: 24),
                        Text(
                          content,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.8,
                            color: Color(0xFF2D3436),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 20,
                                color: gradientColors.first,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Отметьте этот урок как пройденный, когда освоите материал',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: gradientColors.first,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(String title) {
    if (title.contains('Основы'))
      return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    if (title.contains('Грамматика'))
      return [const Color(0xFFEC4899), const Color(0xFFF43F5E)];
    if (title.contains('Словарь'))
      return [const Color(0xFF06B6D4), const Color(0xFF3B82F6)];
    if (title.contains('Разговорная'))
      return [const Color(0xFF10B981), const Color(0xFF34D399)];
    if (title.contains('Аудирование'))
      return [const Color(0xFFF59E0B), const Color(0xFFEF4444)];
    if (title.contains('Письмо'))
      return [const Color(0xFF8B5CF6), const Color(0xFFD946EF)];
    if (title.contains('Чтение'))
      return [const Color(0xFF14B8A6), const Color(0xFF2DD4BF)];
    if (title.contains('Культура'))
      return [const Color(0xFFF97316), const Color(0xFFFBBF24)];
    return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
  }

  IconData _getLessonIcon(String title) {
    if (title.contains('Основы')) return Icons.auto_stories_rounded;
    if (title.contains('Грамматика')) return Icons.abc_rounded;
    if (title.contains('Словарь')) return Icons.menu_book_rounded;
    if (title.contains('Разговорная')) return Icons.record_voice_over_rounded;
    if (title.contains('Аудирование')) return Icons.headphones_rounded;
    if (title.contains('Письмо')) return Icons.edit_note_rounded;
    if (title.contains('Чтение')) return Icons.library_books_rounded;
    if (title.contains('Культура')) return Icons.public_rounded;
    return Icons.school_rounded;
  }

  String _getLessonContent(String title) {
    if (title.contains('Основы')) {
      return '''
📚 **УРОК 1: ОСНОВЫ АНГЛИЙСКОГО ЯЗЫКА**

🔤 **Алфавит:** 26 букв (A-Z)
🗣️ **Фонетика:** /θ/ (think), /ð/ (this), /æ/ (cat)
👋 **Приветствия:** Hello, Hi, Good morning, Good evening
🔢 **Числа 1-20:** One, Two, Three... Twenty

💡 **Совет:** Практикуйтесь по 15 минут каждый день!
      ''';
    }
    return '📖 Содержимое урока будет добавлено в следующем обновлении.';
  }
}
