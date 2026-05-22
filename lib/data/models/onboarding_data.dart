import 'package:flutter/material.dart';
import 'package:clinic_management_app/presentation/blocs/onboarding/onboarding_state.dart';

class OnboardingItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const OnboardingItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingData {
  static List<OnboardingItem> get adminSteps => [
        const OnboardingItem(
          icon: Icons.admin_panel_settings_rounded,
          iconColor: Color(0xFF80d8a6),
          title: 'مَرْحَباً بِكَ فِي نِظَامِ الإِدَارَةِ الطِّبِّيَّةِ',
          subtitle: 'نُسَاعِدُكَ عَلَى إِدَارَةِ عِيَادَتِكَ بِكُلِّ يُسْرٍ وَاحْتِرَافِيَّةٍ، مِنْ جَدْوَلَةِ المَوَاعِيدِ إِلَى مُتَابَعَةِ المَرْضَى بِكَفَاءَةٍ لا نَظِيرَ لَهَا.',
        ),
        const OnboardingItem(
          icon: Icons.calendar_month_rounded,
          iconColor: Color(0xFF40e78c),
          title: 'تَحَكَّمْ بِجَدْوَلِ الأَطِبَّاءِ وَالمَوَاعِيدِ',
          subtitle: 'أَضِفْ فَرِيقَكَ الطِّبِّيَّ بِسُهُولَةٍ، وَأَدِرْ مَوَاعِيدَهُمْ بِمُرُونَةٍ تَامَّةٍ، مَعَ إِشْعَارَاتٍ ذَكِيَّةٍ لِلتَّذْكِيرِ وَتَنَبُّهَاتٍ فَوْرِيَّةٍ لِلمَرْضَى.',
        ),
        const OnboardingItem(
          icon: Icons.dashboard_customize_rounded,
          iconColor: Color(0xFF93ecb8),
          title: 'لَوْحَةُ تَحَكُّمٍ شَامِلَةٌ لِنَجَاحِ عِيَادَتِكَ',
          subtitle: 'تَتَبَّعْ إِحْصَائِيَّاتِ العِيَادَةِ وَالإِيرَادَاتِ وَرِضَا المَرْضَى فِي لَوْحَةٍ وَاحِدَةٍ مُبَسَّطَةٍ، وَاتَّخِذْ قَرَارَاتِكَ بِثِقَةٍ وَاقْتِدَارٍ.',
        ),
      ];

  static List<OnboardingItem> get doctorSteps => [
        const OnboardingItem(
          icon: Icons.local_hospital_rounded,
          iconColor: Color(0xFF80d8a6),
          title: 'مَرْحَباً بِكَ دُكْتُورَنَا الفَاضِلُ',
          subtitle: 'نُقَدِّمُ لَكَ أَدَاةً مُتَطَوِّرَةً تُسَاعِدُكَ فِي رِعَايَةِ مَرْضَاكَ بِكَفَاءَةٍ وَدِقَّةٍ، وَتُوَفِّرُ لَكَ وَقْتَكَ وَجُهْدَكَ لِلتَّرْكِيزِ عَلَى مَا يَهُمُّ حَقّاً.',
        ),
        const OnboardingItem(
          icon: Icons.schedule_rounded,
          iconColor: Color(0xFF40e78c),
          title: 'جَدْوَلُ مَوَاعِيدِكَ بِبَسَاطَةٍ وَذَكَاءٍ',
          subtitle: 'اطَّلِعْ عَلَى مَوَاعِيدِكَ اليَوْمِيَّةَ فِي نَظْرَةٍ، أَدِرْهَا بِسُهُولَةٍ، وَاسْتَعْرِضْ سِجِلَّاتِ مَرْضَاكَ الطِّبِّيَّةَ فِي لَحَظَاتٍ.',
        ),
        const OnboardingItem(
          icon: Icons.connect_without_contact_rounded,
          iconColor: Color(0xFF93ecb8),
          title: 'تَوَاصَلْ مَعَ مَرْضَاكَ بِاحْتِرَافِيَّةٍ',
          subtitle: 'سَجِّلْ المُلَاحَظَاتِ الطِّبِّيَّةَ، تَابَعْ سِجِلَّاتِهِمُ السَّابِقَةَ، وَارْفَعْ تَقَارِيرَ العِلَاجِ وَالوَصَفَاتِ الطِّبِّيَّةَ بِكُلِّ يُسْرٍ.',
        ),
      ];

