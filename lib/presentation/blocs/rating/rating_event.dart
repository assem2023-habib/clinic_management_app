import 'package:equatable/equatable.dart';

enum RatingFilterOption { newest, highest, lowest, withPhotos }

abstract class RatingEvent extends Equatable {
  const RatingEvent();
  @override
  List<Object?> get props => [];
}

class RatingLoad extends RatingEvent {
  final String? doctorId;
  final String? raterId;
  const RatingLoad({this.doctorId, this.raterId});
  @override
  List<Object?> get props => [doctorId, raterId];
}

class RatingFilterChanged extends RatingEvent {
  final RatingFilterOption filter;
  const RatingFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class RatingLoadMore extends RatingEvent {
  const RatingLoadMore();
}

class RatingToggleLike extends RatingEvent {
  final String reviewId;
  const RatingToggleLike(this.reviewId);
  @override
  List<Object?> get props => [reviewId];
}

class RatingCreate extends RatingEvent {
  final String type;
  final String? rateableId;
  final String? rateableType;
  final int rating;
  final String? comment;

  const RatingCreate({
    required this.type,
    this.rateableId,
    this.rateableType,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [type, rateableId, rateableType, rating, comment ?? ''];
}

class RatingUpdate extends RatingEvent {
  final String id;
  final int rating;
  final String? comment;

  const RatingUpdate({
    required this.id,
    required this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [id, rating, comment ?? ''];
}

class RatingDelete extends RatingEvent {
  final String id;
  const RatingDelete(this.id);
  @override
  List<Object?> get props => [id];
}
