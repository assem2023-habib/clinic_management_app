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

  static List<OnboardingItem> getItems(UserRole role) =>
      role == UserRole.admin ? adminSteps : doctorSteps;
}
