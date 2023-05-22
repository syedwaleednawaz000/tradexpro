import 'dart:convert';
import '../../utils/date_util.dart';
import '../../utils/number_util.dart';

/// final faq = faqFromJson(jsonString);
FAQ faqFromJson(String str) => FAQ.fromJson(json.decode(str));

String faqToJson(FAQ data) => json.encode(data.toJson());

class FAQ {
  FAQ({
    required this.id,
    this.faqTypeId,
    this.question,
    this.answer,
    this.status,
    this.author,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int? faqTypeId;
  String? question;
  String? answer;
  int? status;
  int? author;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FAQ.fromJson(Map<String, dynamic> json) => FAQ(
        id: json["id"],
        faqTypeId: json["faq_type_id"],
        question: json["question"],
        answer: json["answer"],
        status: makeInt(json["status"]),
        author: makeInt(json["author"]),
        createdAt: makesDate(json, "created_at"),
        updatedAt: makesDate(json, "updated_at"),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "faq_type_id": faqTypeId,
        "question": question,
        "answer": answer,
        "status": status,
        "author": author,
        "created_at": formatDate(createdAt, format: dateTimeFormatYyyyMMDdHhMm),
        "updated_at": formatDate(updatedAt, format: dateTimeFormatYyyyMMDdHhMm),
      };
}
