import 'package:clinic_management_app/data/models/rating_model.dart';

abstract class RatingDataSource {
  List<RatingModel> get allRatings;
  void addRating(RatingModel rating);
  void updateRating(RatingModel rating);
  void deleteRating(String id);
}
