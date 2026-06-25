import 'package:clinic_management_app/data/models/review_model.dart';
import 'package:clinic_management_app/data/models/doctor_schedule_model.dart';

abstract class ReviewDataSource {
  List<ReviewModel> getDoctorReviews(String doctorId);
  List<DoctorScheduleModel> getDoctorSlots(String doctorId, DateTime month);
  void addReview(String doctorId, ReviewModel review);
  void toggleSlotAvailability(String slotId);
}
