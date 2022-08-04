class TextBubble {
  final int requestId;
  final bool isResponse;
  final String message, origin;
  TextBubble(this.requestId, this.isResponse, this.message, this.origin);
}