import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_spacing.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';

class SrSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSearch;

  const SrSearchBar({super.key, this.controller, this.onSearch});

  @override
  State<SrSearchBar> createState() => _SrSearchBarState();
}

class _SrSearchBarState extends State<SrSearchBar> {
  bool _isFocused = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: const Color(0xFF032515).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused
              ? const Color(0xFF80D8A6).withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFFBBCABF), size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onSearch,
              decoration: InputDecoration(
                hintText: AppStrings.srSearchHint,
                hintStyle: const TextStyle(
                  color: Color(0xFFBBCABF),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFFC6EBD1)),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.tune_rounded, color: Color(0xFF80D8A6), size: 22),
        ],
      ),
    );
  }
}

