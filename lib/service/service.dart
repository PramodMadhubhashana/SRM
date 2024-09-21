import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference message =
      FirebaseFirestore.instance.collection("Message");
  CollectionReference activity =
      FirebaseFirestore.instance.collection("Activity");

  CollectionReference notifications =
      FirebaseFirestore.instance.collection("Notifications");
  CollectionReference hallDetails =
      FirebaseFirestore.instance.collection("Lec Halle");

  CollectionReference bookLecHalle =
      FirebaseFirestore.instance.collection("Book Lec halle");

  Future<Map<String, dynamic>> signInWithIdAndPassword(
      String userId, String psd) async {
    try {
      QuerySnapshot querySnapshot = await users
          .where('Id', isEqualTo: userId)
          .where('Password', isEqualTo: psd)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var userDoc = querySnapshot.docs.first.data() as Map<String, dynamic>;
        String role = userDoc['role'] as String;

        return {
          'role': role,
          'id': userId,
        };
      } else {
        return {
          'role': Null,
          'id': Null,
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error : $e");
      }
      return {
        'role': Null,
        'id': Null,
      };
    }
  }

  Future<String> addData(String stId, String fNme, String lNme, String email,
      String address, String pNo, String psd) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(stId).get();
      if (documentSnapshot.exists) {
        return 'available';
      }
      await users.doc(stId).set(
        {
          'Id': stId,
          'First Name': fNme,
          'Last Name': lNme,
          'Email': email,
          'Address': address,
          'Phone No': pNo,
          'Password': psd,
          'role': 'Student',
          'Register Date': DateTime.now(),
        },
      );
      return 'Success';
    } catch (e) {
      return 'Fail';
    }
  }

  Future<String> UpdateeProfile(String id, String fNme, String lNme,
      String email, String address, String pNo) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(id).get();
      if (!documentSnapshot.exists) {
        return 'User not found';
      }
      await users.doc(id).update(
        {
          'First Name': fNme,
          'Last Name': lNme,
          'Email': email,
          'Address': address,
          'Phone No': pNo,
        },
      );
      return 'Success';
    } catch (e) {
      return 'Fail';
    }
  }

  Future<DocumentSnapshot?> getUsersData(String userId) async {
    try {
      DocumentSnapshot snapshot = await users.doc(userId).get();
      if (snapshot.exists) {
        return snapshot;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> msg(String msg, String stId) async {
    try {
      DocumentSnapshot? userData = await getUsersData(stId);

      if (userData != null && userData.exists) {
        await message.doc().set(
          {
            'message': msg,
            'name': userData['First Name'],
            'DateTime': DateTime.now(),
            'role': userData['role'],
          },
        );
      }
    } catch (e) {
      return;
    }
  }

  Stream<QuerySnapshot> getmsg() {
    return message.orderBy('DateTime', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getActivity(String id) {
    return activity.where('userId', isEqualTo: id).snapshots();
  }

  Future<void> addNotification(String userId, String title, String body) async {
    final dateTime = DateTime.now().toIso8601String();

    DocumentReference userDoc = notifications.doc(userId);
    await userDoc.update({
      'notifications': FieldValue.arrayUnion([
        {
          'title': title,
          'body': body,
          'date': dateTime,
        }
      ]),
    }).catchError((error) {
      if (error is FirebaseException && error.code == 'not-found') {
        userDoc.set({
          'notifications': [
            {
              'title': title,
              'body': body,
              'date': dateTime,
            }
          ],
        });
      } else {
        if (kDebugMode) {
          print('Failed to add notification: $error');
        }
      }
    });
  }

  Stream<QuerySnapshot> getNotifications(String id) {
    return activity.where('userId', isEqualTo: id).snapshots();
  }

  Stream<List<Map<String, dynamic>>> getLectureHallDetails() {
    return hallDetails.snapshots().map((snapshot) {
      final data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return data;
    });
  }

  Future<String> booklechalls(
      String HalleName, DateTime date, String period, String id) async {
    try {
      QuerySnapshot querySnapshot = await bookLecHalle
          .where('hallId', isEqualTo: HalleName)
          .where('date', isEqualTo: date)
          .where('id', isEqualTo: id)
          .where('period', isEqualTo: period)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return "The hall is already booked for this date and period.";
      }

      await bookLecHalle.add({
        'hallId': HalleName,
        'date': date,
        'period': period,
        'id': id,
        'createdAt': DateTime.now(),
      });

      return 'Successful';
    } catch (e) {
      print('Error booking hall: $e');
      return 'Fail';
    }
  }

  Future<List<DateTime>> bookDate() async {
    List<DateTime> bookingDate = [];
    QuerySnapshot querySnapshot = await bookLecHalle.get();

    for (var doc in querySnapshot.docs) {
      DateTime bookedDate = (doc['date'] as Timestamp).toDate();
      bookingDate.add(bookedDate);
    }

    return bookingDate;
  }

  Future<List<Map<String, dynamic>>> bookPeroid() async {
    try {
      QuerySnapshot snapshot = await bookLecHalle.get();
      return snapshot.docs.map((doc) {
        return {
          'date': (doc['date'] as Timestamp).toDate(),
          'period': doc['period'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }
}
