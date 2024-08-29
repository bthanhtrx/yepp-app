import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yepp/features/home/data/model/restaurant_model.dart';

abstract interface class FavoriteRemoteDatasource {
  Future<List<LocalPlaceModel>> getAllFavoritesRemote();

  Future<void> addFavoriteRemote(LocalPlaceModel localPlaceModel);
  Future<void> deleteFavoriteRemote(LocalPlaceModel localPlaceModel);

  Future<bool> isFavoriteRemote(LocalPlaceModel localPlaceModel);
}

class FavoriteRemoteDatasourceImpl implements FavoriteRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  FavoriteRemoteDatasourceImpl(
      {required this.firestore, required this.firebaseAuth});

  @override
  Future<void> addFavoriteRemote(LocalPlaceModel localPlaceModel) async {
    final isExist = await isFavoriteRemote(localPlaceModel);

    if(isExist) {
      var snapshot = await firestore.collection('users').doc(firebaseAuth.currentUser!.uid).collection('favorites').where('id', isEqualTo: localPlaceModel.id).get().then(
            (doc) {
          doc.docs[0].reference.delete();
          return doc.docs;
        },
        onError: (e) => print("Error updating document $e"),
      );
    } else {

    firestore.collection('users').doc(firebaseAuth.currentUser!.uid).collection(
        'favorites').add(localPlaceModel.toJson());
    }
  }


  @override
  Future<List<LocalPlaceModel>> getAllFavoritesRemote() async {
    var listen = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('favorites')
        .get();
    return listen.docs
        .map(
          (e) => LocalPlaceModel.fromJson(e.data()),
    )
        .toList();
  }

  @override
  Future<bool> isFavoriteRemote(LocalPlaceModel localPlaceModel) async{
    final collection = await firestore.collection('users').doc(firebaseAuth.currentUser!.uid).collection('favorites').where('id', isEqualTo: localPlaceModel.id).get();


    return collection.size >= 1;
  }

  @override
  Future<void> deleteFavoriteRemote(LocalPlaceModel localPlaceModel) async{
    final isExist = await isFavoriteRemote(localPlaceModel);
    if(isExist) {
      var snapshot = await firestore.collection('users').doc(firebaseAuth.currentUser!.uid).collection('favorites').where('id', isEqualTo: localPlaceModel.id).get().then(
            (doc) {
              doc.docs[0].reference.delete();
              return doc.docs;
            },
        onError: (e) => print("Error updating document $e"),
      );

    }
  }

}
