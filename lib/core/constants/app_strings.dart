import 'package:flutter/material.dart';
import 'package:clinic_management_app/presentation/blocs/language/language_cubit.dart';

class AppStrings {
  static Locale get _locale => LanguageCubit.currentLocale;
  static bool get _isEn => _locale.languageCode == 'en';
  static String _t(String ar, String en) => _isEn ? en : ar;

  // General
  static String get appName => _t('الْعِيَادَةُ الطِّبِّيَّةُ', 'Clinic Management');
  static String get login => _t('تَسْجِيلُ الدُّخُولِ', 'Login');
  static String get logout => _t('تَسْجِيلُ الخُرُوجِ', 'Logout');
  static String get dashboard => _t('لَوْحَةُ التَّحَكُّمِ', 'Dashboard');
  static String get doctors => _t('الأَطِبَّاءُ', 'Doctors');
  static String get patients => _t('المَرْضَى', 'Patients');
  static String get appointments => _t('المَوَاعِيدُ', 'Appointments');
  static String get medicalRecords => _t('السِّجِلَّاتُ الطِّبِّيَّةُ', 'Medical Records');
  static String get settings => _t('الإِعْدَادَاتُ', 'Settings');
  static String get addDoctor => _t('إِضَافَةُ طَبِيبٍ', 'Add Doctor');
  static String get addPatient => _t('إِضَافَةُ مَرِيضٍ', 'Add Patient');
  static String get addAppointment => _t('إِضَافَةُ مَوْعِدٍ', 'Add Appointment');
  static String get edit => _t('تَعْدِيلُ', 'Edit');
  static String get delete => _t('حَذْفُ', 'Delete');
  static String get save => _t('حِفْظُ', 'Save');
  static String get cancel => _t('إِلْغَاءُ', 'Cancel');
  static String get search => _t('بَحْثٌ...', 'Search...');
  static String get email => _t('البَرِيدُ الإِلِكْتْرُونِيُّ', 'Email');
  static String get password => _t('كَلِمَةُ السِّرِّ', 'Password');
  static String get name => _t('الاسْمُ', 'Name');
  static String get phone => _t('رَقْمُ الهَاتِفِ', 'Phone');
  static String get address => _t('العُنْوَانُ', 'Address');
  static String get specialty => _t('التَّخَصُّصُ', 'Specialty');
  static String get date => _t('التَّارِيخُ', 'Date');
  static String get time => _t('الوَقْتُ', 'Time');
  static String get status => _t('الحَالَةُ', 'Status');
  static String get welcomeBack => _t('مَرْحَباً بِعَوْدَتِكَ!', 'Welcome Back!');
  static String get loginSubtitle => _t('سَجِّلْ الدُّخُولَ لإِدَارَةِ العِيَادَةِ', 'Login to manage your clinic');
  static String get noData => _t('لا تُوجَدُ بَيَانَاتٌ', 'No Data');
  static String get confirmDelete => _t('هَلْ أَنْتَ مُتَأَكِّدٌ مِنَ الحَذْفِ؟', 'Are you sure you want to delete?');
  static String get yes => _t('نَعَمْ', 'Yes');
  static String get no => _t('لا', 'No');
  static String get scheduled => _t('مُجَدْوَلٌ', 'Scheduled');
  static String get completed => _t('مُكْتَمَلٌ', 'Completed');
  static String get cancelled => _t('مُلْغَىً', 'Cancelled');
  static String get inProgress => _t('قَيْدُ التَّنْفِيذِ', 'In Progress');
  static String get totalDoctors => _t('إِجْمَالِيُّ الأَطِبَّاءِ', 'Total Doctors');
  static String get totalPatients => _t('إِجْمَالِيُّ المَرْضَى', 'Total Patients');
  static String get todayAppointments => _t('مَوَاعِيدُ اليَوْمِ', "Today's Appointments");
  static String get pendingAppointments => _t('مُعَلَّقٌ', 'Pending');

  // Roles
  static String get roleAdmin => _t('مُدِير العِيَادَة', 'Admin');
  static String get roleDoctor => _t('طَبِيب', 'Doctor');
  static String get roleReceptionist => _t('مَسْؤُول الاسْتِقْبَال', 'Receptionist');
  static String get rolePatient => _t('مَرِيض', 'Patient');
  static String get roleUser => _t('مُسْتَخْدِم', 'User');
  static String get loginAs => _t('تَسْجِيلُ الدُّخُولِ بِصِفَةِ', 'Login as');
  static String get chooseRole => _t('اخْتَرْ دَوْرَكَ', 'Choose Your Role');
  static String get chooseRoleToStart => _t('اخْتَرْ دَوْرَكَ لِلْبَدْءِ', 'Choose your role to start');
  static String get backToRoleSelection => _t('العَوْدَةُ لِاخْتِيَارِ الدَّوْرِ', 'Back to Role Selection');
  static String get noAccountCreate => _t('لَيْسَ لَدَيْكَ حِسَابٌ؟ إِنْشَاءُ حِسَابٍ', "Don't have an account? Create one");
  static String get haveAccountLogin => _t('لَدَيْكَ حِسَابٌ بِالفِعْلِ؟ تَسْجِيلُ الدُّخُولِ', 'Already have an account? Login');
  static String get haveAccountLogin2 => _t('لَدَيْكَ حِسَابٌ؟ سَجِّلُ الدُّخُولَ', 'Have an account? Login');

  // Navigation / Drawer
  static String get myProfile => _t('المِلَفُّ الشَّخْصِيُّ', 'My Profile');
  static String get darkMode => _t('الوَضْعُ الدَّاكِنُ', 'Dark Mode');
  static String get lightMode => _t('الوَضْعُ الفَاتِحُ', 'Light Mode');

  // Quick Actions
  static String get quickActions => _t('إِجْرَاءَاتٌ سَرِيعَةٌ', 'Quick Actions');
  static String get viewRecords => _t('عَرْضُ السِّجِلَّاتِ', 'View Records');
  static String get latestAppointments => _t('آخِرُ المَوَاعِيدِ', 'Latest Appointments');
  static String get myAppointments => _t('مَوَاعِيدِي', 'My Appointments');
  static String get myPatients => _t('مَرْضَايَ', 'My Patients');
  static String get myRecords => _t('سِجِلَّاتِي', 'My Records');
  static String get myFile => _t('مَلَفِّي', 'My File');
  static String get medicalReport => _t('تَقْرِيرٌ', 'Report');
  static String get registerPatient => _t('تَسْجِيلُ مَرِيضٍ', 'Register Patient');
  static String get newAppointment => _t('مَوْعِدٌ جَدِيدٌ', 'New Appointment');
  static String get todaySchedule => _t('جَدْوَلُ اليَوْمِ', "Today's Schedule");

  // Dashboard stats cards
  static String get myPatientsV2 => _t('مَرْضَايَ', 'My Patients');
  static String get todayAppts => _t('مَوَاعِيدُ اليَوْمِ', "Today's Appointments");
  static String get pendingAppts => _t('مَوَاعِيدُ مُعَلَّقَةٌ', 'Pending Appointments');
  static String get completedAppts => _t('مُكَمَّلَةٌ', 'Completed');
  static String get upcomingAppts => _t('مَوَاعِيدُ قَادِمَةٌ', 'Upcoming Appointments');
  static String get previousVisits => _t('زِيَارَاتٌ سَابِقَةٌ', 'Previous Visits');
  static String get invoices => _t('فَوَاتِيرُ', 'Invoices');
  static String get newPatients => _t('مَرْضَى جُدُدٌ', 'New Patients');
  static String get todayCompleted => _t('المُكَمَّلُ اليَوْمَ', "Today's Completed");
  static String get activeUsers => _t('نَشِطُونَ', 'Active');
  static String get inactiveUsers => _t('غَيْرُ نَشِطِينَ', 'Inactive');
  static String get newToday => _t('جَدِيدُ اليَوْمِ', "Today's New");
  static String get newThisWeek => _t('جَدِيدُ الأُسْبُوعِ', "This Week's New");
  static String get newThisMonth => _t('جَدِيدُ الشَّهْرِ', "This Month's New");
  static String get totalAppts => _t('إِجْمَالِيُّ المَوَاعِيدِ', 'Total Appointments');
  static String get thisWeekAppts => _t('هَذَا الأُسْبُوعِ', 'This Week');
  static String get thisMonthAppts => _t('هَذَا الشَّهْرِ', 'This Month');
  static String get confirmedAppts => _t('مُؤَكَّدٌ', 'Confirmed');
  static String get cancelledAppts => _t('مُلْغَىً', 'Cancelled');
  static String get totalPrescriptions => _t('الوَصَفَاتُ الطِّبِّيَّةُ', 'Total Prescriptions');
  static String get totalSpecializations => _t('التَّخَصُّصَاتُ', 'Specializations');
  static String get averageRating => _t('مُتَوَسِّطُ التَّقْيِيمِ', 'Average Rating');
  static String get registeredToday => _t('مُسَجَّلُونَ اليَوْمَ', "Today's Registered");

  // Appointments
  static String get noAppointments => _t('لا تُوجَدُ مَوَاعِيدُ', 'No Appointments');
  static String get complete => _t('إِكْمَالُ', 'Complete');
  static String get appointmentDeleted => _t('تَمَّ حَذْفُ المَوْعِدِ', 'Appointment deleted');
  static String get statusUpdated => _t('تَمَّ تَحْدِيثُ الحَالَةِ', 'Status updated');

  // User Booking Screen
  static String get bookingTitle => _t('جَدْوَلُ المواعيد', 'Appointment Schedule');
  static String get bookingPatientOnly => _t('هَذِهِ المِيزَةُ مُتَاحَةٌ لِلْمَرْضَى فَقَط', 'This feature is for patients only');
  static String get bookingMorning => _t('الفَتْرَةُ الصَّبَاحِيَّةُ', 'Morning');
  static String get bookingEvening => _t('الفَتْرَةُ المَسَائِيَّةُ', 'Evening');
  static String get bookingNoSlots => _t('لا تُوجَدُ مَوَاعِيدُ مُتَاحَةٌ لِهَذَا اليَوْمِ', 'No available slots for this day');
  static String get bookingAvailable => _t('مُتَاح', 'Available');
  static String get bookingConfirm => _t('تَأْكِيدُ الحَجْز', 'Confirm Booking');
  static String get bookingConfirming => _t('جَارٍ تَأْكِيدُ الحَجْز...', 'Confirming Booking...');
  static String get bookingDoctorNotFound => _t('الطَّبِيبُ غَيْرُ مَوْجُودٍ', 'Doctor not found');
  static String get bookingDefaultPatientName => _t('مَرِيض', 'Patient');

