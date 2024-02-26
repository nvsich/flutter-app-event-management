import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursach_app/core/enums/update_user_action.dart';
import 'package:cursach_app/core/errors/exceptions.dart';
import 'package:cursach_app/core/utils/constants.dart';
import 'package:cursach_app/core/utils/typedefs.dart';
import 'package:cursach_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cursach_app/src/auth/data/models/local_user_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireBaseAuth extends Mock implements FirebaseAuth {}

class MockAuthCredential extends Mock implements AuthCredential {}

class MockUser extends Mock implements User {
  String _uid = 'testId';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;

  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late UserCredential userCredential;
  late MockUser mockUser;
  late DocumentReference<DataMap> documentReference;
  const tUser = LocalUserModel.empty();

  setUpAll(() async {
    authClient = MockFireBaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    dbClient = MockFirebaseStorage();

    documentReference = cloudStoreClient.collection('users').doc();
    await documentReference
        .set(tUser.copyWith(uid: documentReference.id).toMap());
    mockUser = MockUser()..uid = documentReference.id;
    userCredential = MockUserCredential(mockUser);

    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );

    when(() => authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'tPassword';
  const tFullName = 'tFullName';
  const tEmail = 'tEmail';

  final tFireBaseAuthException = FirebaseAuthException(
    code: 'tCode',
    message: 'tMessage',
  );

  group(
    'resetPassword',
    () {
      test(
        'should complete successfully when no [Exception] is thrown',
        () async {
          when(
            () => authClient.sendPasswordResetEmail(
              email: any(named: 'email'),
            ),
          ).thenAnswer((_) async => Future.value());

          final call = dataSource.resetPassword(tEmail);

          expect(call, completes);

          verify(() => authClient.sendPasswordResetEmail(email: tEmail))
              .called(1);
          verifyNoMoreInteractions(authClient);
        },
      );

      test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
          when(
            () => authClient.sendPasswordResetEmail(
              email: any(named: 'email'),
            ),
          ).thenThrow(tFireBaseAuthException);

          final call = dataSource.resetPassword;

          expect(() => call(tEmail), throwsA(isA<ServerException>()));
          verify(() => authClient.sendPasswordResetEmail(email: tEmail))
              .called(1);
          verifyNoMoreInteractions(authClient);
        },
      );
    },
  );

