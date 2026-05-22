import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/presentation/screens/onboarding/onboarding_data.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_state.dart';
import 'package:clinic_management_app/presentation/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state.selectedRole == null) return const SizedBox.shrink();

        final items = OnboardingData.getItems(state.selectedRole!);
        final isLast = state.currentPage == items.length - 1;

        return Scaffold(
          body: Column(
            children: [
              _buildTopBar(colors, state),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: items.length,
                  onPageChanged: (page) {
                    context.read<OnboardingCubit>().setPage(page);
                  },
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return OnboardingPage(
                      icon: item.icon,
                      iconColor: item.iconColor,
                      title: item.title,
                      subtitle: item.subtitle,
                      isLast: index == items.length - 1,
                    );
                  },
                ),
              ),
              _buildBottomSection(colors, state, isLast),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(AppColorSet colors, OnboardingState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              context.read<OnboardingCubit>().resetOnboarding();
              Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
            },
            child: Text(
              'عودة',
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => _completeOnboarding(context),
            child: Text(
              'تخط', 
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(AppColorSet colors, OnboardingState state, bool isLast) {
    final items = OnboardingData.getItems(state.selectedRole!);

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressDots(colors, items.length, state.currentPage),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (isLast) {
                  _completeOnboarding(context);
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primaryDark,
                foregroundColor: colors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLast) ...[
                    Icon(Icons.check_circle_rounded, color: colors.primaryLight),
                    const SizedBox(width: 10),
                    Text(
                      'الدُّخُولِ إِلَى التَّطْبِيقِ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.primaryLight),
                    ),
                  ] else ...[
                    Text(
                      'تَابِع',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.primaryLight),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.arrow_forward_rounded, color: colors.primaryLight),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.read<OnboardingCubit>().completeOnboarding().then((_) {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              });
            },
            child: Text(
              'لَدَيْكَ حِسَابٌ بِالفِعْلِ؟ تَسْجِيلُ الدُّخُولِ',
              style: TextStyle(
                color: colors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDots(AppColorSet colors, int count, int currentPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 32 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive ? colors.primary : colors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  void _completeOnboarding(BuildContext context) {
    context.read<OnboardingCubit>().completeOnboarding().then((_) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }
}
