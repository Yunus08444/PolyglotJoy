import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../services/api/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _editFirstNameController = TextEditingController();
  final _editLastNameController = TextEditingController();
  bool _isUpdating = false;
  
  int _completedTests = 0;
  int _completedLessons = 0;
  int _totalPoints = 0;
  int _streakDays = 0;
  String _currentLanguage = 'Английский';
  String _level = 'Средний (B1)';
  bool _isLoadingStats = true;

  final List<String> _languages = [
    'Английский', 'Испанский', 'Французский', 
    'Немецкий', 'Китайский', 'Японский', 'Корейский'
  ];
  
  final List<String> _levels = [
    'Начинающий (A1)', 'Элементарный (A2)', 
    'Средний (B1)', 'Выше среднего (B2)', 
    'Продвинутый (C1)', 'Профессиональный (C2)'
  ];

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUserStats();
  }

  @override
  void dispose() {
    _editFirstNameController.dispose();
    _editLastNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserStats() async {
    setState(() => _isLoadingStats = true);
    
    try {
      final stats = await _authService.getUserStats();
      setState(() {
        _completedTests = stats['completed_tests'] ?? 0;
        _completedLessons = stats['completed_lessons'] ?? 0;
        _totalPoints = stats['total_points'] ?? 0;
        _streakDays = stats['streak_days'] ?? 0;
        _currentLanguage = stats['current_language'] ?? 'Английский';
        _level = stats['level'] ?? 'Средний (B1)';
      });
    } catch (e) {
      debugPrint('Error loading stats: $e');
    } finally {
      setState(() => _isLoadingStats = false);
    }
  }

  Future<void> _updateUserName(String? firstName, String? lastName) async {
    if (firstName == null && lastName == null) return;
    
    setState(() => _isUpdating = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    try {
      await _authService.updateProfile(firstName: firstName, lastName: lastName);
      await authProvider.tryAutoLogin();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Имя успешно обновлено!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _updateLanguage(String language) async {
    setState(() => _isUpdating = true);
    
    try {
      await _authService.updatePreferences(currentLanguage: language);
      setState(() => _currentLanguage = language);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Язык сохранен!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _updateLevel(String level) async {
    setState(() => _isUpdating = true);
    
    try {
      await _authService.updatePreferences(level: level);
      setState(() => _level = level);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Уровень сохранен!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  void _showEditNameDialog(User user) {
    _editFirstNameController.text = user.firstName ?? '';
    _editLastNameController.text = user.lastName ?? '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Редактировать профиль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _editFirstNameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _editLastNameController,
              decoration: const InputDecoration(
                labelText: 'Фамилия',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateUserName(
                _editFirstNameController.text.isNotEmpty ? _editFirstNameController.text : null,
                _editLastNameController.text.isNotEmpty ? _editLastNameController.text : null,
              );
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Выберите язык для изучения', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._languages.map((lang) => ListTile(
              leading: Icon(_getLanguageIcon(lang), color: const Color(0xFF6366F1)),
              title: Text(lang),
              trailing: _currentLanguage == lang ? const Icon(Icons.check, color: Color(0xFF6366F1)) : null,
              onTap: () {
                Navigator.pop(context);
                _updateLanguage(lang);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showLevelDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ваш уровень владения', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._levels.map((level) => ListTile(
              leading: _getLevelIcon(level),
              title: Text(level),
              trailing: _level == level ? const Icon(Icons.check, color: Color(0xFF6366F1)) : null,
              onTap: () {
                Navigator.pop(context);
                _updateLevel(level);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showAchievementsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Достижения', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAchievementItem(Icons.local_fire_department, '7 дней подряд', _streakDays >= 7, Colors.orange, value: '$_streakDays/7'),
            const SizedBox(height: 12),
            _buildAchievementItem(Icons.school, '10 уроков', _completedLessons >= 10, Colors.blue, value: '$_completedLessons/10'),
            const SizedBox(height: 12),
            _buildAchievementItem(Icons.emoji_events, '1000 очков', _totalPoints >= 1000, Colors.amber, value: '$_totalPoints/1000'),
            const SizedBox(height: 12),
            _buildAchievementItem(Icons.quiz, '5 тестов', _completedTests >= 5, Colors.green, value: '$_completedTests/5'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрыть')),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(IconData icon, String title, bool achieved, Color color, {String? value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: achieved ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: achieved ? color : Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: TextStyle(color: achieved ? color : Colors.grey))),
          if (value != null) Text(value, style: TextStyle(color: achieved ? color : Colors.grey, fontSize: 12)),
          const SizedBox(width: 8),
          Icon(achieved ? Icons.check_circle : Icons.lock_outline, color: achieved ? Colors.green : Colors.grey, size: 20),
        ],
      ),
    );
  }

  IconData _getLanguageIcon(String language) {
    switch (language) {
      case 'Английский': return Icons.g_translate;
      case 'Испанский': return Icons.flag;
      default: return Icons.language;
    }
  }

  Widget _getLevelIcon(String level) {
    if (level.contains('A1') || level.contains('A2')) {
      return const Icon(Icons.auto_graph, color: Colors.green);
    } else if (level.contains('B1') || level.contains('B2')) {
      return const Icon(Icons.trending_up, color: Colors.orange);
    } else {
      return const Icon(Icons.rocket, color: Colors.purple);
    }
  }

  void _logout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Выход из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          TextButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            child: const Text('Выйти', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  int _getAchievementsCount() {
    int count = 0;
    if (_streakDays >= 7) count++;
    if (_completedLessons >= 10) count++;
    if (_totalPoints >= 1000) count++;
    if (_completedTests >= 5) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          if (authProvider.isLoading || _isLoadingStats) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return const Center(child: Text('Пользователь не найден'));
          }

          return RefreshIndicator(
            onRefresh: _loadUserStats,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 3),
                                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
                                  ),
                                  child: const CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person, size: 50, color: Color(0xFF6366F1)),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _showEditNameDialog(user),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                      child: const Icon(Icons.edit, size: 18, color: Color(0xFF6366F1)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => _showEditNameDialog(user),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    user.displayName,
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.edit, size: 18, color: Colors.white70),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(user.email, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                              child: Text('@${user.username}', style: const TextStyle(fontSize: 12, color: Colors.white)),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _buildStatCard(Icons.quiz, 'Тесты', _completedTests, 'завершено'),
                            _buildStatCard(Icons.menu_book, 'Уроки', _completedLessons, 'пройдено'),
                            _buildStatCard(Icons.local_fire_department, 'Серия', _streakDays, 'дней'),
                            _buildStatCard(Icons.stars, 'Очки', _totalPoints, 'всего'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.trending_up, color: Color(0xFF6366F1)),
                                  SizedBox(width: 8),
                                  Text('Прогресс обучения', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value: _completedLessons / 8,
                                backgroundColor: Colors.grey[200],
                                color: const Color(0xFF6366F1),
                                borderRadius: BorderRadius.circular(10),
                                minHeight: 8,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${((_completedLessons / 8) * 100).toInt()}% завершено', style: TextStyle(color: Colors.grey[600])),
                                  Text('$_completedLessons/8 уроков', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                          ),
                          child: Column(
                            children: [
                              _buildProfileTile(
                                icon: Icons.language,
                                title: 'Изучаемый язык',
                                subtitle: _currentLanguage,
                                color: const Color(0xFF06B6D4),
                                onTap: _showLanguageDialog,
                              ),
                              const Divider(height: 1, indent: 60),
                              _buildProfileTile(
                                icon: Icons.school,
                                title: 'Уровень владения',
                                subtitle: _level,
                                color: const Color(0xFF10B981),
                                onTap: _showLevelDialog,
                              ),
                              const Divider(height: 1, indent: 60),
                              _buildProfileTile(
                                icon: Icons.emoji_events,
                                title: 'Достижения',
                                subtitle: '${_getAchievementsCount()}/4 получено',
                                color: const Color(0xFFF59E0B),
                                onTap: _showAchievementsDialog,
                              ),
                              const Divider(height: 1, indent: 60),
                              _buildProfileTile(
                                icon: Icons.settings,
                                title: 'Настройки',
                                subtitle: 'Язык, тема, уведомления',
                                color: const Color(0xFF8B5CF6),
                                onTap: () => Navigator.pushNamed(context, '/settings'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
                          ),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.logout, color: Colors.red),
                            ),
                            title: const Text('Выйти из аккаунта', style: TextStyle(color: Colors.red)),
                            onTap: () => _logout(context, authProvider),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('PolyglotJoy © 2026', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String title, int value, String subtitle) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF6366F1), size: 24),
            const SizedBox(height: 8),
            Text(value.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}