  group(
    'signIn',
    () {
      test('should return [LocalUserModel] when no [Exception] is thrown',
          () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((invocation) async => userCredential);

        final result = await dataSource.signIn(
          email: tEmail,
          password: tPassword,
        );

        expect(result.uid, equals(userCredential.user!.uid));

        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      });

      test(
        'should throw [ServerException] when user is null after signIn',
        () async {
          final emptyUserCredential = MockUserCredential();
          when(
            () => authClient.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((invocation) async => emptyUserCredential);

          final call = dataSource.signIn;

          expect(
            () => call(email: tEmail, password: tPassword),
            throwsA(isA<ServerException>()),
          );

          verify(
            () => authClient.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(authClient);
        },
      );

      test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
          when(
            () => authClient.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(tFireBaseAuthException);

          final call = dataSource.signIn;

          expect(
            () => call(email: tEmail, password: tPassword),
            throwsA(isA<ServerException>()),
          );

          verify(
            () => authClient.signInWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
          verifyNoMoreInteractions(authClient);
        },
      );
    },
  );

  group(
    'signUp',
    () {
      test(
        'should complete successfully when no [Exception] is thrown',
        () async {
          when(
            () => authClient.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(
                named: 'password',
              ),
            ),
          ).thenAnswer((invocation) async => userCredential);

          when(() => userCredential.user?.updateDisplayName(any()))
              .thenAnswer((invocation) async => Future.value());

          when(() => userCredential.user?.updatePhotoURL(any()))
              .thenAnswer((invocation) async => Future.value());

          final call = dataSource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          );

          expect(call, completes);

          verify(
            () => authClient.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);

          await untilCalled(
            () => userCredential.user?.updateDisplayName(any()),
          );

          verify(() => userCredential.user?.updateDisplayName(tFullName))
              .called(1);

          await untilCalled(() => userCredential.user?.updatePhotoURL(any()));

          verify(() => userCredential.user?.updatePhotoURL(kDefaultAvatar))
              .called(1);

          verifyNoMoreInteractions(authClient);
        },
      );

      test(
        'should throw [ServerException] when [FirebaseAuthException] is thrown',
        () async {
          when(
            () => authClient.createUserWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenThrow(tFireBaseAuthException);

          final call = dataSource.signUp;

          expect(
            () => call(
              email: tEmail,
              password: tPassword,
              fullName: tFullName,
            ),
            throwsA(isA<ServerException>()),
          );

          verify(
            () => authClient.createUserWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'updateUser',
    () {
      setUp(() {
        registerFallbackValue(MockAuthCredential());
      });

      test(
        'should update user displayName successfully when no [Exception]',
        () async {
          when(() => mockUser.updateDisplayName(any()))
              .thenAnswer((invocation) async => Future.value());

          await dataSource.updateUser(
            action: UpdateUserAction.displayName,
            userData: tFullName,
          );

          verify(() => mockUser.updateDisplayName(tFullName)).called(1);

          verifyNever(() => mockUser.updatePassword(any()));
          verifyNever(() => mockUser.updatePhotoURL(any()));
          verifyNever(() => mockUser.updateEmail(any()));

          final user = await cloudStoreClient
              .collection('users')
              .doc(mockUser.uid)
              .get();

          expect(user.data()!['fullName'], tFullName);
        },
      );

      test(
        'should update user email successfully when no [Exception]',
        () async {
          when(() => mockUser.updateEmail(any()))
              .thenAnswer((invocation) async => Future.value());

          await dataSource.updateUser(
            action: UpdateUserAction.email,
            userData: tEmail,
          );

          verify(() => mockUser.updateEmail(tEmail)).called(1);

          verifyNever(() => mockUser.updatePassword(any()));
          verifyNever(() => mockUser.updatePhotoURL(any()));
          verifyNever(() => mockUser.updateDisplayName(any()));

          final user = await cloudStoreClient
              .collection('users')
              .doc(mockUser.uid)
              .get();

          expect(user.data()!['email'], tEmail);
        },
      );

      test(
        'should udpate user password successfully when no [Exception]',
        () async {
          when(() => mockUser.updatePassword(any()))
              .thenAnswer((invocation) async => Future.value());

          when(() => mockUser.reauthenticateWithCredential(any()))
              .thenAnswer((invocation) async => userCredential);

          when(() => mockUser.email).thenReturn(tEmail);

          await dataSource.updateUser(
            action: UpdateUserAction.password,
            userData: jsonEncode(
              {
                'oldPassword': 'oldPassword',
                'newPassword': tPassword,
              },
            ),
          );

          verify(() => mockUser.updatePassword(tPassword));

          verifyNever(() => mockUser.updateEmail(any()));
          verifyNever(() => mockUser.updatePhotoURL(any()));
          verifyNever(() => mockUser.updateDisplayName(any()));

          final user = await cloudStoreClient
              .collection('users')
              .doc(documentReference.id)
              .get();

          expect(user.data()!['password'], null);
        },
      );

      test(
        'should update user profilePic successfully when no [Exception]',
        () async {
          final newProfilePic = File('assets/images/default_background.jpg');

          when(() => mockUser.updatePhotoURL(any()))
              .thenAnswer((invocation) async => Future.value());

          await dataSource.updateUser(
            action: UpdateUserAction.profilepic,
            userData: newProfilePic,
          );

          verify(() => mockUser.updatePhotoURL(any())).called(1);

          verifyNever(() => mockUser.updateEmail(any()));
          verifyNever(() => mockUser.updatePassword(any()));
          verifyNever(() => mockUser.updateDisplayName(any()));

          expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
        },
      );
    },
  );
}
