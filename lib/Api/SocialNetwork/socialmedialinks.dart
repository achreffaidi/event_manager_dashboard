// To parse this JSON data, do
//
//     final socialLinks = socialLinksFromJson(jsonString);

import 'dart:convert';

SocialLinks socialLinksFromJson(String str) => SocialLinks.fromJson(json.decode(str));

String socialLinksToJson(SocialLinks data) => json.encode(data.toJson());

class SocialLinks {
  List<SocialMediaLink> socialMediaLinks;

  SocialLinks({
    this.socialMediaLinks,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
    socialMediaLinks: List<SocialMediaLink>.from(json["social_media_links"].map((x) => SocialMediaLink.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "social_media_links": List<dynamic>.from(socialMediaLinks.map((x) => x.toJson())),
  };
}

class SocialMediaLink {
  String id;
  String title;
  String event;
  String link;
  String website;
  int v;

  SocialMediaLink({
    this.id,
    this.title,
    this.event,
    this.link,
    this.website,
    this.v,
  });

  factory SocialMediaLink.fromJson(Map<String, dynamic> json) => SocialMediaLink(
    id: json["_id"],
    title: json["title"],
    event: json["event"],
    link: json["link"],
    website: json["website"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "event": event,
    "link": link,
    "website": website,
    "__v": v,
  };
}
