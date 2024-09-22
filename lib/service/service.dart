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
      FirebaseFirestore.instance.collection("BookLecHalle");

  CollectionReference Schedule =
      FirebaseFirestore.instance.collection("Schedule");

  CollectionReference equiqments =
      FirebaseFirestore.instance.collection("Equiqment List");
  CollectionReference report = FirebaseFirestore.instance.collection("Report");

// Sign in
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

// Add the users Data
  Future<String> addData(String stId, String fNme, String lNme, String email,
      String address, String pNo, String psd, String role) async {
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
          'role': role,
          'Register Date': DateTime.now(),
        },
      );
      return 'Success';
    } catch (e) {
      return 'Fail';
    }
  }

// Update User Profiile
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

// Return user Details
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

// Add Message
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

// Return Message
  Stream<QuerySnapshot> getmsg() {
    return message.orderBy('DateTime', descending: true).snapshots();
  }

// Return Activity
  Stream<QuerySnapshot> getActivity(String id) {
    return activity.where('userId', isEqualTo: id).snapshots();
  }

// Add Notifications
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

// return Notifications
  Stream<QuerySnapshot> getNotifications(String id) {
    return activity.where('userId', isEqualTo: id).snapshots();
  }

// return  Lecture Halle Details
  Stream<List<Map<String, dynamic>>> getLectureHallDetails() {
    return hallDetails.snapshots().map((snapshot) {
      final data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return data;
    });
  }
  // Boook Lecture hallle

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
        return "booking found";
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

  // return Book date
  Future<List<DateTime>> bookDate() async {
    List<DateTime> bookingDate = [];
    QuerySnapshot querySnapshot = await bookLecHalle.get();

    for (var doc in querySnapshot.docs) {
      DateTime bookedDate = (doc['date'] as Timestamp).toDate();
      bookingDate.add(bookedDate);
    }

    return bookingDate;
  }

  // return Booking Peroid
  Future<List<Map<String, dynamic>>> bookPeroid() async {
    try {
      QuerySnapshot snapshot = await bookLecHalle.get();
      List<Map<String, dynamic>> bookings = snapshot.docs.map((doc) {
        return {
          'date': (doc['date'] as Timestamp).toDate(),
          'period': doc['period'],
        };
      }).toList();

      return bookings;
    } catch (e) {
      return [];
    }
  }

  Stream<QuerySnapshot> getShedule(String id) {
    return Schedule.where('Id', isEqualTo: id).snapshots();
  }

  // Add Schedule
  Future<String> AddScedule(String id, String title, String date) async {
    try {
      await Schedule.add({
        'Id': id,
        'title': title,
        'Date': date,
      });

      return "Succesful";
    } catch (e) {
      return "Error";
    }
  }

  // Delete Schedule
  Future<String> deleteSchedule(String id) async {
    try {
      final result = await Schedule.doc(id).delete();
      print(id);
      return "Succesfull";
    } catch (e) {
      return 'Error';
    }
  }

  // return Equiqment Details
  Stream<List<Map<String, dynamic>>> getEquiqmentDetails() {
    return equiqments.snapshots().map((snapshot) {
      final data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return data;
    });
  }

  // get Lec hall Count
  Future<int> lecHalleCount() async {
    try {
      QuerySnapshot querySnapshot = await hallDetails.get();
      int count = querySnapshot.size;

      return count;
    } catch (e) {
      return 0;
    }
  }

  // return Schedule count
  Future<int> scheduleCount() async {
    try {
      QuerySnapshot querySnapshot = await Schedule.get();
      int count = querySnapshot.size;

      return count;
    } catch (e) {
      return 0;
    }
  }

  // return equiqment count
  Future<int> equiqmentCount() async {
    try {
      QuerySnapshot querySnapshot = await equiqments.get();
      int count = querySnapshot.size;

      return count;
    } catch (e) {
      return 0;
    }
  }
  // return student count

  Future<int> studentCount() async {
    try {
      QuerySnapshot snapshot =
          await users.where('role', isEqualTo: 'Student').get();
      int count = snapshot.size;
      return count;
    } catch (e) {
      return 0;
    }
  }

  // return lecture Count
  Future<int> lecturetCount() async {
    try {
      QuerySnapshot snapshot =
          await users.where('role', isEqualTo: 'Lecture').get();
      int count = snapshot.size;
      return count;
    } catch (e) {
      return 0;
    }
  }
  // non staff count

  Future<int> staffCount() async {
    try {
      QuerySnapshot snapshot =
          await users.where('role', isEqualTo: 'Non-Staff').get();
      int count = snapshot.size;
      return count;
    } catch (e) {
      return 0;
    }
  }

// add the lecture hall

  Future<String> addHalle(String name, String computer, String chairs,
      String desk, String capacity) async {
    try {
      await hallDetails.add(
        {
          'Halle Name': name,
          'capacity': capacity,
          'chairs': chairs,
          'computers': computer,
          'Desk': desk,
        },
      );
      return 'Success';
    } catch (e) {
      return 'Fail';
    }
  }

  // add equiqment
  Future<String> addEquiqment(String name, String qty) async {
    try {
      await equiqments.add(
        {
          'Name': name,
          'qty': qty,
        },
      );
      return 'Success';
    } catch (e) {
      return 'Fail';
    }
  }
  // Add Report

  Future<String> addReport(String category, String msg, String id) async {
    try {
      await report.add(
        {
          'Category': category,
          'Message': msg,
          'Id': id,
          'Date': DateTime.now(),
        },
      );
      return 'Success';
    } catch (e) {
      return 'Fail';
    }
  }

// return reports
  Stream<QuerySnapshot> getReports() {
    return report.snapshots();
  }
}
