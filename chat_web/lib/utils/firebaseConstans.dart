import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

final auth = FirebaseAuth.instance;

String userUid = auth.currentUser.uid.toString();

FirebaseFirestore fireStoreSnapshotRef = FirebaseFirestore.instance;
