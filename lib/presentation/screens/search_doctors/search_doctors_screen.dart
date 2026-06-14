import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clinic_management_app/core/constants/app_routes.dart';
import 'package:clinic_management_app/core/constants/app_strings.dart';
import 'package:clinic_management_app/domain/entities/doctor_entity.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_bloc.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_event.dart';
import 'package:clinic_management_app/presentation/blocs/doctor/doctor_state.dart';
import 'package:clinic_management_app/presentation/screens/search_doctors/widgets/sd_doctor_card.dart';
import 'package:clinic_management_app/presentation/widgets/skeleton/skeleton.dart';

class SearchDoctorsScreen extends StatefulWidget {
  const SearchDoctorsScreen({super.key});

  @override
  State<SearchDoctorsScreen> createState() => _SearchDoctorsScreenState();
}

class _SearchDoctorsScreenState extends State<SearchDoctorsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = AppStrings.sdFilterAll;
  bool _showAllDoctors = false;

  static const _filters = [
    AppStrings.sdFilterAll,
    AppStrings.sdFilterCardiology,
    AppStrings.sdFilterNeurology,
    AppStrings.sdFilterDental,
  ];

  @override
  void initState() {
    super.initState();
    context.read<DoctorBloc>().add(DoctorLoadAll());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DoctorEntity> _filterDoctors(List<DoctorEntity> doctors) {
    return doctors.where((d) {
      final matchesSearch = _query.isEmpty ||
          d.name.contains(_query) ||
          d.specialty.contains(_query);
      final matchesFilter = _selectedFilter == AppStrings.sdFilterAll ||
          d.specialty.contains(_selectedFilter);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00180B),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: BlocBuilder<DoctorBloc, DoctorState>(
                builder: (context, state) {
                  if (state is DoctorLoading && !_showAllDoctors) {
                    _showAllDoctors = true;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF80D8A6),
                      ),
                    );
                  }
                  if (state is DoctorLoaded || state is DoctorLoading) {
                    final doctors = state is DoctorLoaded
                        ? state.doctors
                        : <DoctorEntity>[];
                    final filtered = _filterDoctors(doctors);
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchSection(),
                          const SizedBox(height: 12),
                          _buildFilterChips(),
                          const SizedBox(height: 16),
                          _buildResultsCount(filtered.length),
                          const SizedBox(height: 12),
                          if (state is DoctorLoading && doctors.isEmpty)
                            const SkeletonList()
                          else if (filtered.isEmpty)
                            _buildEmptyState()
                          else
                            ...filtered.map((doctor) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: SdDoctorCard(
                                    doctor: doctor,
                                    onBook: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.userBooking,
                                      arguments: doctor.id,
                                    ),
                                    onChat: () {},
                                  ),
                                )),
                        ],
                      ),
                    );
                  }
                  if (state is DoctorError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Color(0xFFC6EBD1)),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF00180B).withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            color: const Color(0xFF80D8A6),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              AppStrings.sdTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF80D8A6),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
            color: const Color(0xFFBEC9BF),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF002111),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFFC6EBD1),
              ),
              decoration: InputDecoration(
                hintText: AppStrings.sdSearchHint,
                hintStyle: const TextStyle(
                  color: Color(0xFF88938A),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF88938A),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() => _query = value);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF032515).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded),
            color: const Color(0xFF80D8A6),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF006D44)
                    : const Color(0xFF032515).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(9999),
                border: isSelected
                    ? null
                    : Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF93ECB8)
                        : const Color(0xFFBEC9BF),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsCount(int count) {
    return Text(
      '${AppStrings.sdResultsCount} $count ${AppStrings.sdDoctor}',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFFBEC9BF),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: const Color(0xFF88938A).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'لم يتم العثور على أطباء',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF88938A),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