  static List<OnboardingItem> get receptionistSteps => [
        const OnboardingItem(
          icon: Icons.assignment_ind_rounded,
          iconColor: Color(0xFF80d8a6),
          title: 'مَرْحَباً بِكَ مَسْؤُولَ الاسْتِقْبَالِ',
          subtitle: 'نُسَاعِدُكَ عَلَى إِدَارَةِ مَوَاعِيدِ المَرْضَى وَتَسْجِيلِهِمْ بِسُهُولَةٍ وَاحْتِرَافِيَّةٍ.',
        ),
        const OnboardingItem(
          icon: Icons.calendar_month_rounded,
          iconColor: Color(0xFF40e78c),
          title: 'إِدَارَةُ المَوَاعِيدِ وَالمَرْضَى',
          subtitle: 'أَضِفْ المَرْضَى الجُدُدَ، وَجَدْوِلْ مَوَاعِيدَهُمْ مَعَ الأَطِبَّاءِ بِسُرْعَةٍ وَدِقَّةٍ.',
        ),
        const OnboardingItem(
          icon: Icons.contact_phone_rounded,
          iconColor: Color(0xFF93ecb8),
          title: 'التَّوَاصُلُ وَالتَّنْسِيقُ',
          subtitle: 'تَابِعْ بَيَانَاتِ المَرْضَى، وَقُمْ بِالتَّنْسِيقِ مَعَ الأَطِبَّاءِ لِضَمَانِ سَيْرِ العَمَلِ بِانْسِيَابِيَّةٍ تَامَّةٍ.',
        ),
      ];

  static List<OnboardingItem> get patientSteps => [
        const OnboardingItem(
          icon: Icons.person_pin_rounded,
          iconColor: Color(0xFF80d8a6),
          title: 'أَهْلاً بِكَ فِي بَوَّابَةِ المَرْضَى',
          subtitle: 'تَطْبِيقُنَا يُسَاعِدُكَ عَلَى مُتَابَعَةِ مَوَاعِيدِكَ الطِّبِّيَّةِ وَسِجِلَّاتِكَ الصِّحِّيَّةِ بِكُلِّ يُسْرٍ.',
        ),
        const OnboardingItem(
          icon: Icons.calendar_today_rounded,
          iconColor: Color(0xFF40e78c),
          title: 'مَوَاعِيدُكَ فِي نَظْرَةٍ',
          subtitle: 'اسْتَعْرِضْ مَوَاعِيدَكَ القَادِمَةَ وَالسَّابِقَةَ، وَاسْتَقْبِلْ تَذْكِيرَاتٍ فَوْرِيَّةً لِمَوَاعِيدِكَ.',
        ),
        const OnboardingItem(
          icon: Icons.health_and_safety_rounded,
          iconColor: Color(0xFF93ecb8),
          title: 'سِجِلَّاتُكَ الطِّبِّيَّةُ',
          subtitle: 'اطَّلِعْ عَلَى سِجِلَّاتِكَ الطِّبِّيَّةَ السَّابِقَةَ، التَّشْخِيصَاتِ، وَالوَصَفَاتِ فِي أَيِّ وَقْتٍ وَمِنْ أَيِّ مَكَانٍ.',
        ),
      ];

  static List<OnboardingItem> getItems(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return adminSteps;
      case UserRole.doctor:
        return doctorSteps;
      case UserRole.receptionist:
        return receptionistSteps;
      case UserRole.patient:
        return patientSteps;
    }
  }
}