  // Appointment Confirmation Screen
  static String get confirmAppointment => _t('تَأْكِيدُ المَوْعِدِ', 'Confirm Appointment');
  static String get confirmationPatientTitle => _t('طَلَبُكَ قَيْدُ المُرَاجَعَةِ', 'Your request is under review');
  static String get confirmationDoctorTitle => _t('تَمَّ تَأْكِيدُ المَوْعِدِ بِنَجَاحٍ!', 'Appointment confirmed successfully!');
  static String get confirmationPatientSubtitle => _t('سَيَقُومُ الطَّبِيبُ بِمُرَاجَعَةِ طَلَبِكَ وَتَأْكِيدِ المَوْعِدِ لاحِقاً', 'The doctor will review and confirm your appointment later');
  static String get confirmationDoctorSubtitle => _t('تَمَّ حِفْظُ المَوْعِدِ فِي جَدْوَلِ المَوَاعِيدِ.', 'The appointment has been saved to your schedule.');
  static String get goToMyAppointments => _t('الذَّهَابُ إِلَى مَوَاعِيدِي', 'Go to My Appointments');
  static String get viewMySchedule => _t('عَرْضُ جَدْوَلِ مَوَاعِيدِي', 'View My Schedule');
  static String get goToAppointmentManagement => _t('الذَّهَابُ إِلَى إِدَارَةِ المَوَاعِيدِ', 'Go to Appointment Management');
  static String get addToCalendar => _t('إِضَافَةٌ إِلَى التَّقْوِيمِ', 'Add to Calendar');
  static String get addedToCalendar => _t('تَمَّتِ الإِضَافَةُ إِلَى التَّقْوِيمِ', 'Added to Calendar');
  static String get importantInstructions => _t('تَعْلِيمَاتٌ هَامَّةٌ:', 'Important Instructions:');
  static String get instructionArriveEarly => _t('يَرْجَى الحُضُورُ قَبْلَ المَوْعِدِ بِـ 15 دَقِيقَةً لِإِتْمَامِ الإِجْرَاءَاتِ.', 'Please arrive 15 minutes before your appointment.');
  static String get instructionBringId => _t('أَحْضِرْ مَعَكَ بِطَاقَةَ الهُوِيَّةِ الوَطَنِيَّةِ أَوْ سِجِلَّ العَائِلَةِ.', 'Bring your ID or family book.');
  static String get location => _t('المَوْقِعُ', 'Location');
  static String get clinic => _t('عِيَادَة', 'Clinic');
  static String get historyLabel => _t('التَّارِيخُ', 'Date');
  static String get timeLabel => _t('الوَقْتُ', 'Time');

  // Doctor Profile
  static String get doctorProfile => _t('مَلَفُّ الطَّبِيبِ', 'Doctor Profile');
  static String get bookAppointment => _t('حَجْزُ مَوْعِدٍ', 'Book Appointment');
  static String get addReview => _t('أَضِفْ تَقْيِيمَكَ', 'Add Review');
  static String get writeReview => _t('اكْتُبْ تَعْلِيقَكَ...', 'Write your review...');
  static String get send => _t('إِرْسَالُ', 'Send');
  static String get editProfile => _t('تَعْدِيلُ المِلَفِّ', 'Edit Profile');
  static String get deleteDoctor => _t('حَذْفُ الطَّبِيبِ', 'Delete Doctor');
  static String get doctorDeleted => _t('تَمَّ حَذْفُ الطَّبِيبِ بِنَجَاحٍ', 'Doctor deleted successfully');
  static String get experience => _t('الخِبْرَةُ', 'Experience');
  static String get doctorPatients => _t('المَرْضَى', 'Patients');
  static String get surgeries => _t('العَمَلِيَّاتُ', 'Surgeries');
  static String get aboutDoctor => _t('نَبْذَةٌ عَنِ الطَّبِيبِ', 'About the Doctor');
  static String get noInfoAvailable => _t('لا تُوجَدُ مَعْلُومَاتٌ مُتَاحَةٌ', 'No info available');
  static String get qualifications => _t('المُؤَهِّلَاتُ العِلْمِيَّةُ', 'Qualifications');
  static String get services => _t('الخِدْمَاتُ', 'Services');
  static String get availableAppts => _t('المَوَاعِيدُ المُتَاحَةُ', 'Available Appointments');
  static String get manageSchedule => _t('إِدَارَةُ الجَدْوَلِ', 'Manage Schedule');
  static String get noAvailableSlots => _t('لا تُوجَدُ مَوَاعِيدُ مُتَاحَةٌ حَالِيّاً', 'No available slots at the moment');
  static String get reviews => _t('التَّقْيِيمَاتُ', 'Reviews');
  static String get viewAll => _t('عَرْضُ الكُلِّ', 'View All');
  static String get rating => _t('تَقْيِيم', 'Rating');
  static String get today => _t('اليَوْمَ', 'Today');
  static String get yesterday => _t('أَمْسَ', 'Yesterday');
  static String get daysAgo => _t('أَيَّامٍ', 'days ago');
  static String get weeksAgo => _t('أَسَابِيعَ', 'weeks ago');
  static String get monthAgo => _t('شَهْرٍ', 'month ago');
  static String get since => _t('مُنْذُ', 'since');

  // Settings
  static String get account => _t('الحِسَابُ', 'Account');
  static String get manageProfile => _t('إِدَارَةُ المِلَفِّ الشَّخْصِيِّ', 'Manage Profile');
  static String get changePassword => _t('تَغْيِيرُ كَلِمَةِ السِّرِّ', 'Change Password');
  static String get updatePassword => _t('تَحْدِيثُ كَلِمَةِ السِّرِّ', 'Update Password');
  static String get notifications => _t('الإِشْعَارَاتُ', 'Notifications');
  static String get manageNotifications => _t('إِدَارَةُ إِعْدَادَاتِ الإِشْعَارَاتِ', 'Manage Notification Settings');
  static String get preferences => _t('التَّفْضِيلَاتُ', 'Preferences');
  static String get language => _t('اللُّغَةُ', 'Language');
  static String get arabic => _t('العَرَبِيَّةُ', 'Arabic');
  static String get english => _t('English', 'English');
  static String get backup => _t('نَسْخٌ احْتِيَاطِيٌّ', 'Backup');
  static String get backupDescription => _t('نَسْخٌ احْتِيَاطِيٌّ لِبَيَانَاتِ العِيَادَةِ', 'Backup clinic data');
  static String get about => _t('حَوْلَ', 'About');
  static String get version => _t('الإِصْدَارُ', 'Version');
  static String get versionNumber => _t('١.٠.٠', '1.0.0');
  static String get helpSupport => _t('المُسَاعَدَةُ وَالدَّعْمُ', 'Help & Support');
  static String get getHelp => _t('الحُصُولُ عَلَى المُسَاعَدَةِ', 'Get Help');
  static String get privacyPolicy => _t('سِيَاسَةُ الخُصُوصِيَّةِ', 'Privacy Policy');
  static String get viewPrivacyPolicy => _t('عَرْضُ سِيَاسَةِ الخُصُوصِيَّةِ', 'View Privacy Policy');

  // Auth / Login
  static String get loginAsRole => _t('تَسْجِيلُ الدُّخُولِ بِصِفَةِ', 'Login as');
  static String get enterEmail => _t('الرَّجَاء إِدْخَال البَرِيد الإِلِكْتُرُونِيّ', 'Please enter email');
  static String get enterPassword => _t('الرَّجَاء إِدْخَال كَلِمَة المُرُور', 'Please enter password');
  static String get apiNotAvailable => _t('مُصَادِقُ API غَيْرُ مُتَاحٍ', 'API Auth not available');

  // Onboarding
  static String get back => _t('عَوْدَةٌ', 'Back');
  static String get skip => _t('تَخُطِّ', 'Skip');
  static String get enterApp => _t('الدُّخُولِ إِلَى التَّطْبِيقِ', 'Enter App');
  static String get next => _t('تَابِع', 'Next');
  static String get systemName => _t('عِيَادَتِي', 'My Clinic');
  static String get systemTitle => _t('نِظَامُ إِدَارَةِ العِيَادَاتِ الطِّبِّيَّةِ', 'Clinic Management System');
  static String get systemNameShort => _t('نِظَامُ إِدَارَةِ العِيَادَةِ', 'Clinic Management System');

  // Registration
  static String get registerDoctor => _t('تَسْجِيلُ طَبِيبٍ جَدِيدٍ', 'Register New Doctor');
  static String get registerPatientTitle => _t('تَسْجِيلُ مَرِيضٍ جَدِيدٍ', 'Register New Patient');
  static String get firstName => _t('الاسْمُ الأَوَّلُ', 'First Name');
  static String get lastName => _t('اسْمُ العَائِلَةِ', 'Last Name');
  static String get username => _t('اسْمُ المُسْتَخْدِمِ', 'Username');
  static String get phoneOptional => _t('رَقْمُ الهَاتِفِ (اخْتِيَارِي)', 'Phone (Optional)');
  static String get addressOptional => _t('العُنْوَانُ (اخْتِيَارِي)', 'Address (Optional)');
  static String get dateOfBirthOptional => _t('تَارِيخُ المِيلَادِ (اخْتِيَارِي)', 'Date of Birth (Optional)');
  static String get gender => _t('الجِنْسُ', 'Gender');
  static String get male => _t('ذَكَر', 'Male');
  static String get female => _t('أُنْثَى', 'Female');
  static String get experienceMonths => _t('عَدَدُ شُهُورِ الخِبْرَةِ', 'Experience (months)');
  static String get confirmPassword => _t('تَأْكِيدُ كَلِمَةِ السِّرِّ', 'Confirm Password');
  static String get register => _t('تَسْجِيلُ', 'Register');
  static String get passwordsNotMatch => _t('كَلِمَتَا السِّرِّ غَيْرُ مُتَطَابِقَتَيْنِ', 'Passwords do not match');
  static String get passwordChanged => _t('تَمَّ تَغْيِيرُ كَلِمَةِ السِّرِّ بِنَجَاحٍ', 'Password changed successfully');
  static String get currentPassword => _t('كَلِمَةُ السِّرِّ الحَالِيَّةُ', 'Current Password');
  static String get newPassword => _t('كَلِمَةُ السِّرِّ الجَدِيدَةُ', 'New Password');
  static String get confirmNewPassword => _t('تَأْكِيدُ كَلِمَةِ السِّرِّ الجَدِيدَةِ', 'Confirm New Password');
  static String get required => _t('مَطْلُوبٌ', 'Required');
  static String get min8Chars => _t('8 أَحْرُفٍ عَلَى الأَقَلِّ', 'At least 8 characters');
  static String get between0and1200 => _t('بَيْنَ 0 و 1200', 'Between 0 and 1200');

