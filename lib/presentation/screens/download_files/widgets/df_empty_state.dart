import 'package:flutter/material.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/presentation/widgets/empty_data/empty_data_widget.dart';

class DfEmptyState extends StatelessWidget {
  const DfEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyDataWidget(
      icon: Icons.folder_open_rounded,
      title: AppStrings.dfNoFiles,
      subtitle: AppStrings.dfNoFilesHint,
      compact: true,
    );
  }
}
