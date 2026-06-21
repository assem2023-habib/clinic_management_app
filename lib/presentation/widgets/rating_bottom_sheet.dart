import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_colors.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';

class RatingBottomSheet extends StatefulWidget {
  final DoctorEntity doctor;
  final void Function(int rating, String comment) onSubmit;

  const RatingBottomSheet({
    super.key,
    required this.doctor,
    required this.onSubmit,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _ratingCtrl;
  final _commentCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();
  int _targetRating = 0;

  @override
  void initState() {
    super.initState();
    _ratingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      upperBound: 5,
    )..addListener(() => setState(() {}));
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _ratingCtrl.dispose();
    _commentCtrl.dispose();
    _scrollCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(
            _scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onStarTap(int i) {
    final target = (i + 1).toDouble();
    if (_ratingCtrl.value == target) return;
    _targetRating = i + 1;
    _ratingCtrl.animateTo(target, duration: const Duration(milliseconds: 600), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom + 16;
    final maxH = MediaQuery.of(context).size.height * 0.52;

    return Container(
      constraints: BoxConstraints(maxHeight: maxH),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.88),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
            ),
            padding: EdgeInsets.only(bottom: bottomPad),
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dragHandle(),
                  const SizedBox(height: 16),
                  _header(colors),
                  const SizedBox(height: 6),
                  _doctorName(colors),
                  const SizedBox(height: 24),
                  _starsRow(),
                  const SizedBox(height: 24),
                  _commentField(colors),
                  const SizedBox(height: 16),
                  _sendButton(colors),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 48,
      height: 5,
      decoration: BoxDecoration(
        color: colors.textLight.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }

  Widget _header(AppColorSet colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [colors.primaryDark, colors.accent]),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: colors.accent.withValues(alpha: 0.25), blurRadius: 10)],
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Text(
            'أضف تقييمك',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: colors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _doctorName(AppColorSet colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const SizedBox(width: 58),
          Text(
            'لد. ${widget.doctor.name}',
            style: TextStyle(fontSize: 13, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _starsRow() {
    final val = _ratingCtrl.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final starNum = i + 1;
        final isFull = starNum <= val.floor();
        final fraction = starNum == val.ceil() && !isFull ? val - val.floor() : (isFull ? 1.0 : 0.0);
        final isActive = isFull || fraction > 0.001;

        final scale = isFull ? 1.0 : (starNum == val.ceil() ? 0.85 + fraction * 0.15 : 0.85);
        return GestureDetector(
          onTap: () => _onStarTap(i),
          child: Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isActive ? Colors.amber.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isActive ? Colors.amber.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: 28, height: 28,
                  child: Stack(
                    children: [
                      Icon(Icons.star_outline_rounded, color: Colors.white38, size: 28),
                      ClipRect(
                        clipper: _StarClipper(fraction),
                        child: Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _commentField(AppColorSet colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: TextField(
          controller: _commentCtrl,
          focusNode: _focusNode,
          maxLines: 3,
          style: TextStyle(color: colors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'اكتب تجربتك مع الدكتور...',
            hintStyle: TextStyle(color: colors.textSecondary.withValues(alpha: 0.5), fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _sendButton(AppColorSet colors) {
    final canSend = _targetRating > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: canSend
            ? () {
                widget.onSubmit(_targetRating, _commentCtrl.text.trim());
                Navigator.pop(context);
              }
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 52,
          decoration: BoxDecoration(
            gradient: canSend
                ? LinearGradient(colors: [colors.primaryDark, colors.accent])
                : null,
            color: canSend ? null : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            boxShadow: canSend
                ? [BoxShadow(color: colors.accent.withValues(alpha: 0.3), blurRadius: 16)]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'إرسال التقييم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: canSend ? Colors.white : colors.textSecondary.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.send_rounded,
                size: 20,
                color: canSend ? Colors.white : colors.textSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fraction;
  const _StarClipper(this.fraction);

  @override
  Rect getClip(Size size) => Rect.fromLTRB(0, 0, size.width * fraction, size.height);

  @override
  bool shouldReclip(_StarClipper old) => old.fraction != fraction;
}
