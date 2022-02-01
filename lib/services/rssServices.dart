import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rssadmin/models/rssModel.dart';

class RssServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<RssModel>> getRssArticles() async {
    List<RssModel> rssItems = [];
    try {
      await firestore.collection('rss sources').orderBy('timestamp', descending: true).get().then((value) {
            // print(value.docs);

        for (int i = 0; i < value.docs.length; i++) {
          if (value.docs[i]['adminId'].isNotEmpty) {
            rssItems.add(RssModel.fromFirestore(value.docs[i]));
            // print(rssItems);
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return rssItems;
  }
}