  // Profile
  static String get editLabel => _t('تَعْدِيلُ ', 'Edit ');
  static String get profileTitle => _t('المَلَفُّ الشَّخْصِيُّ', 'Personal Profile');
  static String get failedToLoadProfile => _t('تَعَذَّرَ تَحْمِيلُ المَلَفِّ', 'Failed to load profile');
  static String get retry => _t('إِعَادَةُ المُحَاوَلَةِ', 'Retry');
  static String get deleteAccount => _t('حَذْفُ الحِسَابِ', 'Delete Account');
  static String get deleteAccountConfirm => _t('هَلْ أَنْتَ مُتَأَكِّدٌ مِنْ حَذْفِ حِسَابِكَ؟ هَذَا الإِجْرَاءُ نِهَائِيٌّ وَلا يُمْكِنُ التَّرَاجُعُ عَنْهُ.', 'Are you sure you want to delete your account? This action is irreversible.');
  static String get confirmDeletion => _t('تَأْكِيدُ الحَذْفِ', 'Confirm Deletion');
  static String get deleteAccountTitle => _t('حَذْفُ الحِسَابِ', 'Delete Account');
  static String get enterPasswordToDelete => _t('يَجِبُ إِدْخَالُ كَلِمَةِ السِّرِّ لِتَأْكِيدِ الحَذْفِ', 'Enter password to confirm deletion');
  static String get warningPermanent => _t('تَحْذِيرٌ: هَذَا الإِجْرَاءُ نِهَائِيٌّ', 'Warning: This action is permanent');
  static String get deleteAllDataWarning => _t('سَيَتُمُ حَذْفُ جَمِيعِ بَيَانَاتِكَ بِمَا فِي ذَلِكَ المَوَاعِيدُ وَالسِّجِلَّاتُ الطِّبِّيَّةُ. لا يُمْكِنُ التَّرَاجُعُ عَنْ هَذَا القَرَارِ.', 'All your data including appointments and medical records will be deleted. This cannot be undone.');
  static String get enterPasswordConfirm => _t('أَدْخِلْ كَلِمَةَ السِّرِّ لِلتَّأْكِيدِ', 'Enter password to confirm');

  // Medical Records
  static String get noRecords => _t('لا تُوجَدُ سِجِلَّاتٌ', 'No Records');
  static String get diagnosis => _t('التَّشْخِيصُ', 'Diagnosis');
  static String get prescription => _t('الوَصْفَةُ', 'Prescription');
  static String get notesLabel => _t('مُلَاحَظَاتٌ', 'Notes');
  static String get doctorLabel => _t('الطَّبِيبُ', 'Doctor');

  // Patients views
  static String get patientDeleted => _t('تَمَّ حَذْفُ المَرِيضِ بِنَجَاحٍ', 'Patient deleted successfully');

  // Role Selection screen
  static String get adminSubtitle => _t('إِدَارَةُ العِيَادَةِ، الأَطِبَّاءِ، المَوَاعِيدِ وَالتَّقَارِيرِ', 'Manage clinic, doctors, appointments & reports');
  static String get doctorSubtitle => _t('إِدَارَةُ المَوَاعِيدِ، السِّجِلَّاتِ الطِّبِّيَّةِ وَالمَرْضَى', 'Manage appointments, records & patients');
  static String get receptionistSubtitle => _t('تَسْجِيلُ المَرْضَى، جَدْوَلَةُ المَوَاعِيدِ، وَمُتَابَعَةُ الكَشْفِ', 'Register patients, schedule appointments & check-in');
  static String get patientSubtitle => _t('مُتَابَعَةُ المَوَاعِيدِ وَالسِّجِلَّاتِ الطِّبِّيَّةِ الشَّخْصِيَّةِ', 'Track appointments & personal medical records');
  static String get medicalRecordsTitle => _t('السِّجِلَّاتُ الطِّبِّيَّةُ', 'Medical Records');

  // Confirm exit dialog
  static String get confirmExit => _t('تَأْكِيدُ الخُرُوجِ', 'Confirm Exit');
  static String get confirmExitMessage => _t('هَلْ تُرِيدُ الخُرُوجَ مِنَ التَّطْبِيقِ؟', 'Do you want to exit the app?');
  static String get exit => _t('خُرُوجُ', 'Exit');

  // Specialization picker
  static String get chooseSpecialty => _t('اخْتَرِ التَّخَصُّصَ', 'Choose Specialty');

  // Country / City picker
  static String get chooseCountry => _t('اخْتَرِ الدَّوْلَةَ', 'Choose Country');
  static String get chooseCity => _t('اخْتَرِ الْمَدِينَةَ', 'Choose City');
  static String get countryCity => _t('الدَّوْلَةُ / الْمَدِينَةُ', 'Country / City');
  static String get chooseCountryCity => _t('اخْتَرِ الدَّوْلَةَ وَالْمَدِينَةَ', 'Choose Country and City');
  static String get loading => _t('جَارِي التَّحْمِيلُ...', 'Loading...');

  // Phone field
  static String get countriesSyria => _t('سوريا', 'Syria');
  static String get countriesEgypt => _t('مصر', 'Egypt');
  static String get countriesSaudi => _t('السعودية', 'Saudi Arabia');
  static String get countriesUAE => _t('الإمارات', 'UAE');
  static String get countriesQatar => _t('قطر', 'Qatar');
  static String get countriesKuwait => _t('الكويت', 'Kuwait');
  static String get countriesOman => _t('عُمان', 'Oman');
  static String get countriesBahrain => _t('البحرين', 'Bahrain');
  static String get countriesJordan => _t('الأردن', 'Jordan');
  static String get countriesIraq => _t('العراق', 'Iraq');
  static String get countriesLebanon => _t('لبنان', 'Lebanon');
  static String get countriesYemen => _t('اليمن', 'Yemen');
  static String get countriesPalestine => _t('فلسطين', 'Palestine');
  static String get countriesLibya => _t('ليبيا', 'Libya');
  static String get countriesTunisia => _t('تونس', 'Tunisia');
  static String get countriesAlgeria => _t('الجزائر', 'Algeria');
  static String get countriesMorocco => _t('المغرب', 'Morocco');
  static String get countriesSudan => _t('السودان', 'Sudan');
  static String get countriesUSA => _t('الولايات المتحدة', 'United States');
  static String get countriesUK => _t('المملكة المتحدة', 'United Kingdom');
  static String get countriesFrance => _t('فرنسا', 'France');
  static String get countriesGermany => _t('ألمانيا', 'Germany');

  // Specializations
  static String get specCardiology => _t('أمراض القلب', 'Cardiology');
  static String get specDermatology => _t('الأمراض الجلدية', 'Dermatology');
  static String get specNeurology => _t('الأمراض العصبية', 'Neurology');
  static String get specPediatrics => _t('طب الأطفال', 'Pediatrics');
  static String get specOrthopedics => _t('جراحة العظام', 'Orthopedics');
  static String get specOphthalmology => _t('طب العيون', 'Ophthalmology');
  static String get specENT => _t('الأذن والأنف والحنجرة', 'ENT');
  static String get specPsychiatry => _t('الطب النفسي', 'Psychiatry');
  static String get specRadiology => _t('الأشعة', 'Radiology');
  static String get specGeneralSurgery => _t('الجراحة العامة', 'General Surgery');
  static String get specInternalMedicine => _t('الباطنة', 'Internal Medicine');
  static String get specObGyn => _t('النساء والتوليد', 'Obstetrics & Gynecology');
  static String get specEmergency => _t('طب الطوارئ', 'Emergency Medicine');
  static String get specAnesthesia => _t('التخدير', 'Anesthesiology');
  static String get specPathology => _t('علم الأمراض', 'Pathology');
  static String get specUrology => _t('المسالك البولية', 'Urology');
  static String get specGastroenterology => _t('الجهاز الهضمي', 'Gastroenterology');
  static String get specEndocrinology => _t('الغدد الصماء', 'Endocrinology');
  static String get specPulmonology => _t('أمراض الصدر', 'Pulmonology');
  static String get specRheumatology => _t('الروماتيزم', 'Rheumatology');
  static String get specNephrology => _t('أمراض الكلى', 'Nephrology');
  static String get specHematology => _t('أمراض الدم', 'Hematology');
  static String get specOncology => _t('الأورام', 'Oncology');
  static String get specInfectious => _t('الأمراض المعدية', 'Infectious Diseases');
  static String get specGenetics => _t('علم الوراثة', 'Medical Genetics');
  static String get specImmunology => _t('علم المناعة', 'Immunology');
  static String get specSportsMedicine => _t('الطب الرياضي', 'Sports Medicine');

  // Dashboard greeting
  static String get greeting => _t('مَرْحَباً،', 'Hello,');

  // Splash
  static String get splashTitle => _t('عِيَادَتِي', 'My Clinic');

  // Time format helpers
  static String get am => _t('ص', 'AM');
  static String get pm => _t('م', 'PM');
  static String get morningFull => _t('صباحاً', 'morning');
  static String get eveningFull => _t('مساءً', 'evening');

  // Day names
  static String get dayMonday => _t('الاثنين', 'Monday');
  static String get dayTuesday => _t('الثلاثاء', 'Tuesday');
  static String get dayWednesday => _t('الأربعاء', 'Wednesday');
  static String get dayThursday => _t('الخميس', 'Thursday');
  static String get dayFriday => _t('الجمعة', 'Friday');
  static String get daySaturday => _t('السبت', 'Saturday');
  static String get daySunday => _t('الأحد', 'Sunday');

  // Month names
  static String get monthJan => _t('يناير', 'January');
  static String get monthFeb => _t('فبراير', 'February');
  static String get monthMar => _t('مارس', 'March');
  static String get monthApr => _t('إبريل', 'April');
  static String get monthMay => _t('مايو', 'May');
  static String get monthJun => _t('يونيو', 'June');
  static String get monthJul => _t('يوليو', 'July');
  static String get monthAug => _t('أغسطس', 'August');
  static String get monthSep => _t('سبتمبر', 'September');
  static String get monthOct => _t('أكتوبر', 'October');
  static String get monthNov => _t('نوفمبر', 'November');
  static String get monthDec => _t('ديسمبر', 'December');

