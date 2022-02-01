import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:rssadmin/helpers&Widgets/helpers/styling.dart';
import 'package:rssadmin/helpers&Widgets/widgets/custom_button.dart';
import 'package:rssadmin/helpers&Widgets/widgets/custom_text.dart';
import 'package:rssadmin/helpers&Widgets/widgets/loading.dart';
import 'package:rssadmin/helpers&Widgets/widgets/text_field.dart';
import 'package:rssadmin/models/rssModel.dart';
import 'package:rssadmin/services/categoriesService.dart';
import 'package:rssadmin/services/rssServices.dart';
import 'package:rssadmin/views/authentication/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webfeed/webfeed.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<RssModel>? rssItems = [];
  bool loadingRss = true;
  RssServices rssServices = RssServices();
  CategoriesService categoriesService = CategoriesService();
  final addFormKey = GlobalKey<FormState>();
  String selectedCategory = '';
  String selectedLanguage = '';

  final updateFormKey = GlobalKey<FormState>();

  bool loadingCategories = false;
  List<String> categories = [];
  List languages = ['Kannada', 'English', 'Hindi'];

  final feedNameController = TextEditingController();
  final feedUrlController = TextEditingController();
  final feedArticleCountController = TextEditingController();

  final feedUpdateNameController = TextEditingController();
  final feedUpdateURLController = TextEditingController();
  final feedUpdateCountController = TextEditingController();

  bool uploadingArticle = false;
  String? _date;
  String? _timestamp;
  var _articleData;
  var selectedState;
  var selectedDistrict;
  @override
  void initState() {
    _getData(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'RSS Feeds'),
      ),
      body: RefreshIndicator(
        onRefresh: () => loadingRss == true ? Fluttertoast.showToast(msg: 'Data is updating') : _getData(true),
        child: loadingRss == true
            ? Loading(
                text: 'Updating RSS feeds',
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                itemCount: rssItems!.length,
                itemBuilder: (BuildContext context, int index) {
                  RssModel rssItem = rssItems![index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 19.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? grey.shade600 : grey.shade800,
                              // offset: Offset(3, 3),
                              blurRadius: 3,
                              spreadRadius: 3)
                        ],
                      ),
                      // alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                    text: rssItem.feedName,
                                    size: 19,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: primaryColor,
                                    ),
                                    child: CustomText(text: rssItem.category),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.access_time, size: 15, color: Colors.grey),
                                  SizedBox(width: 3),
                                  Text(
                                    rssItem.date!,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                text: rssItem.feedUrl,
                                textDecoration: TextDecoration.underline,
                                color: Colors.blue,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(
                                child: Container(
                                    height: 35,
                                    width: 45,
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? grey[600] : grey[100],
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Icon(Icons.delete, size: 16)),
                                onTap: () async {
                                  var val = await handleDelete(rssItem) ?? false;
                                  if (val == true) {
                                    try {
                                      await firestore.collection('rss sources').doc(rssItem.timestamp).delete().whenComplete(() {
                                        Fluttertoast.showToast(msg: 'Feed has been deleted');
                                        _getData(true);
                                      });
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  } else {
                                    print('error');
                                  }
                                },
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              InkWell(
                                child: Container(
                                    height: 35,
                                    width: 45,
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? grey[600] : grey[100],
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Icon(Icons.edit, size: 16)),
                                onTap: () {
                                  getUpdateCategories(rssItem);
                                  // nextScreen(context, UpdateRssFeed(rssModel: d));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? grey[600] : grey[100],
        onPressed: () async {
          getCategories();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  showAddRssModalSheet() {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setModalState) {
              List<String> fianlCategories = [];
              setModalState(() {
                fianlCategories = categories;
              });
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          'Import RSS Feed',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? grey.shade600 : grey.shade800,
                                        // offset: Offset(3, 3),
                                        blurRadius: 3,
                                        spreadRadius: 3)
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        value: selectedCategory.isEmpty ? null : selectedCategory,
                                        elevation: 8,
                                        // isExpanded: true,
                                        borderRadius: BorderRadius.circular(9),
                                        hint: CustomText(text: 'Select Category'),
                                        items: fianlCategories
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: CustomText(text: e),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          print(val);
                                          setModalState(() {
                                            selectedCategory = val.toString();
                                          });
                                        })),
                              ),
                              SizedBox(width: 40),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? grey.shade600 : grey.shade800,
                                        // offset: Offset(3, 3),
                                        blurRadius: 3,
                                        spreadRadius: 3)
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        value: selectedLanguage.isEmpty ? null : selectedLanguage,
                                        elevation: 8,
                                        // isExpanded: true,
                                        borderRadius: BorderRadius.circular(9),
                                        hint: CustomText(text: 'Select Language'),
                                        items: languages
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: CustomText(text: e),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          setModalState(() {
                                            selectedLanguage = val.toString();
                                          });
                                        })),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: feedNameController,
                          hint: 'Feed Name',
                          iconOne: Icons.edit,
                          validator: (v) {
                            if (v.IsEmpty) {
                              return 'feed name cannot be empty';
                            }
                          },
                        ),
                        CustomTextField(
                          controller: feedUrlController,
                          hint: 'Feed URL',
                          iconOne: Icons.link,
                          validator: (v) {
                            if (v.IsEmpty) {
                              return 'Feed URL cannot be empty';
                            }
                          },
                        ),
                        CustomTextField(
                          controller: feedArticleCountController,
                          hint: 'Feed Count',
                          iconOne: Icons.format_list_numbered,
                          validator: (v) {
                            if (v.IsEmpty) {
                              return 'Content count cannot be empty';
                            }
                          },
                        ),
                        uploadingArticle == true
                            ? SpinKitThreeBounce(
                                color: primaryColor,
                                size: 18,
                              )
                            : CustomFlatButton(
                                callback: () async {
                                  final SharedPreferences sp = await SharedPreferences.getInstance();

                                  if (feedArticleCountController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: 'Feed count cannot be empty');
                                  } else if (feedNameController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: 'Feed name cannot be empty');
                                  } else if (feedUrlController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: 'Feed url cannot be empty');
                                  } else {
                                    String adminId = sp.getString('adminId') ?? '';

                                    try {
                                      setModalState(() => uploadingArticle = true);

                                      await getDate().then((value) async {
                                        await saveRssToDatabase(adminId).whenComplete(() async {
                                          var resEng = await http.get(Uri.parse(feedUrlController.text));
                                          var channel = RssFeed.parse(resEng.body);
                                          if (channel.items!.isNotEmpty) {
                                            for (int i = 0; i < int.parse(feedArticleCountController.text); i++) {
                                              DateTime now = DateTime.now();
                                              String _d = DateFormat('dd MMMM yy').format(now);
                                              String _t = DateFormat('yyyyMMddHHmmss').format(now);

                                              String? imageUrl = '';
                                              RssItem rsItem = channel.items![i];
                                              if (rsItem.enclosure != null) {
                                                imageUrl = rsItem.enclosure!.url;
                                              } else if (rsItem.content != null) {
                                                if (rsItem.content!.images.isEmpty) {
                                                  imageUrl = '';
                                                } else {
                                                  print(rsItem.content!.images.length);
                                                  if (rsItem.content!.images.length >= 2) {
                                                    imageUrl = rsItem.content!.images.elementAt(1);
                                                  } else if (rsItem.content!.images.length == 1) {
                                                    imageUrl = rsItem.content!.images.elementAt(0);
                                                  }
                                                }
                                              } else if (rsItem.link!.isNotEmpty) {
                                                var data = await MetadataFetch.extract('https://${rsItem.link}');
                                                imageUrl = data!.image;
                                              }
                                              saveToDatabase(
                                                channel.items![i].title,
                                                imageUrl,
                                                channel.items![i].description,
                                                channel.items![i].author,
                                                _t + i.toString(),
                                                _d,
                                              ).whenComplete(() async => await Future.delayed(Duration(seconds: 1)));
                                            }
                                          }
                                        });
                                        setModalState(() => uploadingArticle = false);
                                        Navigator.pop(context, true);
                                        Fluttertoast.showToast(msg: 'Imported Successfully');
                                      });
                                    } catch (e) {
                                      print(e.toString());
                                      setModalState(() => uploadingArticle = false);
                                    }
                                  }
                                },
                                text: 'Import RSS feed',
                              )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  showUpdateRssModalSheet(RssModel rssModel) {
    selectedCategory = rssModel.category!;
    selectedLanguage = rssModel.selectedLanguage!;
    feedUpdateNameController.text = rssModel.feedName!;
    feedUpdateURLController.text = rssModel.feedUrl!;
    feedUpdateCountController.text = rssModel.articleImportCount!;
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(9), topRight: Radius.circular(9)),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setModalState) {
              List<String> fianlCategories = [];
              setModalState(() {
                fianlCategories = categories;
              });
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          'Update RSS Feed',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? grey.shade600 : grey.shade800,
                                        // offset: Offset(3, 3),
                                        blurRadius: 3,
                                        spreadRadius: 3)
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        value: selectedCategory.isEmpty ? null : selectedCategory,
                                        elevation: 8,
                                        // isExpanded: true,
                                        borderRadius: BorderRadius.circular(9),
                                        hint: CustomText(text: 'Select Category'),
                                        items: fianlCategories
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: CustomText(text: e),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          print(val);
                                          setModalState(() {
                                            selectedCategory = val.toString();
                                          });
                                        })),
                              ),
                              SizedBox(width: 40),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? grey.shade600 : grey.shade800,
                                        // offset: Offset(3, 3),
                                        blurRadius: 3,
                                        spreadRadius: 3)
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        value: selectedLanguage.isEmpty ? null : selectedLanguage,
                                        elevation: 8,
                                        // isExpanded: true,
                                        borderRadius: BorderRadius.circular(9),
                                        hint: CustomText(text: 'Select Language'),
                                        items: languages
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: CustomText(text: e),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          setModalState(() {
                                            selectedLanguage = val.toString();
                                          });
                                        })),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: feedUpdateNameController,
                          hint: 'Feed Name',
                          iconOne: Icons.edit,
                          validator: (v) {
                            if (v.IsEmpty) {
                              return 'feed name cannot be empty';
                            }
                          },
                        ),
                        CustomTextField(
                          controller: feedUpdateURLController,
                          hint: 'Feed URL',
                          iconOne: Icons.link,
                          validator: (v) {
                            if (v.IsEmpty) {
                              return 'Feed URL cannot be empty';
                            }
                          },
                        ),
                        CustomTextField(
                          controller: feedUpdateCountController,
                          hint: 'Feed Count',
                          iconOne: Icons.format_list_numbered,
                          validator: (v) {
                            if (v.IsEmpty) {
                              return 'Content count cannot be empty';
                            }
                          },
                        ),
                        uploadingArticle == true
                            ? SpinKitThreeBounce(
                                color: primaryColor,
                                size: 18,
                              )
                            : CustomFlatButton(
                                callback: () async {
                                  final SharedPreferences sp = await SharedPreferences.getInstance();

                                  if (feedUpdateCountController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: 'Feed count cannot be empty');
                                  } else if (feedUpdateNameController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: 'Feed name cannot be empty');
                                  } else if (feedUpdateURLController.text.isEmpty) {
                                    Fluttertoast.showToast(msg: 'Feed url cannot be empty');
                                  } else {
                                    String adminId = sp.getString('adminId') ?? '';

                                    try {
                                      setModalState(() => uploadingArticle = true);

                                      await getDate().then((value) async {
                                        await updateRssToDatabase(adminId, rssModel).whenComplete(() async {
                                          var resEng = await http.get(Uri.parse(feedUpdateURLController.text));
                                          var channel = RssFeed.parse(resEng.body);
                                          if (channel.items!.isNotEmpty) {
                                            for (int i = 0; i < int.parse(feedUpdateCountController.text); i++) {
                                              DateTime now = DateTime.now();
                                              String _d = DateFormat('dd MMMM yy').format(now);
                                              String _t = DateFormat('yyyyMMddHHmmss').format(now);

                                              String? imageUrl = '';
                                              RssItem rsItem = channel.items![i];

                                              // print('image src' + imageUrl);
                                              if (rsItem.enclosure != null) {
                                                imageUrl = rsItem.enclosure!.url;
                                                // print('enclosure ' + imageUrl!);
                                              } else if (rsItem.content != null) {
                                                if (rsItem.content!.images.isEmpty) {
                                                  imageUrl = '';
                                                } else {
                                                  if (rsItem.content!.images.length >= 2) {
                                                    imageUrl = rsItem.content!.images.elementAt(1);
                                                    // print('content 2' + imageUrl);
                                                  } else if (rsItem.content!.images.length == 1) {
                                                    imageUrl = rsItem.content!.images.elementAt(0);
                                                    // print('content 1' + imageUrl);
                                                  }
                                                }
                                              } else if (rsItem.description != null) {
                                                String description = rsItem.description!;
                                                final urlRegExp = RegExp(r'(?:(?:https?):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
                                                imageUrl = urlRegExp.firstMatch(description)!.group(0);
                                              } else if (rsItem.link!.isNotEmpty) {
                                                var data = await MetadataFetch.extract('https://${rsItem.link}');
                                                imageUrl = data!.image;
                                                // print('meta' + imageUrl!);
                                              }
                                              updateToDatabase(
                                                channel.items![i].title,
                                                imageUrl,
                                                channel.items![i].description,
                                                channel.items![i].author,
                                                _t + i.toString(),
                                                _d,
                                              ).whenComplete(() async => await Future.delayed(Duration(seconds: 1)));
                                            }
                                          }
                                        });
                                        setModalState(() => uploadingArticle = false);
                                        Navigator.pop(context, true);
                                        Fluttertoast.showToast(msg: 'Updated Successfully');
                                      });
                                    } catch (e) {
                                      print(e.toString());
                                      setModalState(() => uploadingArticle = false);
                                    }
                                  }
                                },
                                text: 'Update RSS feed',
                              )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  _getData(bool updating) async {
    if (updating == true) {
      setState(() {
        loadingRss = true;
      });
    }
    rssItems = await rssServices.getRssArticles();
    loadingRss = false;
    setState(() {});
  }

  getCategories() async {
    categories.clear();
    // categories =await categoriesService.getCategories().whenComplete(() => print(categories));
    categories = await categoriesService.getCategories();
    print(categories);
    var val = await showAddRssModalSheet() ?? false;
    if (val == true) {
      _getData(true);
    }
  }

  getUpdateCategories(RssModel rssItem) async {
    categories.clear();
    // categories =await categoriesService.getCategories().whenComplete(() => print(categories));
    categories = await categoriesService.getCategories();
    print(categories);
    var val = await showUpdateRssModalSheet(rssItem) ?? false;
    if (val == true) {
      _getData(true);
    }
  }

  handleDelete(RssModel rssItem) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: Theme.of(context).scaffoldBackgroundColor),
                  child: Column(
                    children: [
                      CustomText(
                        text: rssItem.feedUrl,
                        size: 19,
                        color: Colors.blue,
                        textDecoration: TextDecoration.underline,
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text: 'Are you sure you want to delete this feed URL?',
                        size: 19,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(child: CustomFlatButton(callback: () => Navigator.pop(context), text: 'Cancel')),
                          SizedBox(width: 10),
                          Expanded(child: CustomFlatButton(callback: () => Navigator.pop(context, true), text: 'Delete')),
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }

  Future saveToDatabase(String? title, String? imageUrl, String? description, String? sourceUrl, String? timestamp, String date) async {
    final DocumentReference ref = firestore.collection('contents').doc(timestamp);
    _articleData = {
      'category': selectedCategory,
      'content type': 'image',
      'selectedLanguage': selectedLanguage,
      'verified': true,
      'district': selectedDistrict,
      'state': selectedState,
      'title': title,
      'description': description,
      'image url': imageUrl,
      'youtube url': null,
      'loves': 0,
      'source': sourceUrl,
      'date': date,
      'timestamp': timestamp,
      'views': 0,
      'uid': null,
      'articleType': 'rss'
    };
    await ref.set(_articleData);
  }

  Future saveRssToDatabase(String adminId) async {
    final DocumentReference ref = firestore.collection('rss sources').doc(_timestamp);
    _articleData = {
      'feed name': feedNameController.text,
      'feed url': feedUrlController.text,
      'category': selectedCategory,
      'Sub Category': '',
      'selectedLanguage': selectedLanguage,
      'articleCount': feedArticleCountController.text,
      'date': _date,
      'timestamp': _timestamp,
      'adminId': adminId
    };
    await ref.set(_articleData);
  }

  Future updateToDatabase(String? title, String? imageUrl, String? description, String? sourceUrl, String? timestamp, String date) async {
    final DocumentReference ref = firestore.collection('contents').doc(timestamp);
    _articleData = {
      'category': selectedCategory,
      'content type': 'image',
      'selectedLanguage': selectedLanguage,
      'verified': true,
      'district': selectedDistrict,
      'state': selectedState,
      'title': title,
      'description': description,
      'image url': imageUrl,
      'youtube url': null,
      'loves': 0,
      'source': sourceUrl,
      'date': date,
      'timestamp': timestamp,
      'views': 0,
      'uid': null,
      'articleType': 'rss'
    };
    await ref.set(_articleData);
  }

  Future updateRssToDatabase(String adminId, RssModel rssItem) async {
    final DocumentReference ref = firestore.collection('rss sources').doc(rssItem.timestamp);
    _articleData = {
      'feed name': feedUpdateNameController.text,
      'feed url': feedUpdateURLController.text,
      'category': selectedCategory,
      'Sub Category': '',
      'selectedLanguage': selectedLanguage,
      'articleCount': feedUpdateCountController.text,
      'date': _date,
      'timestamp': rssItem.timestamp,
      'adminId': adminId
    };
    await ref.update(_articleData);
  }

  Future getDate() async {
    DateTime now = DateTime.now();
    String _d = DateFormat('dd MMMM yy').format(now);
    String _t = DateFormat('yyyyMMddHHmmss').format(now);
    setState(() {
      _timestamp = _t;
      _date = _d;
    });
  }
}
