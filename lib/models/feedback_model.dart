class FeedbackModel {
  final int rating; // Rating from 1 to 5
  final String? comment; // Optional comment
  final bool escalate; // Flag to determine if escalation is required

  FeedbackModel({
    required this.rating,
    this.comment,
    required this.escalate,
  });
}
