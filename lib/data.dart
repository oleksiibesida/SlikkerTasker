import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

late Box app;
late Box data;

late User user;
late CalendarApi calendarApi;
late CollectionReference firestoreDB;
late GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['https://www.googleapis.com/auth/calendar.readonly']);

Map<String, dynamic> getDefaults() => {
      'time': DateTime.now().millisecondsSinceEpoch,
      'light': true,
      'accent': 240,
    };

Future<bool> signIn({bool silently = true}) async {
  await Firebase.initializeApp();
  refreshStatus('Syncing..');

  GoogleSignInAccount? account = silently ? await googleSignIn.signInSilently() : await googleSignIn.signIn();
  if (account == null) return false;

  GoogleSignInAuthentication auth = await account.authentication;

  calendarApi = CalendarApi(clientViaApiKey(auth.accessToken!));
  print(calendarApi.runtimeType);

  FirebaseAuth.instance
      .signInWithCredential(GoogleAuthProvider.credential(accessToken: auth.accessToken, idToken: auth.idToken))
      .then((credential) => firestoreConnect(credential));

  return true;
}

void firestoreConnect(UserCredential credential) async {
  app.put('signedIn', credential.user!);
  firestoreDB = FirebaseFirestore.instance.collection(credential.user!.uid);

  // Merge local and cloud settings
  Map<String, dynamic> tempSettings = Map<String, dynamic>.from(data.get('.settings') ?? {});
  getDefaults().forEach((key, value) => tempSettings[key] = key == 'time' ? value : tempSettings[key] ?? value);
  await data.clear();

  // Connect firebase listener
  firestoreDB.snapshots(includeMetadataChanges: true).listen((event) => event.docChanges
          .where((docChange) =>
              (data.get(docChange.doc.id)?['time'] ?? 0) < docChange.doc.data()?['time'] ||
              docChange.type == DocumentChangeType.removed)
          .forEach((change) {
        if (change.type == DocumentChangeType.removed)
          data.delete(change.doc.id);
        else
          data.put(change.doc.id, change.doc.data());
      }));

  // Connect local listener
  data.watch().listen((event) {
    if (event.value != null)
      firestoreDB.doc(event.key).set(event.value);
    else
      firestoreDB.doc(event.key).delete();
  });

  // Put new settings in DB
  data.put('.settings', tempSettings);
  firestoreDB.doc('.settings').set(tempSettings);

  refreshStatus('');
}

Function connectivityStatusRefresher = (a) {};
String connectivityStatus = '';
void refreshStatus(String status) {
  connectivityStatusRefresher(status);
  connectivityStatus = status;
}

void uploadData(String type, Map<String?, dynamic> map) {
  map['time'] = DateTime.now().millisecondsSinceEpoch;
  data.put(type + map['time'].toString(), map);
}
