// To parse this JSON data, do
//
//     final campaignDetailsModel = campaignDetailsModelFromJson(jsonString);

import 'dart:convert';

CampaignDetailsModel campaignDetailsModelFromJson(String str) =>
    CampaignDetailsModel.fromJson(json.decode(str));

String campaignDetailsModelToJson(CampaignDetailsModel data) =>
    json.encode(data.toJson());

class CampaignDetailsModel {
  CampaignDetailsModel(
      {this.title,
      this.description,
      this.image,
      this.userImage,
      this.userName,
      this.createdBy,
      this.createdAt,
      this.category,
      required this.remainingTime,
      this.raisedAmount,
      this.goalAmount,
      required this.faqs,
      required this.updates,
      required this.comments,
      required this.campaignOwnerId});

  String? title;
  String? description;
  String? image;
  dynamic userImage;
  String? userName;
  String? createdBy;
  int campaignOwnerId;
  String? createdAt;
  String? category;
  DateTime remainingTime;
  String? raisedAmount;
  String? goalAmount;
  Faqs? faqs;
  List<Update> updates;
  Comments comments;

  factory CampaignDetailsModel.fromJson(Map<String, dynamic> json) =>
      CampaignDetailsModel(
        title: json["title"],
        description: json["description"],
        image: json["image"],
        userImage: json["user_image"],
        userName: json["user_name"],
        createdBy: json["created_by"],
        campaignOwnerId: json["campaign_owner_id"],
        createdAt: json["created_at"],
        category: json["category"],
        remainingTime: DateTime.parse(json["remaining_time"]),
        raisedAmount: json["raised_amount"],
        goalAmount: json["goal_amount"],
        faqs: Faqs.fromJson(json["faqs"]),
        updates:
            List<Update>.from(json["updates"].map((x) => Update.fromJson(x))),
        comments: Comments.fromJson(json["comments"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "user_image": userImage,
        "user_name": userName,
        "created_by": createdBy,
        "campaign_owner_id": campaignOwnerId,
        "created_at": createdAt,
        "category": category,
        "remaining_time":
            "${remainingTime.year.toString().padLeft(4, '0')}-${remainingTime.month.toString().padLeft(2, '0')}-${remainingTime.day.toString().padLeft(2, '0')}",
        "raised_amount": raisedAmount,
        "goal_amount": goalAmount,
        "faqs": faqs?.toJson(),
        "updates": List<dynamic>.from(updates.map((x) => x.toJson())),
        "comments": comments.toJson(),
      };
}

class Comments {
  Comments({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<Datum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory Comments.fromJson(Map<String, dynamic> json) => Comments(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.id,
    this.causeId,
    this.userId,
    this.commentedBy,
    this.commentContent,
  });

  int? id;
  int? causeId;
  int? userId;
  String? commentedBy;
  String? commentContent;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        causeId: json["cause_id"],
        userId: json["user_id"],
        commentedBy: json["commented_by"],
        commentContent: json["comment_content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cause_id": causeId,
        "user_id": userId,
        "commented_by": commentedBy,
        "comment_content": commentContent,
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}

class Faqs {
  Faqs({
    required this.title,
    required this.description,
  });

  List<String?> title;
  List<String?> description;

  factory Faqs.fromJson(Map<String, dynamic>? json) => Faqs(
        title: List<String?>.from(json?["title"].map((x) => x)),
        description: List<String?>.from(json?["description"].map((x) => x)),
      );

  Map<String, dynamic>? toJson() => {
        "title": List<dynamic>.from(title.map((x) => x)),
        "description": List<dynamic>.from(description.map((x) => x)),
      };
}

class Update {
  Update({
    this.id,
    this.image,
    this.causeId,
    this.description,
    this.title,
  });

  int? id;
  String? image;
  String? causeId;
  String? description;
  String? title;

  factory Update.fromJson(Map<String, dynamic> json) => Update(
        id: json["id"],
        image: json["image"],
        causeId: json["cause_id"],
        description: json["description"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "cause_id": causeId,
        "description": description,
        "title": title,
      };
}
