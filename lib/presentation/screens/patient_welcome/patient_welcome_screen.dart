import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/presentation/screens/patient_welcome/patient_welcome_painters.dart';
import 'package:clinic_management_app/presentation/screens/patient_welcome/widgets/pw_background.dart';
import 'package:clinic_management_app/presentation/screens/patient_welcome/widgets/pw_bottom_actions.dart';
import 'package:clinic_management_app/presentation/screens/patient_welcome/widgets/pw_hero_section.dart';
import 'package:clinic_management_app/presentation/screens/patient_welcome/widgets/pw_page_content.dart';

class PatientWelcomeScreen extends StatefulWidget {
  const PatientWelcomeScreen({super.key});

  @override
  State<PatientWelcomeScreen> createState() => _PatientWelcomeScreenState();
}

class _PatientWelcomeScreenState extends State<PatientWelcomeScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _pulseController;
  final List<PwParticleData> _particles = [];
  int _currentPage = 0;

  static final _pageData = <_PageData>[
    _PageData(Icons.monitor_heart_rounded, AppStrings.pwWelcomeTitle, AppStrings.pwWelcomeSubtitle),
    _PageData(Icons.calendar_month_rounded, AppStrings.pwApptsTitle, AppStrings.pwApptsSubtitle),
    _PageData(Icons.folder_rounded, AppStrings.pwRecordsTitle, AppStrings.pwRecordsSubtitle),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();
    final rng = Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(PwParticleData(
        x: rng.nextDouble() * 400, y: rng.nextDouble() * 800,
        speedX: (rng.nextDouble() - 0.5) * 0.3, speedY: (rng.nextDouble() - 0.5) * 0.3,
        size: rng.nextDouble() * 2 + 0.5, opacity: rng.nextDouble() * 0.5 + 0.2,
      ));
    }
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) setState(() => _currentPage = page);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (_) => false);
  }

  void _nextPage() {
    if (_currentPage < _pageData.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _goToDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.scaffoldBg,
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) => PwBackground(
              controller: _pulseController,
              particles: _particles,
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.monitor_heart_rounded, size: AppSpacing.iconSize, color: colors.mint),
                          const SizedBox(width: AppSpacing.six),
                          Text('Vitality', style: TextStyle(fontFamily: 'Sora', fontSize: AppSpacing.heading, fontWeight: FontWeight.w700, color: colors.mint)),
                        ],
                      ),
                      TextButton(
                        onPressed: _goToDashboard,
                        child: Text(AppStrings.pwSkip, style: TextStyle(fontFamily: 'Sora', fontSize: AppSpacing.bodyMedium, fontWeight: FontWeight.w500, color: colors.textMuted)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pageData.length,
                    itemBuilder: (_, i) {
                      final page = _pageData[i];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PwHeroSection(icon: page.icon, chips: chipsForPage(i)),
                          const SizedBox(height: AppSpacing.md),
                          PwPageContent(title: page.title, subtitle: page.subtitle),
                        ],
                      );
                    },
                  ),
                ),
                PwBottomActions(
                  currentPage: _currentPage,
                  totalPages: _pageData.length,
                  startLabel: _currentPage < _pageData.length - 1 ? AppStrings.next : AppStrings.pwStartNow,
                  onStart: _nextPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _PageData(this.icon, this.title, this.subtitle);
}

