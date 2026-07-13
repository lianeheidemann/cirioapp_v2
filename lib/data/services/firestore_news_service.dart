import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/news_model.dart';
import 'news_service.dart';

/// Fonte de notícias da coleção pública `news` do Cloud Firestore.
///
/// O aplicativo é somente leitor. Criação, edição e exclusão devem ocorrer no
/// Console Firebase ou em um backend administrativo protegido.
class FirestoreNewsService extends NewsService {
  final FirebaseFirestore _firestore;

  FirestoreNewsService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Query<Map<String, dynamic>> get _publishedNews => _firestore
      .collection('news')
      .where('isPublished', isEqualTo: true)
      .orderBy('publishedAt', descending: true);

  @override
  Future<List<NewsModel>> fetchNews() async {
    final snapshot = await _publishedNews.get();
    return snapshot.docs.map(_fromDocument).toList(growable: false);
  }

  @override
  Stream<List<NewsModel>> watchNews() {
    return _publishedNews.snapshots().map(
          (snapshot) =>
              snapshot.docs.map(_fromDocument).toList(growable: false),
        );
  }

  NewsModel _fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = Map<String, dynamic>.from(doc.data());
    final timestamp = data['publishedAt'];
    if (timestamp is Timestamp) data['publishedAt'] = timestamp.toDate();
    return NewsModel.fromMap(doc.id, data);
  }
}
