import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      title: 'Привет!',
      subtitle: 'Изучайте английский с удовольствием.',
      icon: Icons.language,
      gradient: [Color(0xFF3DDC97), Color(0xFF1DB954)],
    ),
    _OnboardingSlide(
      title: 'Выберите язык',
      subtitle: 'Русский, английский и другие.',
      icon: Icons.translate,
      gradient: [Color(0xFF6EE7B7), Color(0xFF3DDC97)],
    ),
    _OnboardingSlide(
      title: 'Пройдите тест',
      subtitle: '50+ вопросов и прогресс-механики.',
      icon: Icons.quiz,
      gradient: [Color(0xFF1EBE9D), Color(0xFF16AB8B)],
    ),
    _OnboardingSlide(
      title: 'Начали!',
      subtitle: 'Успех рядом: впереди много знаний.',
      icon: Icons.emoji_events,
      gradient: [Color(0xFF1DB954), Color(0xFF0E9766)],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() => _page = index),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: slide.gradient,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(slide.icon, size: 52, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        slide.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        slide.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 34,
            right: 16,
            child: TextButton(
              onPressed: _skip,
              child: const Text(
                'Пропустить',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _page == index ? 26 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _page == index ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _slides[_page].gradient.last,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _next,
                    child: Text(
                      _page == _slides.length - 1 ? 'Начать' : 'Далее',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
