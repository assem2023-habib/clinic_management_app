import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/presentation/widgets/app_drawer.dart';
import 'package:clinic_management_app/presentation/widgets/glass_app_bar.dart';
import 'package:clinic_management_app/presentation/widgets/particle_background.dart';

class AppShell extends StatelessWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? header;
  final bool showDrawer;
  final bool showBackButton;
  final EdgeInsetsGeometry? padding;
  final String? currentRoute;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final ThemeProvider? themeProvider;

  final bool useGlassAppBar;
  final String? glassTitle;
  final Widget? glassLeading;
  final Widget? glassTrailing;
  final List<Widget>? glassActions;
  final bool showParticleBg;
  final bool starMode;
  final int particleCount;
  final bool extendBody;
  final Widget? customHeader;

  const AppShell({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.header,
    this.showDrawer = true,
    this.showBackButton = false,
    this.padding,
    this.currentRoute,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.themeProvider,
    this.useGlassAppBar = false,
    this.glassTitle,
    this.glassLeading,
    this.glassTrailing,
    this.glassActions,
    this.showParticleBg = false,
    this.starMode = false,
    this.particleCount = 25,
    this.extendBody = false,
    this.customHeader,
  });

  @override
  Widget build(BuildContext context) {
    final hasGlassAppBar = useGlassAppBar || customHeader != null;
    final usesNewLayout = hasGlassAppBar || showParticleBg;

    final topWidget = customHeader ??
        (useGlassAppBar
            ? GlassAppBar(
                title: glassTitle ?? title ?? '',
                leading: glassLeading,
                trailing: glassTrailing,
                actions: glassActions,
                onLeadingTap: showDrawer
                    ? () => Scaffold.of(context).openDrawer()
                    : (showBackButton ? () => Navigator.pop(context) : null),
              )
            : null);

    Widget scaffoldBody;
    if (usesNewLayout) {
      scaffoldBody = Column(
        children: [
          ?topWidget,
          Expanded(child: body),
        ],
      );
      if (showParticleBg) {
        scaffoldBody = Stack(
          children: [
            ParticleBackground(starMode: starMode, particleCount: particleCount),
            SafeArea(child: scaffoldBody),
          ],
        );
      }
    } else {
      scaffoldBody = Padding(
        padding: padding ?? AppSpacing.screenPadding,
        child: body,
      );
    }

    return Scaffold(
      extendBody: extendBody,
      extendBodyBehindAppBar: usesNewLayout,
      appBar: usesNewLayout
          ? null
          : header ??
              (title != null || showBackButton
                  ? AppBar(
                      title: Text(title ?? ''),
                      leading: showBackButton
                          ? IconButton(
                              icon: const Icon(Icons.arrow_forward_rounded),
                              onPressed: () => Navigator.pop(context),
                            )
                          : null,
                      actions: actions,
                    )
                  : null),
      drawer: showDrawer ? AppDrawer(currentRoute: currentRoute, themeProvider: themeProvider) : null,
      body: scaffoldBody,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
