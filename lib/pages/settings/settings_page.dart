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

  // Светлая тема
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
        background: Color(0xFFF8F9FA),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF6366F1),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  // Темная тема
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
        backgroundColor: Color(0xFF1E1E2E),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A3E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
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
      appBar: AppBar(title: const Text('PolyglotJoy')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.translate, size: 80, color: Color(0xFF6366F1)),
            const SizedBox(height: 20),
            const Text(
              'Добро пожаловать в PolyglotJoy!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Ваш личный помощник в изучении языков',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: const Icon(Icons.settings),
              label: const Text('Настройки'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
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

  final List<String> _languages = ['Русский', 'English', 'Қазақша', 'Türkçe'];
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык интерфейса'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                _saveSettings();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLevelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Уровень владения языком'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _levels.map((level) {
            return RadioListTile<String>(
              title: Text(level),
              value: level,
              groupValue: _selectedLevel,
              onChanged: (value) {
                setState(() => _selectedLevel = value!);
                _saveSettings();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите тему'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _themeModes.map((mode) {
            return RadioListTile<String>(
              title: Text(mode),
              value: mode,
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() => _themeMode = value!);
                _saveSettings();
                widget.onThemeChanged(_themeMode);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDailyGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ежедневная цель (минуты)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Сколько минут вы хотите учить каждый день?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (_dailyGoal > 5) {
                      setState(() => _dailyGoal -= 5);
                      _saveSettings();
                    }
                  },
                ),
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    '$_dailyGoal',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    if (_dailyGoal < 120) {
                      setState(() => _dailyGoal += 5);
                      _saveSettings();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('мин/день', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Размер шрифта'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _fontSizes.map((size) {
            return RadioListTile<String>(
              title: Text(size),
              value: size,
              groupValue: _fontSize,
              onChanged: (value) {
                setState(() => _fontSize = value!);
                _saveSettings();
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'PolyglotJoy',
      applicationVersion: 'v1.0.0',
      applicationIcon: const Icon(Icons.translate, size: 48),
      children: const [
        Text('''
Ваш личный помощник в изучении иностранных языков.

Особенности:
• 8 интерактивных уроков
• Тренировка произношения
• Персональные рекомендации
• Ежедневные напоминания

Разработано с любовью для изучающих языки ♥️
        '''),
      ],
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              Navigator.pop(context);
            },
            child: const Text('Сбросить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildSectionHeader('Уведомления и звук'),
          SwitchListTile(
            value: _notificationsOn,
            title: const Text('Push-уведомления'),
            subtitle: const Text('Получать напоминания о занятиях'),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications_none,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onChanged: (value) {
              setState(() => _notificationsOn = value);
              _saveSettings();
            },
          ),
          SwitchListTile(
            value: _dailyReminder,
            title: const Text('Ежедневное напоминание'),
            subtitle: const Text('Напоминать в 20:00'),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.alarm, color: Theme.of(context).primaryColor),
            ),
            onChanged: (value) {
              setState(() => _dailyReminder = value);
              _saveSettings();
            },
          ),
          SwitchListTile(
            value: _soundEffects,
            title: const Text('Звуковые эффекты'),
            subtitle: const Text('Звуки при правильных ответах'),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.volume_up,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onChanged: (value) {
              setState(() => _soundEffects = value);
              _saveSettings();
            },
          ),
          const SizedBox(height: 8),
          _buildSectionHeader('Обучение'),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.language,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: const Text('Язык интерфейса'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showLanguageDialog,
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.school, color: Theme.of(context).primaryColor),
            ),
            title: const Text('Уровень владения'),
            subtitle: Text(_selectedLevel),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showLevelDialog,
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.timer, color: Theme.of(context).primaryColor),
            ),
            title: const Text('Ежедневная цель'),
            subtitle: Text('$_dailyGoal минут в день'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showDailyGoalDialog,
          ),
          SwitchListTile(
            value: _autoPlayAudio,
            title: const Text('Автовоспроизведение аудио'),
            subtitle: const Text('Автоматически проигрывать аудио к словам'),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.audiotrack,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onChanged: (value) {
              setState(() => _autoPlayAudio = value);
              _saveSettings();
            },
          ),
          SwitchListTile(
            value: _showTranslation,
            title: const Text('Показывать перевод'),
            subtitle: const Text('Отображать перевод под словами'),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.translate,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onChanged: (value) {
              setState(() => _showTranslation = value);
              _saveSettings();
            },
          ),
          const SizedBox(height: 8),
          _buildSectionHeader('Внешний вид'),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.palette, color: Theme.of(context).primaryColor),
            ),
            title: const Text('Тема приложения'),
            subtitle: Text(_themeMode),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showThemeDialog,
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.text_fields,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: const Text('Размер шрифта'),
            subtitle: Text(_fontSize),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showFontSizeDialog,
          ),
          const SizedBox(height: 8),
          _buildSectionHeader('О приложении'),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.info_outline,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: const Text('О приложении'),
            subtitle: const Text('PolyglotJoy v1.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showAboutDialog,
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.restore, color: Colors.red),
            ),
            title: const Text(
              'Сбросить настройки',
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text('Вернуть все настройки по умолчанию'),
            onTap: _resetSettings,
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'PolyglotJoy © 2024',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ==================== СТРАНИЦА ДЕТАЛЕЙ УРОКА ====================
class LessonDetailPage extends StatelessWidget {
  const LessonDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lesson =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    // Если аргументы не переданы, показываем заглушку
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
      backgroundColor: const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF2C3E50),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                lesson['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
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
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    left: -30,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(icon, size: 56, color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          lesson['title']!,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black26,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
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
                        const SizedBox(height: 40),
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
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
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
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: gradientColors,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(icon, size: 24, color: Colors.white),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              'Материалы урока',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.3,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: Color(0xFFE8ECF0)),
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
    switch (title) {
      case 'Урок 1: Основы':
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      case 'Урок 2: Грамматика':
        return [const Color(0xFFEC4899), const Color(0xFFF43F5E)];
      case 'Урок 3: Словарь':
        return [const Color(0xFF06B6D4), const Color(0xFF3B82F6)];
      case 'Урок 4: Разговорная практика':
        return [const Color(0xFF10B981), const Color(0xFF34D399)];
      case 'Урок 5: Аудирование':
        return [const Color(0xFFF59E0B), const Color(0xFFEF4444)];
      case 'Урок 6: Письмо':
        return [const Color(0xFF8B5CF6), const Color(0xFFD946EF)];
      case 'Урок 7: Чтение':
        return [const Color(0xFF14B8A6), const Color(0xFF2DD4BF)];
      case 'Урок 8: Культура и традиции':
        return [const Color(0xFFF97316), const Color(0xFFFBBF24)];
      default:
        return [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    }
  }

  IconData _getLessonIcon(String title) {
    switch (title) {
      case 'Урок 1: Основы':
        return Icons.auto_stories_rounded;
      case 'Урок 2: Грамматика':
        return Icons.abc_rounded;
      case 'Урок 3: Словарь':
        return Icons.menu_book_rounded;
      case 'Урок 4: Разговорная практика':
        return Icons.record_voice_over_rounded;
      case 'Урок 5: Аудирование':
        return Icons.headphones_rounded;
      case 'Урок 6: Письмо':
        return Icons.edit_note_rounded;
      case 'Урок 7: Чтение':
        return Icons.library_books_rounded;
      case 'Урок 8: Культура и традиции':
        return Icons.public_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  String _getLessonContent(String title) {
    switch (title) {
      case 'Урок 1: Основы':
        return '''
📚 **УРОК 1: ОСНОВЫ АНГЛИЙСКОГО ЯЗЫКА**

🔤 **Алфавит:** 26 букв (A-Z)
🗣️ **Фонетика:** /θ/ (think), /ð/ (this), /æ/ (cat)
👋 **Приветствия:** Hello, Hi, Good morning, Good evening
🔢 **Числа 1-20:** One, Two, Three... Twenty

💡 **Совет:** Практикуйтесь по 15 минут каждый день!
        ''';
      default:
        return 'Содержимое урока';
    }
  }
}
