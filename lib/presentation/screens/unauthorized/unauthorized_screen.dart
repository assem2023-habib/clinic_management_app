import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'unauthorized_painters.dart';
import 'widgets/ua_icon_section.dart';
import 'widgets/ua_content.dart';
import 'widgets/ua_actions.dart';
import 'widgets/ua_data_nodes.dart';

class UnauthorizedScreen extends StatelessWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onGoHome;

  const UnauthorizedScreen({
    super.key,
    this.onLogin,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00180B),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: UaParticlePainter(),
                ),
              ),
            ),
            Column(
              children: [
                _buildAppBar(context),
                Expanded(child: _buildContent()),
                _buildFooter(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFFC6EBD1),
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const UaIconSection(),
            const SizedBox(height: 40),
            const UaContent(),
            const SizedBox(height: 32),
            UaActions(onLogin: onLogin, onGoHome: onGoHome),
            const SizedBox(height: 32),
            const UaDataNodes(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white, width: 0.5)),
      ),
      child: const Text(
        AppStrings.uaFooter,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFBBCABF),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
