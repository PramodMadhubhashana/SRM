import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

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

  FirebaseStorage storage = FirebaseStorage.instance;

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
      String address, String pNo, String psd, String role, String img) async {
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
          'img': img
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
  // imge user

  Future<String?> getUserImage(String userId) async {
    try {
      DocumentSnapshot snapshot = await users.doc(userId).get();
      if (snapshot.exists) {
        return (snapshot.data() as Map<String, dynamic>?)?['img'] as String?;
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

  // add activity
  Future<String> addActivity(String act, String uid) async {
    try {
      await activity.add(
        {
          'userId': uid,
          "Activity": act,
          "DateTime": DateTime.now(),
        },
      );
      return "Succesfull";
    } catch (e) {
      return 'Fail';
    }
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
          'Role': getRole(userId),
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
              'Role': getRole(userId),
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
    return activity.where('Role', isEqualTo: id).snapshots();
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

  Future<void> booklechalls(
      String HalleName, DateTime date, String period, String id) async {
    final dateTime = DateTime.now().toIso8601String();

    DocumentReference userDoc = bookLecHalle.doc(HalleName);
    await userDoc.update({
      'Booked Details': FieldValue.arrayUnion([
        {
          'hallId': HalleName,
          'date': date,
          'period': period,
          'id': id,
          'createdAt': DateTime.now(),
        }
      ]),
    }).catchError((error) {
      if (error is FirebaseException && error.code == 'not-found') {
        userDoc.set({
          'Booked Details': [
            {
              'hallId': HalleName,
              'date': date,
              'period': period,
              'id': id,
              'createdAt': DateTime.now(),
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

  Future<QuerySnapshot> bookDate() async {
    return await bookLecHalle.get();
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

  // return Equiqment Details
  Stream<List<Map<String, dynamic>>> getEquiqmentDetails() {
    return equiqments.snapshots().map((snapshot) {
      final data = snapshot.docs.map((doc) {
        final docData = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
        return docData;
      }).toList();

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

  Future<int> adminCount() async {
    try {
      QuerySnapshot snapshot =
          await users.where('role', isEqualTo: 'Admin').get();
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
      String desk, String capacity, String img) async {
    try {
      await hallDetails.add(
        {
          'Halle Name': name,
          'capacity': capacity,
          'chairs': chairs,
          'computers': computer,
          'Desk': desk,
          'img': img
        },
      );
      return 'Success';
    } catch (e) {
      return 'Fail';
    }
  }

  // add equiqment
  Future<String> addEquiqment(String name, String qty, String img) async {
    try {
      await equiqments.add(
        {
          'Name': name,
          'date': DateTime.now(),
          'qty': int.parse(qty),
          'morningqty': 0,
          'eveningqty': 0,
          'fullTimeqty': 0,
          'img': img
        },
      );
      return 'Success';
    } catch (e) {
      return 'Fail';
    }
  }

  // book equiqment
  Future<String> bookEquiqment(
      int qty, String name, String id, String period) async {
    try {
      DocumentReference userDoc = equiqments.doc(id);
      await userDoc.update({
        'Booked Details': FieldValue.arrayUnion([
          {
            name: qty,
            'Period': period,
            'date': DateTime.now(),
          }
        ]),
      }).catchError((error) {
        if (error is FirebaseException && error.code == 'not-found') {
          userDoc.set({
            'Booked Details': [
              {
                name: qty,
                'Period': period,
                'date': DateTime.now(),
              }
            ],
          });
        } else {
          if (kDebugMode) {
            print('Failed to add notification: $error');
          }
        }
      });

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

  // return Role
  Future<String> getRole(String id) async {
    try {
      DocumentSnapshot userDoc = await users.doc(id).get();
      return userDoc['role'];
    } catch (e) {
      return '';
    }
  }

// return students
  Stream<QuerySnapshot> getstudents() {
    return users.where('role', isEqualTo: 'Student').snapshots();
  }

// admin details
  Stream<QuerySnapshot> getadmin() {
    return users.where('role', isEqualTo: 'Admin').snapshots();
  }

  // get equiqmennt
  Stream<QuerySnapshot> getequiqment() {
    return equiqments.snapshots();
  }

  // return lectures
  Stream<QuerySnapshot> getlectures() {
    return users.where('role', isEqualTo: 'Lecture').snapshots();
  }

  // return non acadmic staff
  Stream<QuerySnapshot> getnonacadmicstaff() {
    return users.where('role', isEqualTo: 'Non-Staff').snapshots();
  }

  // delete users
  Future<String> deleteUsers(String id) async {
    try {
      await users.doc(id).delete();
      return "Successful";
    } catch (e) {
      return "Fail";
    }
  }

  // delete Equiqmets
  Future<String> deleteQuiqments(String id) async {
    try {
      await equiqments.doc(id).delete();

      return "Succesfull";
    } catch (e) {
      return 'Error';
    }
  }

  // Delete Schedule
  Future<String> deleteSchedule(String id) async {
    try {
      await Schedule.doc(id).delete();

      return "Succesfull";
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> deletemsg(String id) async {
    try {
      await message.doc(id).delete();
      return "Succesfull";
    } catch (e) {
      return 'Error';
    }
  }

  // upload add lec hall, lec hall image,

  Future<String> addLecHalleImage(dynamic file) async {
    try {
      String filename;
      String fileExtensions;
      if (kIsWeb) {
        filename = file.name;
        fileExtensions = filename.split('.').last;
      } else {
        File mobileFile = file;
        filename = basename(mobileFile.path);
        fileExtensions = filename.split(".").last;
      }
      String filePath =
          'lectureHalls/${DateTime.now().millisecondsSinceEpoch}.$fileExtensions';

      String mimeType = _getMimeType(fileExtensions);

      if (kIsWeb) {
        Uint8List fileBytes = file.bytes;
        TaskSnapshot snapshot = await storage
            .ref(filePath)
            .putData(fileBytes, SettableMetadata(contentType: mimeType));

        String? downloadurl = await snapshot.ref.getDownloadURL();

        return downloadurl;
      } else {
        File mobileFile = file;
        TaskSnapshot taskSnapshot = await storage
            .ref(filePath)
            .putFile(mobileFile, SettableMetadata(contentType: mimeType));
        String? url = await taskSnapshot.ref.getDownloadURL();
        return url;
      }
    } catch (e) {
      return "Fail";
    }
  }

  // add admin image

  Future<String> addAdminImage(dynamic file) async {
    try {
      String filename;
      String fileExtensions;
      if (kIsWeb) {
        filename = file.name;
        fileExtensions = filename.split('.').last;
      } else {
        File mobileFile = file;
        filename = basename(mobileFile.path);
        fileExtensions = filename.split(".").last;
      }
      String filePath =
          'adminImage/${DateTime.now().millisecondsSinceEpoch}.$fileExtensions';

      String mimeType = _getMimeType(fileExtensions);

      if (kIsWeb) {
        Uint8List fileBytes = file.bytes;
        TaskSnapshot snapshot = await storage
            .ref(filePath)
            .putData(fileBytes, SettableMetadata(contentType: mimeType));

        String? downloadurl = await snapshot.ref.getDownloadURL();

        return downloadurl;
      } else {
        File mobileFile = file;
        TaskSnapshot taskSnapshot = await storage
            .ref(filePath)
            .putFile(mobileFile, SettableMetadata(contentType: mimeType));
        String? url = await taskSnapshot.ref.getDownloadURL();
        return url;
      }
    } catch (e) {
      return "Fail";
    }
  }

  // add lectures imge

  Future<String> addLecturesImage(dynamic file) async {
    try {
      String filename;
      String fileExtensions;
      if (kIsWeb) {
        filename = file.name;
        fileExtensions = filename.split('.').last;
      } else {
        File mobileFile = file;
        filename = basename(mobileFile.path);
        fileExtensions = filename.split(".").last;
      }
      String filePath =
          'lectursImage/${DateTime.now().millisecondsSinceEpoch}.$fileExtensions';

      String mimeType = _getMimeType(fileExtensions);

      if (kIsWeb) {
        Uint8List fileBytes = file.bytes;
        TaskSnapshot snapshot = await storage
            .ref(filePath)
            .putData(fileBytes, SettableMetadata(contentType: mimeType));

        String? downloadurl = await snapshot.ref.getDownloadURL();

        return downloadurl;
      } else {
        File mobileFile = file;
        TaskSnapshot taskSnapshot = await storage
            .ref(filePath)
            .putFile(mobileFile, SettableMetadata(contentType: mimeType));
        String? url = await taskSnapshot.ref.getDownloadURL();
        return url;
      }
    } catch (e) {
      return "Fail";
    }
  }

  // add non acadmic imge

  Future<String> addNonAcadsmicStaffImage(dynamic file) async {
    try {
      String filename;
      String fileExtensions;
      if (kIsWeb) {
        filename = file.name;
        fileExtensions = filename.split('.').last;
      } else {
        File mobileFile = file;
        filename = basename(mobileFile.path);
        fileExtensions = filename.split(".").last;
      }
      String filePath =
          'NonAcadamicImage/${DateTime.now().millisecondsSinceEpoch}.$fileExtensions';

      String mimeType = _getMimeType(fileExtensions);

      if (kIsWeb) {
        Uint8List fileBytes = file.bytes;
        TaskSnapshot snapshot = await storage
            .ref(filePath)
            .putData(fileBytes, SettableMetadata(contentType: mimeType));

        String? downloadurl = await snapshot.ref.getDownloadURL();

        return downloadurl;
      } else {
        File mobileFile = file;
        TaskSnapshot taskSnapshot = await storage
            .ref(filePath)
            .putFile(mobileFile, SettableMetadata(contentType: mimeType));
        String? url = await taskSnapshot.ref.getDownloadURL();
        return url;
      }
    } catch (e) {
      return "Fail";
    }
  }

  // atudent imge
  Future<String> addStudentImage(dynamic file) async {
    try {
      String filename;
      String fileExtensions;
      if (kIsWeb) {
        filename = file.name;
        fileExtensions = filename.split('.').last;
      } else {
        File mobileFile = file;
        filename = basename(mobileFile.path);
        fileExtensions = filename.split(".").last;
      }
      String filePath =
          'studentImage/${DateTime.now().millisecondsSinceEpoch}.$fileExtensions';

      String mimeType = _getMimeType(fileExtensions);

      if (kIsWeb) {
        Uint8List fileBytes = file.bytes;
        TaskSnapshot snapshot = await storage
            .ref(filePath)
            .putData(fileBytes, SettableMetadata(contentType: mimeType));

        String? downloadurl = await snapshot.ref.getDownloadURL();

        return downloadurl;
      } else {
        File mobileFile = file;
        TaskSnapshot taskSnapshot = await storage
            .ref(filePath)
            .putFile(mobileFile, SettableMetadata(contentType: mimeType));
        String? url = await taskSnapshot.ref.getDownloadURL();
        return url;
      }
    } catch (e) {
      return "Fail";
    }
  }

  Future<String> addEquqmentImage(dynamic file) async {
    try {
      String filename;
      String fileExtensions;
      if (kIsWeb) {
        filename = file.name;
        fileExtensions = filename.split('.').last;
      } else {
        File mobileFile = file;
        filename = basename(mobileFile.path);
        fileExtensions = filename.split(".").last;
      }
      String filePath =
          'equqmentImage/${DateTime.now().millisecondsSinceEpoch}.$fileExtensions';

      String mimeType = _getMimeType(fileExtensions);

      if (kIsWeb) {
        Uint8List fileBytes = file.bytes;
        TaskSnapshot snapshot = await storage
            .ref(filePath)
            .putData(fileBytes, SettableMetadata(contentType: mimeType));

        String downloadurl = await snapshot.ref.getDownloadURL();

        return downloadurl;
      } else {
        File mobileFile = file;
        TaskSnapshot taskSnapshot = await storage
            .ref(filePath)
            .putFile(mobileFile, SettableMetadata(contentType: mimeType));
        String? url = await taskSnapshot.ref.getDownloadURL();
        return url;
      }
    } catch (e) {
      return "Fail";
    }
  }

  String _getMimeType(String fileextention) {
    switch (fileextention.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
