import 'package:cloud_firestore/cloud_firestore.dart';

class RssModel {
  String? feedId;
  String? feedName;
  String? feedUrl;
  String? category;
  String? subCategory;
  String? selectedLanguage;
  String? articleImportCount;
  String? date;
  String? timestamp;
  String? adminId;

  RssModel({
    this.feedName,
    this.feedUrl,
    this.category,
    this.subCategory,
    this.selectedLanguage,
    this.articleImportCount,
    this.date,
    this.timestamp,
    this.adminId,
  });

  factory RssModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return RssModel(
      feedName: d['feed name'],
      feedUrl: d['feed url'],
      category: d['category'],
      subCategory: d['Sub Category'],
      selectedLanguage: d['selectedLanguage'],
      articleImportCount: d['articleCount'],
      date: d['date'],
      timestamp: d['timestamp'],
      adminId: d['adminId'],
    );
  }
}
