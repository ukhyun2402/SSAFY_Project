class Review {
  int? id;
  String? content;
  int? productId;
  String? memberId;

  Review({
    this.id,
    this.content,
    this.productId,
    this.memberId,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        id: json['id'],
        content: json['content'],
        productId: json['productId'],
        memberId: json['memberId']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'productId': productId,
        'memberId': memberId,
      };
}
