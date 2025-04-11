import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:likhlo/Utils/Model/Profilemodel.dart';

import '../Provider/CustomerProvider.dart';

final userProfileDocProvider = Provider<DocumentReference?>((ref) {
  final userEmail = ref.watch(currentUserEmailProvider);
  if (userEmail == null) {
    log(
      'userProfileDocProvider: User email is null, cannot get document reference.',
    );
    return null;
  }

  final docRef = FirebaseFirestore.instance
      .collection('Profile')
      .doc(userEmail);
  log('userProfileDocProvider: Returning document reference: ${docRef.path}');
  return docRef;
});

final userProfileStreamProvider = StreamProvider<ProfileModel?>((ref) {
  final docRef = ref.watch(userProfileDocProvider);
  if (docRef == null) {
    log(
      'userProfileStreamProvider: Document reference is null, returning null stream.',
    );
    return Stream.value(null);
  }

  log(
    'userProfileStreamProvider: Listening to snapshots for document: ${docRef.path}',
  );
  return docRef
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) {
          log(
            'userProfileStreamProvider: Snapshot does not exist for document: ${docRef.path}',
          );
          return null;
        }
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data == null) {
          log(
            'userProfileStreamProvider: Snapshot data is null for document: ${docRef.path}',
          );
          return null;
        }
        final profileModel = ProfileModel.fromMap(data);
        log(
          'userProfileStreamProvider: Successfully mapped snapshot data to ProfileModel for: ${docRef.path}',
        );
        return profileModel;
      })
      .handleError((error) {
        log(
          'userProfileStreamProvider: Error fetching snapshot for ${docRef.path}: $error',
        );
        return null; // Or handle the error in a way that's appropriate for your UI
      });
});

final userProfileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref);
});

class ProfileRepository {
  final Ref _ref;

  ProfileRepository(this._ref);

  DocumentReference? get _docRef {
    final doc = _ref.read(userProfileDocProvider);
    if (doc == null) {
      log(
        'ProfileRepository: _docRef is null because user is not authenticated.',
      );
    } else {
      log('ProfileRepository: Getting document reference: ${doc.path}');
    }
    return doc;
  }

  Future<void> addOrUpdateProfile(ProfileModel profile) async {
    final doc = _docRef;
    if (doc == null) {
      log(
        'ProfileRepository.addOrUpdateProfile: User not authenticated, cannot update profile.',
      );
      throw Exception("User not authenticated");
    }

    log(
      'ProfileRepository.addOrUpdateProfile: Attempting to set data for document: ${doc.path} with data: ${profile.toMap()}',
    );
    try {
      await doc
          .set(profile.toMap(), SetOptions(merge: true))
          .then(
            (value) {
              log(
                'ProfileRepository.addOrUpdateProfile: Successfully updated profile for document: ${doc.path}',
              );
            },
            onError: (e) {
              log(
                'ProfileRepository.addOrUpdateProfile: Error updating profile for document: ${doc.path}: $e',
              );
              throw e; // Re-throw the error to be caught by the caller
            },
          );
    } catch (e) {
      log(
        'ProfileRepository.addOrUpdateProfile: Caught an error during set operation for ${doc.path}: $e',
      );
      rethrow; // Re-throw the error to be handled by the caller
    }
  }

  Future<ProfileModel?> getProfile() async {
    final doc = _docRef;
    if (doc == null) {
      log(
        'ProfileRepository.getProfile: User not authenticated, cannot get profile.',
      );
      throw Exception("User not authenticated");
    }

    log(
      'ProfileRepository.getProfile: Attempting to get data for document: ${doc.path}',
    );
    try {
      final snapshot = await doc.get();
      if (!snapshot.exists) {
        log(
          'ProfileRepository.getProfile: Document does not exist: ${doc.path}',
        );
        return null;
      }
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) {
        log('ProfileRepository.getProfile: Document data is null: ${doc.path}');
        return null;
      }
      final profileModel = ProfileModel.fromMap(data);
      log(
        'ProfileRepository.getProfile: Successfully retrieved profile for document: ${doc.path} with data: ${profileModel.toMap()}',
      );
      return profileModel;
    } catch (e) {
      log(
        'ProfileRepository.getProfile: Error getting profile for document: ${doc.path}: $e',
      );
      return null; // Or handle the error as needed
    }
  }

  Future<void> deleteProfile() async {
    final doc = _docRef;
    if (doc == null) {
      log(
        'ProfileRepository.deleteProfile: User not authenticated, cannot delete profile.',
      );
      throw Exception("User not authenticated");
    }

    log(
      'ProfileRepository.deleteProfile: Attempting to delete document: ${doc.path}',
    );
    try {
      await doc.delete().then(
        (_) {
          log(
            'ProfileRepository.deleteProfile: Successfully deleted profile for document: ${doc.path}',
          );
        },
        onError: (e) {
          log(
            'ProfileRepository.deleteProfile: Error deleting profile for document: ${doc.path}: $e',
          );
          throw e; // Re-throw the error
        },
      );
    } catch (e) {
      log(
        'ProfileRepository.deleteProfile: Caught an error during delete operation for ${doc.path}: $e',
      );
      rethrow; // Re-throw the error
    }
  }
}