  // Onboarding content
  static String get onboardingWelcomeTitle => _t('مَرْحَباً بِكَ فِي نِظَامِ الإِدَارَةِ الطِّبِّيَّةِ', 'Welcome to the Medical Management System');
  static String get onboardingWelcomeSubtitle => _t('نُسَاعِدُكَ عَلَى إِدَارَةِ عِيَادَتِكَ بِكُلِّ يُسْرٍ وَاحْتِرَافِيَّةٍ، مِنْ جَدْوَلَةِ المَوَاعِيدِ إِلَى مُتَابَعَةِ المَرْضَى بِكَفَاءَةٍ لا نَظِيرَ لَهَا.', 'We help you manage your clinic with ease and professionalism, from scheduling appointments to following up with patients with unparalleled efficiency.');
  static String get onboardingScheduleTitle => _t('تَحَكَّمْ بِجَدْوَلِ الأَطِبَّاءِ وَالمَوَاعِيدِ', 'Manage Doctor Schedules & Appointments');
  static String get onboardingScheduleSubtitle => _t('أَضِفْ فَرِيقَكَ الطِّبِّيَّ بِسُهُولَةٍ، وَأَدِرْ مَوَاعِيدَهُمْ بِمُرُونَةٍ تَامَّةٍ، مَعَ إِشْعَارَاتٍ ذَكِيَّةٍ لِلتَّذْكِيرِ وَتَنَبُّهَاتٍ فَوْرِيَّةٍ لِلمَرْضَى.', 'Add your medical team easily, manage their schedules with full flexibility, with smart reminders and instant notifications for patients.');
  static String get onboardingDashboardTitle => _t('لَوْحَةُ تَحَكُّمٍ شَامِلَةٌ لِنَجَاحِ عِيَادَتِكَ', 'Comprehensive Dashboard for Your Clinic Success');
  static String get onboardingDashboardSubtitle => _t('تَتَبَّعْ إِحْصَائِيَّاتِ العِيَادَةِ وَالإِيرَادَاتِ وَرِضَا المَرْضَى فِي لَوْحَةٍ وَاحِدَةٍ مُبَسَّطَةٍ، وَاتَّخِذْ قَرَارَاتِكَ بِثِقَةٍ وَاقْتِدَارٍ.', 'Track clinic statistics, revenues, and patient satisfaction on one simple dashboard, and make decisions with confidence.');
  static String get onboardingDoctorWelcomeTitle => _t('مَرْحَباً بِكَ دُكْتُورَنَا الفَاضِلُ', 'Welcome, Doctor');
  static String get onboardingDoctorWelcomeSubtitle => _t('نُقَدِّمُ لَكَ أَدَاةً مُتَطَوِّرَةً تُسَاعِدُكَ فِي رِعَايَةِ مَرْضَاكَ بِكَفَاءَةٍ وَدِقَّةٍ، وَتُوَفِّرُ لَكَ وَقْتَكَ وَجُهْدَكَ لِلتَّرْكِيزِ عَلَى مَا يَهُمُّ حَقّاً.', 'We provide you with an advanced tool to care for your patients efficiently and accurately, saving your time and effort to focus on what really matters.');
  static String get onboardingDoctorScheduleTitle => _t('جَدْوَلُ مَوَاعِيدِكَ بِبَسَاطَةٍ وَذَكَاءٍ', 'Your Schedule Simply & Smartly');
  static String get onboardingDoctorScheduleSubtitle => _t('اطَّلِعْ عَلَى مَوَاعِيدِكَ اليَوْمِيَّةَ فِي نَظْرَةٍ، أَدِرْهَا بِسُهُولَةٍ، وَاسْتَعْرِضْ سِجِلَّاتِ مَرْضَاكَ الطِّبِّيَّةَ فِي لَحَظَاتٍ.', 'View your daily appointments at a glance, manage them easily, and review your patient records in moments.');
  static String get onboardingDoctorCommunicationTitle => _t('تَوَاصَلْ مَعَ مَرْضَاكَ بِاحْتِرَافِيَّةٍ', 'Communicate with Your Patients Professionally');
  static String get onboardingDoctorCommunicationSubtitle => _t('سَجِّلْ المُلَاحَظَاتِ الطِّبِّيَّةَ، تَابَعْ سِجِلَّاتِهِمُ السَّابِقَةَ، وَارْفَعْ تَقَارِيرَ العِلَاجِ وَالوَصَفَاتِ الطِّبِّيَّةَ بِكُلِّ يُسْرٍ.', 'Record medical notes, review their history, and upload treatment reports and prescriptions with ease.');
  static String get onboardingReceptionistTitle => _t('مَرْحَباً بِكَ مَسْؤُولَ الاسْتِقْبَالِ', 'Welcome, Receptionist');
  static String get onboardingReceptionistSubtitle => _t('نُسَاعِدُكَ عَلَى إِدَارَةِ مَوَاعِيدِ المَرْضَى وَتَسْجِيلِهِمْ بِسُهُولَةٍ وَاحْتِرَافِيَّةٍ.', 'We help you manage patient appointments and registrations with ease and professionalism.');
  static String get onboardingReceptionistApptsTitle => _t('إِدَارَةُ المَوَاعِيدِ وَالمَرْضَى', 'Appointments & Patients Management');
  static String get onboardingReceptionistApptsSubtitle => _t('أَضِفْ المَرْضَى الجُدُدَ، وَجَدْوِلْ مَوَاعِيدَهُمْ مَعَ الأَطِبَّاءِ بِسُرْعَةٍ وَدِقَّةٍ.', 'Add new patients and schedule appointments with doctors quickly and accurately.');
  static String get onboardingReceptionistCoordTitle => _t('التَّوَاصُلُ وَالتَّنْسِيقُ', 'Communication & Coordination');
  static String get onboardingReceptionistCoordSubtitle => _t('تَابِعْ بَيَانَاتِ المَرْضَى، وَقُمْ بِالتَّنْسِيقِ مَعَ الأَطِبَّاءِ لِضَمَانِ سَيْرِ العَمَلِ بِانْسِيَابِيَّةٍ تَامَّةٍ.', 'Track patient data and coordinate with doctors to ensure smooth workflow.');
  static String get onboardingPatientTitle => _t('أَهْلاً بِكَ فِي بَوَّابَةِ المَرْضَى', 'Welcome to the Patient Portal');
  static String get onboardingPatientSubtitle => _t('تَطْبِيقُنَا يُسَاعِدُكَ عَلَى مُتَابَعَةِ مَوَاعِيدِكَ الطِّبِّيَّةِ وَسِجِلَّاتِكَ الصِّحِّيَّةِ بِكُلِّ يُسْرٍ.', 'Our app helps you track your medical appointments and health records with ease.');
  static String get onboardingPatientApptsTitle => _t('مَوَاعِيدُكَ فِي نَظْرَةٍ', 'Your Appointments at a Glance');
  static String get onboardingPatientApptsSubtitle => _t('اسْتَعْرِضْ مَوَاعِيدَكَ القَادِمَةَ وَالسَّابِقَةَ، وَاسْتَقْبِلْ تَذْكِيرَاتٍ فَوْرِيَّةً لِمَوَاعِيدِكَ.', 'View upcoming and past appointments, receive instant reminders.');
  static String get onboardingPatientRecordsTitle => _t('سِجِلَّاتُكَ الطِّبِّيَّةُ', 'Your Medical Records');
  static String get onboardingPatientRecordsSubtitle => _t('اطَّلِعْ عَلَى سِجِلَّاتِكَ الطِّبِّيَّةَ السَّابِقَةَ، التَّشْخِيصَاتِ، وَالوَصَفَاتِ فِي أَيِّ وَقْتٍ وَمِنْ أَيِّ مَكَانٍ.', 'View your past medical records, diagnoses, and prescriptions anytime, anywhere.');

  // Patient post-registration welcome
  static String get pwWelcomeTitle => _t('مَرْحَباً بِكَ فِي مُسْتَقْبَلِ الرِّعَايَةِ الصِّحِّيَّةِ', 'Welcome to the Future of Healthcare');
  static String get pwWelcomeSubtitle => _t('اِكْتَشِفِ القُوَّةَ الكَامِنَةَ فِي بَيَانَاتِكَ الحَيَوِيَّةِ مَعَ تَحْلِيلَاتِ الذَّكَاءِ الاِصْطِنَاعِيِّ المُتَقَدِّمَةِ.', 'Discover the power of your health data with advanced AI analysis.');
  static String get pwApptsTitle => _t('مَوَاعِيدُكَ فِي لَمْحَةٍ', 'Your Appointments at a Glance');
  static String get pwApptsSubtitle => _t('اِسْتَعْرِضْ مَوَاعِيدَكَ القَادِمَةَ وَاسْتَقْبِلْ تَذْكِيرَاتٍ فَوْرِيَّةً لِمَوَاعِيدِكَ الطِّبِّيَّةِ.', 'View upcoming appointments and receive instant reminders.');
  static String get pwRecordsTitle => _t('سِجْلُكَ الطِّبِّيُّ بِتَقْنِيَّةِ AI', 'Your Medical Record with AI');
  static String get pwRecordsSubtitle => _t('اطَّلِعْ عَلَى سِجِلَّاتِكَ الطِّبِّيَّةِ وَالتَّشْخِيصَاتِ وَالوَصَفَاتِ مَعَ تَحْلِيلَاتٍ ذَكِيَّةٍ.', 'View your medical records, diagnoses, and prescriptions with smart analysis.');
  static String get pwStartNow => _t('ابْدَأْ الآنَ', 'Start Now');
  static String get pwSkip => _t('تَخَطِّي', 'Skip');
  static String get pwChipBpm => _t('82 BPM', '82 BPM');
  static String get pwChipAiScan => _t('AI Scan Active', 'AI Scan Active');
  static String get pwChipReminder => _t('تَذْكِيرٌ ذَكِيٌّ', 'Smart Reminder');
  static String get pwChipAnalysis => _t('تَحْلِيلُ AI', 'AI Analysis');

  // Onboarding role selection services
  static String get roleSelectionSystemName => _t('نِظَامُ إِدَارَةِ العِيَادَةِ', 'Clinic Management System');

