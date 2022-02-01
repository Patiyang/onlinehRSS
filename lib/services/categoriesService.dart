import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final List<String> _categories = [];

  Future getCategories() async {
    try {
      await firestore.collection('categories').limit(1).get().then((value) async {
        if (value.size != 0) {
          QuerySnapshot snap = await firestore.collection('categories').get();
          List d = snap.docs;
          _categories.clear();
          d.forEach((element) {
            _categories.add(element['name']);
          });
        } else {
          _categories.clear();
        }
      });
    } catch (e) {
      print(e.toString());
    }

    return _categories;
  }
}
