import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

class FunctionA {
  int rate;
  String? comment;
  bool voteForEscalation;

  // Constructor with optional named parameters
  FunctionA(
      {required this.rate, this.comment, required this.voteForEscalation});

  // Method to add or update the rating
  void addRating(int newRate) {
    rate = newRate;
    printToConsole("Rating updated to $rate");
  }

  // Method to add or update the comment
  void addComment(String newComment) {
    comment = newComment;
    printToConsole("Comment added: $comment");
  }

  // Method to vote for escalation (true or false)
  void voteForEscalationMethod(bool vote) {
    voteForEscalation = vote;
    if (vote) {
      printToConsole("Escalation requested.");
    } else {
      printToConsole("No escalation requested.");
    }
  }

  // Method to display the feedback details
  void displayFeedback() {
    printToConsole("Rating: $rate");
    if (comment != null) {
      printToConsole("Comment: $comment");
    }
    printToConsole("Escalation Requested: ${voteForEscalation ? 'Yes' : 'No'}");
  }
}