  // Rating Screen
  static String get appRatings => _t('تقييمات التطبيق', 'App Ratings');
  static String get ratingsTitle => _t('التقييمات', 'Ratings');
  static String get noReviews => _t('لا توجد مراجعات', 'No reviews');
  static String get noMoreReviews => _t('لا توجد مراجعات إضافية', 'No more reviews');
  static String get loadMoreReviews => _t('تحميل المزيد من المراجعات', 'Load more reviews');
  static String get reviewReported => _t('تم الإبلاغ عن هذه المراجعة', 'This review has been reported');
  static String get reviewPrompt => _t('رأيك يساعدنا في تحسين خدماتنا الصحية', 'Your feedback helps us improve our healthcare services');
  static String get basedOnReviews => _t('بناءً على', 'Based on');
  static String get reviewsFromPatients => _t('مراجعة من المرضى', 'reviews from patients');
  static String get filterNewest => _t('الأحدث', 'Newest');
  static String get filterHighest => _t('الأعلى تقييماً', 'Highest Rated');
  static String get filterWithPhotos => _t('مع صور', 'With Photos');
  static String get filterLowest => _t('الأقل تقييماً', 'Lowest Rated');
  static String get timeAgoTwoDays => _t('قبل يومين', '2 days ago');
  static String get timeAgoYesterday => _t('أمس', 'Yesterday');
  static String get timeAgoSince => _t('منذ', 'since');
  static String get timeAgoDays => _t('أيام', 'days');
  static String get timeAgoWeeks => _t('أسابيع', 'weeks');
  static String get timeAgoMonth => _t('شهر', 'month');
  static String get timeAgoYear => _t('سنة', 'year');

  // Receptionist Home
  static String get rhSystemStatus => _t('حالة النظام: نشط', 'System Status: Active');
  static String get rhReceptionDesk => _t('منصة الاستقبال 01', 'Reception Desk 01');
  static String get rhScheduleOverview => _t('نظرة عامة على المواعيد', 'Schedule Overview');
  static String get rhViewFull => _t('عرض الكل', 'View Full');
  static String get rhClinicPulse => _t('مؤشرات العيادة', 'Clinic Pulse');
  static String get rhTotalAppts => _t('إجمالي المواعيد', 'Total Appointments');
  static String get rhCheckedIn => _t('تم تسجيل الدخول', 'Checked In');
  static String get rhQueueInProgress => _t('قيد الكشف', 'In Progress');
  static String get rhQueuePending => _t('معلق', 'Pending');
  static String get rhNewAppointment => _t('موعد جديد', 'New Appointment');
  static String get rhBookSlot => _t('حجز موعد لمريض', 'Book Slot');
  static String get rhRegisterPatient => _t('تسجيل مريض', 'Register Patient');
  static String get rhActiveQueue => _t('قائمة الانتظار', 'Active Queue');
  static String get rhWithDoctor => _t('عند الطبيب', 'With Doctor');
  static String get rhWaiting => _t('بانتظار الكشف', 'Waiting');
  static String get rhCheckingIn => _t('يتم تسجيل الدخول', 'Checking In');
  static String get rhScanMedicalId => _t('مسح رمز المريض', 'Scan Patient ID');
  static String get rhWithDoctorSub => _t('د. ', 'Dr. ');
  static String get rhGreetingMorning => _t('صباح الخير', 'Good Morning');
  static String get rhGreetingEvening => _t('مساء الخير', 'Good Evening');
  static String get rhClinicName => _t('الجناح الطبي المركزي', 'Central Medical Wing');
  static String get rhNoApptsToday => _t('لا توجد مواعيد اليوم', 'No appointments today');
  static String get rhScannerActivating => _t('جاري تفعيل الماسح الضوئي...', 'Activating scanner...');

  // Doctor Appointments
  static String get daTotalApptsToday => _t('إجمالي المواعيد اليوم', "Today's Total Appointments");
  static String get daPatientsWaiting => _t('المرضى في الانتظار', 'Patients Waiting');
  static String get daAvailableDoctors => _t('الأطباء المتاحون', 'Available Doctors');
  static String get daFromYesterday => _t('من الأمس', 'From Yesterday');
  static String get daEmergencyCases => _t('حالات طارئة', 'Emergency Cases');
  static String get daOutOf => _t('من أصل', 'Out of');
  static String get daQuickActions => _t('إجراءات سريعة', 'Quick Actions');
  static String get daRegisterPatient => _t('تسجيل مريض', 'Register Patient');
  static String get daAddAppointment => _t('إضافة موعد', 'Add Appointment');
  static String get daManageSchedule => _t('إدارة الجدول', 'Manage Schedule');
  static String get daLiveQueue => _t('قائمة الانتظار المباشرة', 'Live Queue');
  static String get daViewAll => _t('عرض الكل', 'View All');
  static String get daCheckInTime => _t('وقت تسجيل الدخول', 'Check-in Time');
  static String get daNoApptsToday => _t('لا توجد مواعيد اليوم', 'No appointments today');
  static String get daWithDoctor => _t('د. ', 'Dr. ');

  // Services Screen
  static String get srSearchHint => _t('ابحث عن طبيب أو خدمة...', 'Search for a doctor or service...');
  static String get srCategories => _t('التصنيفات', 'Categories');
  static String get srViewAll => _t('عرض الكل', 'View All');
  static String get srCardiology => _t('أمراض القلب', 'Cardiology');
  static String get srDental => _t('طب الأسنان', 'Dentistry');
  static String get srPediatrics => _t('طب الأطفال', 'Pediatrics');
  static String get srOrthopedics => _t('طب العظام', 'Orthopedics');
  static String get srOphthalmology => _t('طب العيون', 'Ophthalmology');
  static String get srNeurology => _t('طب الأعصاب', 'Neurology');
  static String get srBannerTitle => _t('فحص شامل مجاني', 'Free Comprehensive Checkup');
  static String get srBannerSubtitle => _t('احصل على استشارة أولية مجانية لأعضاء حيوية المختارة.', 'Get a free initial consultation for selected vital members.');
  static String get srBottomHome => _t('الرئيسية', 'Home');
  static String get srMedicalServices => _t('الخدمات الطبية', 'Medical Services');
  static String get srBottomServices => _t('الخدمات', 'Services');
  static String get srBottomRecords => _t('السجلات', 'Records');
  static String get srBottomAccount => _t('حسابي', 'Account');

  // Doctor Patients
  static String get dpMyPatients => _t('مرضاي', 'My Patients');
  static String get dpPatient => _t('مريض', 'Patient');
  static String get dpSearchPatients => _t('ابحث عن مريض...', 'Search for patient...');
  static String get dpFilterAll => _t('الكل', 'All');
  static String get dpFilterNew => _t('جديد', 'New');
  static String get dpFilterMale => _t('ذكور', 'Male');
  static String get dpFilterFemale => _t('إناث', 'Female');
  static String get dpYear => _t('سنة', 'year');
  static String get dpNoPatients => _t('لا يوجد مرضى', 'No patients');
  static String get dpNoPatientsHint => _t('سيظهر هنا مرضاك المسجلون تحت عنايتك.', 'Your registered patients will appear here.');
  static String dpUnderCareOf(String name) => _t('تحت عناية $name', 'Under care of $name');

  // Weak Connection Screen
  static String get wcTitle => _t('الاتصال ضعيف حالياً', 'Connection is currently weak');
  static String get wcMessage => _t('يبدو أن سرعة الإنترنت منخفضة، قد تستغرق العملية وقتاً أطول من المعتاد.', 'The internet speed seems low. The process may take longer than usual.');
  static String get wcWaiting => _t('يرجى الانتظار...', 'Please wait...');
  static String get wcRetry => _t('إعادة المحاولة', 'Retry');
  static String get wcSignalStrength => _t('قوة الإشارة: ضعيفة', 'Signal Strength: Weak');

  // Offline Screen
  static String get olTitle => _t('عذراً، لا يوجد اتصال بالإنترنت', 'Sorry, no internet connection');
  static String get olMessage => _t('يبدو أنك غير متصل بالشبكة حالياً. يرجى التحقق من إعدادات الواي فاي أو بيانات الهاتف والمحاولة مرة أخرى.', 'You seem to be offline. Please check your Wi-Fi or mobile data and try again.');
  static String get olRetry => _t('إعادة المحاولة', 'Retry');
  static String get olShowCached => _t('عرض البيانات المحملة مسبقاً', 'Show cached data');
  static String get olSignalLost => _t('Signal Lost', 'Signal Lost');
  static String get olServerUnreachable => _t('Server unreachable', 'Server Unreachable');

  // Rate Limit Screen
  static String get rlTitle => _t('تم تجاوز حد الطلبات', 'Rate Limit Exceeded');
  static String get rlMessage => _t('لقد قمت بإرسال عدد كبير من الطلبات في وقت قصير جداً. لضمان أمان النظام واستقرار بياناتك الطبية، نرجو الانتظار قليلاً قبل المحاولة مجدداً.', 'You have sent too many requests in a short time. Please wait a moment before trying again.');
  static String get rlRetry => _t('إعادة المحاولة', 'Retry');
  static String get rlGoHome => _t('العودة للرئيسية', 'Go Home');
  static String get rlTooManyRequests => _t('429 Too Many Requests', '429 Too Many Requests');
  static String get rlRateLimited => _t('Rate Limited', 'Rate Limited');
  static String get rlWaitPrefix => _t('يرجى الانتظار', 'Please wait');
  static String get rlWaitingTimer => _t('مؤقت الانتظار', 'Waiting Timer');
  static String get rlReadyNow => _t('جاهز الآن', 'Ready Now');
  static String get rlContactSupport => _t('اتصل بالدعم الفني', 'Contact Support');
  static String get rlSecond => _t('ثانية', 'second');

  // Download Files
  static String get dfTitle => _t('الملفات القابلة للتحميل', 'Downloadable Files');
  static String get dfSearchHint => _t('ابحث عن ملف...', 'Search for file...');
  static String get dfCategoryAll => _t('الكل', 'All');
  static String get dfCategoryReports => _t('تقارير', 'Reports');
  static String get dfCategoryLab => _t('تحاليل', 'Lab Results');
  static String get dfCategoryImaging => _t('أشعة', 'Imaging');
  static String get dfCategoryBilling => _t('فواتير', 'Billing');
  static String get dfDownload => _t('تحميل', 'Download');
  static String get dfDownloaded => _t('تم التحميل', 'Downloaded');
  static String get dfMb => _t('ميغابايت', 'MB');
  static String get dfNoFiles => _t('لا توجد ملفات', 'No files');
  static String get dfNoFilesHint => _t('سيظهر هنا الملفات الطبية المتاحة للتحميل.', 'Available medical files will appear here.');

