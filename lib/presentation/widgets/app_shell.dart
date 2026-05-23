import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/theme/theme_provider.dart';
import 'package:clinic_management_app/presentation/widgets/app_drawer.dart';

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
  final ThemeProvider? themeProvider;

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
    this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header ??
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
      body: Padding(
        padding: padding ?? AppSpacing.screenPadding,
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