  // Server Error
  static String get seTitle => _t('خطأ في الخادم', 'Server Error');
  static String get seMessage => _t('تعذر الاتصال بالخادم. يرجى المحاولة لاحقاً.', 'Could not connect to server. Please try again later.');
  static String get seRetry => _t('إعادة المحاولة', 'Retry');
  static String get seGoHome => _t('العودة للرئيسية', 'Go Home');
  static String get seServerBusy => _t('الخادم مشغول', 'Server Busy');
  static String get seTryAgain => _t('يرجى المحاولة لاحقاً', 'Please try again later');

  // Notifications Screen
  static String get ntTitle => _t('الإشعارات', 'Notifications');
  static String get ntMarkAllRead => _t('تحديد الكل كمقروء', 'Mark All Read');
  static String get ntCategoryAll => _t('الكل', 'All');
  static String get ntCategoryUnread => _t('جديدة', 'Unread');
  static String get ntCategoryMedical => _t('طبية', 'Medical');
  static String get ntCategoryAppointment => _t('مواعيد', 'Appointments');
  static String get ntCategorySystem => _t('نظام', 'System');
  static String get ntEmptyTitle => _t('لا توجد إشعارات', 'No notifications');
  static String get ntEmptyHint => _t('سيظهر هنا كل الإشعارات الجديدة والقديمة.', 'All new and old notifications will appear here.');
  static String get ntJustNow => _t('الآن', 'Just now');
  static String get ntMinutesAgo => _t('منذ دقائق', 'minutes ago');
  static String get ntHourAgo => _t('منذ ساعة', 'hour ago');
  static String get ntHoursAgo => _t('منذ ساعتين', 'hours ago');
  static String get ntHoursAgoPlural => _t('منذ ساعات', 'hours ago');
  static String get ntDaysAgo => _t('منذ أيام', 'days ago');

  // Search Doctors Screen
  static String get sdTitle => _t('البحث عن رعاية', 'Search for Care');
  static String get sdSearchHint => _t('ابحث عن طبيب أو تخصص...', 'Search for a doctor or specialty...');
  static String get sdResultsCount => _t('تم العثور على', 'Found');
  static String get sdDoctor => _t('طبيب', 'Doctor');
  static String get sdFilterAll => _t('الكل', 'All');
  static String get sdFilterCardiology => _t('القلب', 'Cardiology');
  static String get sdFilterNeurology => _t('الأعصاب', 'Neurology');
  static String get sdFilterDental => _t('الأسنان', 'Dental');
  static String get sdBookAppointment => _t('احجز موعداً', 'Book Appointment');
  static String get sdChat => _t('chat', 'Chat');
  static String get sdBottomHome => _t('الرئيسية', 'Home');
  static String get sdBottomSearch => _t('بحث', 'Search');
  static String get sdBottomAppointments => _t('المواعيد', 'Appointments');
  static String get sdBottomProfile => _t('الملف', 'Profile');

  // Service Stopped Screen
  static String get ssTitle => _t('عذراً، الخدمة غير متوفرة حالياً', 'Sorry, service is currently unavailable');
  static String get ssMessage => _t('النظام متوقف حالياً لإجراء صيانة تقنية طارئة. يعمل فريقنا الطبي والتقني بأقصى سرعة لاستعادة الخدمة. شكراً لتفهمكم.', 'The system is down for emergency maintenance. Our team is working to restore service. Thank you for your understanding.');
  static String get ssRetry => _t('إعادة المحاولة', 'Retry');
  static String get ssGoHome => _t('العودة للرئيسية', 'Go Home');
  static String get ssStatusOffline => _t('OFFLINE', 'OFFLINE');
  static String get ssErrorCode => _t('ERROR CODE: 503_SERVICE_UNAVAILABLE_VITALITY_CORE', 'ERROR CODE: 503_SERVICE_UNAVAILABLE_VITALITY_CORE');

  // Forbidden
  static String get fbTitle => _t('عذراً، لا تملك الصلاحية الكافية', 'Sorry, insufficient permissions');
  static String get fbMessage => _t('هذه الصفحة مخصصة للمصرح لهم فقط. إذا كنت تعتقد أن هذا خطأ، يرجى التواصل مع الإدارة الطبية.', 'This page is for authorized personnel only. If you believe this is an error, please contact administration.');
  static String get fbGoHome => _t('العودة للرئيسية', 'Go Home');
  static String get fbContactSupport => _t('تواصل مع الدعم', 'Contact Support');
  static String get fbAccessIdLabel => _t('معرف الوصول', 'Access ID');
  static String get fbAccessIdValue => _t('REQ-403-VIT-2024', 'REQ-403-VIT-2024');
  static String get fbSecurityLabel => _t('حالة الأمن', 'Security Status');
  static String get fbSecurityValue => _t('محمي بتشفير Vitality', 'Protected by Vitality Encryption');

  // Session Expired
  static String get sesTitle => _t('انتهت صلاحية الجلسة', 'Session Expired');
  static String get sesMessage => _t('لدواعي الأمان، تم إنهاء جلستك الحالية. يرجى تسجيل الدخول مرة أخرى لمتابعة استخدام خدمات Vitality وحماية بياناتك.', 'For security reasons, your session has ended. Please log in again to continue using Vitality services.');
  static String get sesLogin => _t('تسجيل الدخول', 'Login');
  static String get sesGoHome => _t('العودة للرئيسية', 'Go Home');
  static String get sesCloseApp => _t('إغلاق التطبيق', 'Close App');
  static String get sesFooter => _t('Vitality Health Platform © 2024', 'Vitality Health Platform © 2024');

  // Suspended Account
  static String get spTitle => _t('تم إيقاف الحساب', 'Account Suspended');
  static String get spMessage => _t('نأسف لإبلاغك بأنه تم تعليق وصولك إلى خدمات Vitality.', 'Your access to Vitality services has been suspended.');
  static String get spReasonLabel => _t('سبب الإيقاف', 'Suspension Reason');
  static String get spReasonValue => _t('نشاط غير معتاد في الدخول إلى السجلات الطبية', 'Unusual activity accessing medical records');
  static String get spContactSupport => _t('تواصل مع الدعم الفني', 'Contact Support');
  static String get spLogout => _t('تسجيل الخروج', 'Logout');
  static String get spFooter => _t('© 2024 AeroHealth AI. جميع الحقوق محفوظة.', '© 2024 AeroHealth AI. All rights reserved.');

  // Unauthorized
  static String get uaTitle => _t('عذراً، الوصول غير مصرح', 'Unauthorized Access');
  static String get uaMessage => _t('يرجى تسجيل الدخول للوصول إلى هذه الصفحة والاستفادة من كافة الخدمات الطبية المتاحة.', 'Please log in to access this page and use all available medical services.');
  static String get uaLogin => _t('تسجيل الدخول', 'Login');
  static String get uaGoHome => _t('العودة للرئيسية', 'Go Home');
  static String get uaEncryption => _t('تشفير AES-256', 'AES-256 Encryption');
  static String get uaDataProtection => _t('حماية البيانات', 'Data Protection');
  static String get uaSecureProtocol => _t('بروتوكول آمن', 'Secure Protocol');
  static String get uaFooter => _t('Vitality Health Platform © 2024 • جميع الحقوق محفوظة', 'Vitality Health Platform © 2024 • All rights reserved');

  // Upload Files
  static String get ufTitle => _t('Medical Uploads', 'Medical Uploads');
  static String get ufActiveUploadLabel => _t('جاري التحميل الآن', 'Uploading now');
  static String get ufRecentUploadsLabel => _t('تحميلات حديثة', 'Recent Uploads');
  static String get ufViewAll => _t('عرض الكل', 'View All');
  static String get ufCancelUpload => _t('إلغاء التحميل', 'Cancel Upload');
  static String get ufProcessing => _t('جاري المعالجة', 'Processing');
  static String get ufProgressComplete => _t('مكتمل', 'Complete');
  static String get ufRemaining => _t('بقي', 'Remaining');
  static String get ufSecurityTitle => _t('تشفير طبي فائق', 'Medical Grade Encryption');
  static String get ufSecurityMessage => _t('يتم حماية جميع ملفاتك باستخدام بروتوكولات التشفير AES-256 المتوافقة مع معايير HIPAA الدولية لضمان خصوصيتك.', 'All your files are protected using AES-256 encryption compliant with international HIPAA standards.');
  static String get ufNavDashboard => _t('Dashboard', 'Dashboard');
  static String get ufNavRecords => _t('Records', 'Records');
  static String get ufNavUpload => _t('Upload', 'Upload');
  static String get ufNavProfile => _t('Profile', 'Profile');

  // Medical Records - Patient
  static String get mrTitle => _t('التاريخ الطبي', 'Medical History');
  static String get mrBloodTypeLabel => _t('فصيلة الدم', 'Blood Type');
  static String get mrAgeLabel => _t('العمر', 'Age');
  static String get mrConditionsTitle => _t('الحالات الطبية', 'Medical Conditions');
  static String get mrActiveLabel => _t('نشط', 'Active');
  static String get mrMedicationsTitle => _t('الأدوية الحالية', 'Current Medications');
  static String get mrAppointmentsTitle => _t('المواعيد السابقة', 'Previous Appointments');
  static String get mrViewAll => _t('عرض الكل', 'View All');
  static String get mrVisitDone => _t('تمت الزيارة', 'Visit Completed');
  static String get mrDocumentsTitle => _t('الوثائق الطبية', 'Medical Documents');
  static String get mrUploadDocument => _t('تحميل مستند جديد', 'Upload New Document');
  static String get mrUploadHint => _t('يدعم PDF, PNG, JPG', 'Supports PDF, PNG, JPG');
  static String get mrNavHome => _t('الرئيسية', 'Home');
  static String get mrNavRecords => _t('السجل', 'Records');
  static String get mrNavVitals => _t('المؤشرات', 'Vitals');
  static String get mrNavProfile => _t('الملف', 'Profile');

  // Supervision
  static String get supervisionRequests => _t('طَلَبَاتُ الإِشْرَافِ', 'Supervision Requests');
  static String get supervisingDoctors => _t('الأَطِبَّاءُ المُشْرِفُونَ', 'Supervising Doctors');
  static String get supervisedPatients => _t('المَرْضَى الخَاضِعُونَ لِلإِشْرَافِ', 'Supervised Patients');
  static String get pendingRequests => _t('الطَّلَبَاتُ المُعَلَّقَةُ', 'Pending Requests');
  static String get incomingRequests => _t('الطَّلَبَاتُ الوَارِدَةُ', 'Incoming Requests');
  static String get requestSupervision => _t('طَلَبُ إِشْرَافٍ طِبِّيٍّ', 'Request Supervision');
  static String get cancelRequest => _t('إِلْغَاءُ الطَّلَبِ', 'Cancel Request');
  static String get approveRequest => _t('مُوَافَقَةٌ', 'Approve');
  static String get rejectRequest => _t('رَفْضٌ', 'Reject');
  static String get removeSupervision => _t('إِنْهَاءُ الإِشْرَافِ', 'End Supervision');
  static String get mySupervisingDoctor => _t('طَبِيبِي المُشْرِفُ', 'My Supervising Doctor');
  static String get pendingSupervisionRequest => _t('طَلَبُ إِشْرَافٍ مُعَلَّقٌ', 'Pending Supervision Request');
  static String get supervisionRequestSent => _t('تَمَّ إِرْسَالُ طَلَبِ الإِشْرَافِ', 'Supervision request sent');
  static String get supervisionRequestCancelled => _t('تَمَّ إِلْغَاءُ طَلَبِ الإِشْرَافِ', 'Supervision request cancelled');
  static String get supervisionRequestApproved => _t('تَمَّتِ المُوَافَقَةُ عَلَى الطَّلَبِ', 'Supervision request approved');
  static String get supervisionRequestRejected => _t('تَمَّ رَفْضُ الطَّلَبِ', 'Supervision request rejected');
  static String get supervisionRemoved => _t('تَمَّ إِنْهَاءُ الإِشْرَافِ', 'Supervision ended');
  static String get noSupervisingDoctors => _t('لا يُوجَدُ أَطِبَّاءُ مُشْرِفُونَ', 'No supervising doctors');
  static String get noSupervisedPatients => _t('لا يُوجَدُ مَرْضَى تَحْتَ الإِشْرَافِ', 'No supervised patients');
  static String get noPendingRequests => _t('لا تُوجَدُ طَلَبَاتٌ مُعَلَّقَةٌ', 'No pending requests');
  static String get pending => _t('مُعَلَّقٌ', 'Pending');
  static String get active => _t('نَشِطٌ', 'Active');

  // Doctor Glass Card Supervision
  static String get supervisingYou => _t('مُشْرِفٌ عَلَيْكَ', 'Supervising You');
  static String get supervisionPending => _t('قَيْدُ المُرَاجَعَةِ', 'Under Review');
  static String get supervisionRejected => _t('تَمَّ الرَّفْضُ', 'Rejected');
  static String get requestAgain => _t('إِعَادَةُ الطَّلَبِ', 'Request Again');

  // === BLoC operation messages ===
  static String get opTimeSet => _t('تَمَّ تَعْيِينُ الوَقْتِ بِنَجَاحٍ', 'Time set successfully');
  static String get opAppointmentAccepted => _t('تَمَّ قَبُولُ المَوْعِدِ', 'Appointment accepted');
  static String get opAppointmentRejected => _t('تَمَّ رَفْضُ المَوْعِدِ', 'Appointment rejected');
  static String get opMedicineNotFound => _t('الدَّوَاءُ غَيْرُ مَوْجُودٍ', 'Medicine not found');
  static String get opPrescriptionNotFound => _t('الوَصْفَةُ غَيْرُ مَوْجُودَةٍ', 'Prescription not found');
  static String get opPrescriptionUpdated => _t('تَمَّ تَحْدِيثُ الوَصْفَةِ', 'Prescription updated');
  static String get opPrescriptionDeleted => _t('تَمَّ حَذْفُ الوَصْفَةِ', 'Prescription deleted');
  static String get opItemUpdated => _t('تَمَّ تَحْدِيثُ العُنْصُرِ', 'Item updated');
  static String get opItemDeleted => _t('تَمَّ حَذْفُ العُنْصُرِ', 'Item deleted');
  static String get opPatientAssigned => _t('تَمَّ تَعْيِينُ المَرِيضِ', 'Patient assigned');
  static String get opPatientsAssigned => _t('تَمَّ تَعْيِينُ المَرْضَى', 'Patients assigned');
  static String get opPatientRemoved => _t('تَمَّ إِزَالَةُ المَرِيضِ', 'Patient removed');
  static String get opDoctorRemoved => _t('تَمَّ إِزَالَةُ الطَّبِيبِ', 'Doctor removed');
  static String get opRequestSent => _t('تَمَّ إِرْسَالُ الطَّلَبِ', 'Request sent');
  static String get opRequestApproved => _t('تَمَّتِ المُوَافَقَةُ عَلَى الطَّلَبِ', 'Request approved');
  static String get opRequestRejected => _t('تَمَّ رَفْضُ الطَّلَبِ', 'Request rejected');
  static String get opRequestCancelled => _t('تَمَّ إِلْغَاءُ الطَّلَبِ', 'Request cancelled');
  static String get opUserNotFound => _t('المُسْتَخْدِمُ غَيْرُ مَوْجُودٍ', 'User not found');
  static String get opUserUpdated => _t('تَمَّ تَحْدِيثُ المُسْتَخْدِمِ', 'User updated');
  static String get opUserActivated => _t('تَمَّ تَنْشِيطُ المُسْتَخْدِمِ', 'User activated');
  static String get opUserDeactivated => _t('تَمَّ إِيقَافُ المُسْتَخْدِمِ', 'User deactivated');
  static String get opUserDeleted => _t('تَمَّ حَذْفُ المُسْتَخْدِمِ', 'User deleted');
  static String get opRoleNotFound => _t('الدَّوْرُ غَيْرُ مَوْجُودٍ', 'Role not found');
  static String get opRoleUpdated => _t('تَمَّ تَحْدِيثُ الدَّوْرِ', 'Role updated');
  static String get opPermissionNotFound => _t('الصَّلاحِيَةُ غَيْرُ مَوْجُودَةٍ', 'Permission not found');
  static String get opPermissionUpdated => _t('تَمَّ تَحْدِيثُ الصَّلاحِيَةِ', 'Permission updated');
  static String get opNotFound => _t('غَيْرُ مَوْجُودٍ', 'Not found');
  static String get opUpdated => _t('تَمَّ التَّحْدِيثُ', 'Updated');
  static String get opActivated => _t('تَمَّ التَّنْشِيطُ', 'Activated');
  static String get opDeactivated => _t('تَمَّ الإِيقَافُ', 'Deactivated');
  static String get opFailedToLoadFiles => _t('فَشِلَ تَحْمِيلُ المَلَفَّاتِ', 'Failed to load files');

  // Auth role names
  static String get roleNameAdmin => _t('مُدِير', 'Admin');
  static String get roleNameDoctor => _t('طَبِيب', 'Doctor');
  static String get roleNameReceptionist => _t('مَسْؤُولُ اسْتِقْبَالٍ', 'Receptionist');
  static String get roleNamePatient => _t('مَرِيض', 'Patient');

  // === Screen-level hardcoded strings ===

  // Greetings
  static String get greetingMorning => _t('صَبَاحُ الخَيْرِ', 'Good Morning');
  static String get greetingEvening => _t('مَسَاءُ الخَيْرِ', 'Good Evening');
  static String get greetingYouHave => _t('لَدَيْكَ', 'You have');
  static String get patientsWaiting => _t('مَرْضَى يَنْتَظِرُونَ', 'patients waiting');

  // Doctors Options Sheet
  static String get optionsAvailableFor => _t('الخِيَارَاتُ المُتَاحَةُ لـ', 'Options available for');
  static String get viewProfile => _t('عَرْضُ المِلَفِّ', 'View Profile');

  // Appointment Status
  static String get statusConfirmed => _t('مُؤَكَّدٌ', 'Confirmed');
  static String get statusPending => _t('قَيْدُ الانْتِظَارِ', 'Pending');
  static String get statusUnderReview => _t('قَيْدُ المُرَاجَعَةِ', 'Under Review');
  static String get statusInProgress => _t('قَيْدُ التَّنْفِيذِ', 'In Progress');

  // My Appointments Empty
  static String get noAppointmentsNow => _t('لا تُوجَدُ مَوَاعِيدٌ حَالِيّاً', 'No appointments currently');
  static String get bookWithOurDoctors => _t('احْجُزْ مَوْعِداً مَعَ أَحَدِ أَطِبَّائِنَا', 'Book an appointment with one of our doctors');

  // Dashboard Section Headers
  static String get sectionUsers => _t('المُسْتَخْدِمُونَ', 'Users');
  static String get sectionAppointments => _t('المَوَاعِيدُ', 'Appointments');
  static String get sectionStatistics => _t('الإِحْصَائِيَّاتُ', 'Statistics');
  static String get sectionQuickActions => _t('إِجْرَاءَاتٌ سَرِيعَةٌ', 'Quick Actions');

  // Settings
  static String get arabicLabel => _t('العَرَبِيَّةُ', 'Arabic');
  static String get englishLabel => _t('English', 'English');
  static String get darkModeTitle => _t('الوَضْعُ الدَّاكِنُ', 'Dark Mode');
  static String get themeLightActive => _t('الوَضْعُ الفَاتِحُ نَشِطٌ', 'Light mode active');
  static String get themeDarkActive => _t('الوَضْعُ الدَّاكِنُ نَشِطٌ', 'Dark mode active');
  static String get themeSystemActive => _t('يَتْبَعُ إِعْدَادَاتِ الجِهَازِ', 'Follows system settings');
  static String get chipLight => _t('فَاتِحٌ', 'Light');
  static String get chipDark => _t('دَاكِنٌ', 'Dark');
  static String get chipAuto => _t('تِلْقَائِيٌّ', 'Auto');

  // Timeline labels
  static String get timelineConfirmed => _t('مُؤَكَّدٌ', 'Confirmed');
  static String get timelinePending => _t('قَيْدُ الانْتِظَارِ', 'Pending');
  static String get timelineCompleted => _t('مُكْتَمَلٌ', 'Completed');
  static String get timelineCancelled => _t('مُلْغَىً', 'Cancelled');
  static String get timelineInProgress => _t('قَيْدُ التَّنْفِيذِ', 'In Progress');
  static String get tomorrow => _t('غَداً', 'Tomorrow');

  // Patient Records Empty
  static String get noDiagnosisYet => _t('لا يُوجَدُ تَشْخِيصٌ سَابِقٌ', 'No previous diagnosis');
  static String get noMedicationsNow => _t('لا تُوجَدُ أَدْوِيَةٌ حَالِيَّةٌ', 'No current medications');
  static String get noAppointmentsHistory => _t('لا تُوجَدُ مَوَاعِيدُ سَابِقَةٌ', 'No previous appointments');

  // User Booking
  static String get appointmentList => _t('قَائِمَةُ المَوَاعِيدِ', 'Appointment List');
  static String get periodMorning => _t('الفَتْرَةُ الصَّبَاحِيَّةُ', 'Morning');
  static String get periodEvening => _t('الفَتْرَةُ المَسَائِيَّةُ', 'Evening');
  static String get noAppointmentsYet => _t('لَيْسَ لَدَيْكَ مَوَاعِيدُ', 'You have no appointments');
  static String get whenYouBook => _t('عِنْدَمَا تَحْجُزُ مَوْعِداً سَيَظْهَرُ هُنَا', 'When you book an appointment it will appear here');
  static String get slotUnavailable => _t('الوَقْتُ غَيْرُ مُتَاحٍ حَالِيّاً', 'Time not available currently');
  static String get noSlotsToday => _t('لا تُوجَدُ مَوَاعِيدُ كَافِيَةٌ اليَوْمَ', 'Not enough slots today');

  // Appointment Options Sheet
  static String get editAppointment => _t('تَعْدِيلُ المَوْعِدِ', 'Edit Appointment');
  static String get cancelAppointment => _t('إِلْغَاءُ المَوْعِدِ', 'Cancel Appointment');
  static String get confirmAppointmentShort => _t('تَأْكِيدُ المَوْعِدِ', 'Confirm Appointment');
  static String get confirmCancellation => _t('تَأْكِيدُ الإِلْغَاءِ', 'Confirm Cancellation');
  static String get confirmCancellationMsg => _t('هَلْ أَنْتَ مُتَأَكِّدٌ مِنْ إِلْغَاءِ المَوْعِدِ؟', 'Are you sure you want to cancel?');
  static String get appointmentCancelled => _t('تَمَّ إِلْغَاءُ المَوْعِدِ', 'Appointment cancelled');

  // Doctors Screen
  static String get editDoctorData => _t('تَعْدِيلُ بَيَانَاتِ الطَّبِيبِ', 'Edit Doctor Data');
  static String get deleteDoctorTitle => _t('حَذْفُ الطَّبِيبِ', 'Delete Doctor');
  static String get deleteDoctorMsg => _t('هَلْ أَنْتَ مُتَأَكِّدٌ مِنْ حَذْفِ الطَّبِيبِ؟ هَذَا الإِجْرَاءُ نِهَائِيٌّ.', 'Are you sure you want to delete this doctor? This action is irreversible.');
  static String get pleaseSelect => _t('اخْتَرْ مِنْ فَضْلِكَ', 'Please select');
  static String get searchDoctorHint => _t('ابْحَثْ عَنْ طَبِيب...', 'Search for doctor...');
  static String get selectSpecialtyToSeeResults => _t('اخْتَرْ تَخَصُّصاً لِتَرَى النَّتَائِجَ', 'Select a specialty to see results');

  // Doctor Form Dialog
  static String get addNewDoctor => _t('إِضَافَةُ طَبِيبٍ جَدِيدٍ', 'Add New Doctor');
  static String get fieldRequired => _t('حَقْلٌ مَطْلُوبٌ', 'Required');

  // Profile
  static String get clinicAddress => _t('عُنْوَانُ العِيَادَةِ', 'Clinic Address');
  static String get notSpecified => _t('غَيْرُ مُحَدَّدٍ', 'Not specified');
  static String get dr => _t('د.', 'Dr.');

  // Rating
  static String get outOf5 => _t('مِنْ 5.0', 'out of 5.0');
  static String get ratingDoctor => _t('تَقْيِيم الطَّبِيب', 'Rate Doctor');
  static String get writeCommentHint => _t('اكْتُبْ تَعْلِيقَكَ...', 'Write your comment...');
  static String get submitRating => _t('إِرْسَالُ التَّقْيِيمِ', 'Submit Rating');

  // Notification Failure
  static String get ntEnablePermission => _t('تَفْعِيلُ الصَّلاحِيَةِ', 'Enable Permission');
  static String get ntBackToHome => _t('العَوْدَةُ لِلرَّئِيسِيَّةِ', 'Back to Home');

  // Search Failure
  static String get sfBackToHome => _t('العَوْدَةُ لِلرَّئِيسِيَّةِ', 'Back to Home');
  static String get sfEnableSearch => _t('تَفْعِيلُ البَحْثِ', 'Enable Search');

  // Forbidden/Unauthorized shared
  static String get backToHome => _t('العَوْدَةُ لِلرَّئِيسِيَّةِ', 'Back to Home');
  static String get defaultInitial => _t('م', 'U');
  static String get backToNotifications => _t('العودة للإشعارات', 'Back to Notifications');
  static String get backToSearch => _t('العودة للبحث', 'Back to Search');
  static String get searchAgain => _t('إعادة البحث', 'Search Again');
  static String get availableOptionsFor => _t('الخيارات المتاحة لـ', 'Available options for');
  static String get sfTitle => _t('البحث', 'Search');

  // Offline
  static String get cachedData => _t('عَرْضُ البَيَانَاتِ المُحَمَّلَةِ', 'Show cached data');

  // Doctors Screen
  static String get searchDoctorHintTitle => _t('البَحْثُ عَنْ طَبِيبٍ', 'Search for a doctor');
  static String get searchDifferentWord => _t('جَرِّبِ البَحْثَ بِكَلِمَةٍ مُخْتَلِفَةٍ', 'Try searching with a different word');

  // Font family names (will be moved to AppFonts if needed)
  static String get fontSora => 'Sora';
  static String get fontManrope => 'Manrope';
  static String get fontJetBrainsMono => 'JetBrains Mono';

  // Status labels used in appointment views
  static String get statusSetToPending => _t('مُعَلَّقٌ', 'Pending');

  // Pending appointment display status
  static String get pendingLabel => _t('مُعَلَّقٌ', 'Pending');

  // Appointment Options Sheet
  static String get viewDetails => _t('تَفَاصِيلُ المَوْعِدِ', 'View Details');
  static String get enableReminder => _t('تَفْعِيلُ التَّذْكِيرِ', 'Enable Reminder');

  // Settings Dialogs
  static String get chooseTheme => _t('اخْتَرِ الثِّيمَ', 'Choose Theme');
  static String get themeSystemLabel => _t('إِعْدَادَاتُ الجِهَازِ', 'System Default');

  // Doctor Form Dialog
  static String get availableTitle => _t('مُتَاحٌ', 'Available');
  static String get unavailableTitle => _t('غَيْرُ مُتَاحٍ', 'Unavailable');

  // Rating
  static String get ratingSentConfirmation => _t('تَمَّ إِرْسَالُ تَقْيِيمِكَ ✓', 'Your rating has been sent ✓');
  static String get ratingHint => _t('اكْتُبْ تَجْرِبَتَكَ مَعَ الدُّكْتُورِ...', 'Write your experience with the doctor...');

  // === NEW ADDITIONS ===

  // User Booking
  static String get noSlotsAvailable => _t('لا توجد مواعيد متاحة', 'No available slots');
  static String get selectNewTime => _t('اختر وقتاً جديداً', 'Select new time');
  static String get confirmNewAppointment => _t('تأكيد الموعد الجديد', 'Confirm new appointment');

  // Appointment Options Sheet
  static String cancelAppointmentConfirm(String docName) => _t('هل تريد إلغاء موعد\n$docName؟\nلا يمكن التراجع عن هذا الإجراء.', 'Do you want to cancel\n$docName?\nThis cannot be undone.');
  static String appointmentCancelledName(String docName) => _t('تم إلغاء موعد $docName', 'Appointment $docName cancelled');

  // Doctors Screen
  static String deleteDoctorConfirm(String doctorName) => _t('هل أنت متأكد من حذف ملف\nد. $doctorName؟\nلا يمكن التراجع عن هذا الإجراء.', 'Are you sure you want to delete\nDr. $doctorName?\nThis cannot be undone.');
  static String get searchFailed => _t('فشلت عملية البحث', 'Search failed');
  static String get noDoctorsFound => _t('لم يتم العثور على أطباء', 'No doctors found');

  // Auth Cubit
  static String get loginFailed => _t('فشلت عملية الدخول', 'Login failed');
  static String get registrationFailed => _t('فشلت عملية التسجيل', 'Registration failed');

  // FCM Service
  static String get fcmChannelAppointments => _t('إشعارات العيادة', 'Clinic Notifications');
  static String get fcmChannelDescription => _t('إشعارات حجز المواعيد وتذكيرات العلاج', 'Appointment booking notifications and treatment reminders');
  static String get fcmChannelNew => _t('إشعار جديد', 'New Notification');

  // Helpers dialog
  static String get confirmDeleteItem => _t('هل أنت متأكد من حذف هذا العنصر؟', 'Are you sure you want to delete this item?');
  static String get confirmDeleteTitle => _t('تأكيد الحذف', 'Confirm Delete');

  // Doctor Form Dialog
  static String get doctorAddedSuccess => _t('تم إضافة الطبيب بنجاح', 'Doctor added successfully');
  static String get doctorUpdatedSuccess => _t('تم تحديث الطبيب بنجاح', 'Doctor updated successfully');

  // Patient Form Dialog
  static String get patientAddedSuccess => _t('تم إضافة المريض بنجاح', 'Patient added successfully');
  static String get patientUpdatedSuccess => _t('تم تحديث المريض بنجاح', 'Patient updated successfully');

  // Upload Files
  static String get filePickerComingSoon => _t('قريباً: اختيار الملفات', 'File picker coming soon');

  // Patient Welcome
  static String get secureEncrypted => _t('آمن ومشفر', 'Secure & Encrypted');

  // Notification Screen
  static String get notificationSendFailed => _t('فشل إرسال الإشعار', 'Notification send failed');
  static String get notificationFailureMsg => _t('تعذر إرسال الإشعار في هذه اللحظة. يرجى التحقق من اتصالك بالشبكة والمحاولة مجدداً.', 'Could not send notification. Please check your connection and try again.');
  static String get searchFailureMsg => _t('لم نتمكن من إجراء البحث في هذه اللحظة. يرجى التحقق من صحة بيانات البحث.', 'Could not perform search. Please check your search data.');

  // Supervisions fallback
  static String get doctorFallback => _t('طبيب', 'Doctor');
  static String get patientFallback => _t('مريض', 'Patient');

  // Register Screens
  static String get passwordTitle => _t('كلمة السر', 'Password');
}
