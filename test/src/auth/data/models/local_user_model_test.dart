import 'dart:convert';

import 'package:cursach_app/core/utils/typedefs.dart';
import 'package:cursach_app/src/auth/data/models/local_user_model.dart';
import 'package:cursach_app/src/auth/domain/entities/local_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  late DataMap tMap;
  const tLocalUserModel = LocalUserModel.empty();

  setUp(
    () => {tMap = jsonDecode(fixture('local_user.json')) as DataMap},
  );

  group('LocalUserModel', () {
    test('should be subclass of [LocalUser]', () async {
      expect(tLocalUserModel, isA<LocalUser>());
    });

    group('from map', () {
      test('should return correct [LocalUserModel] from json file map', () {
        final result = LocalUserModel.fromMap(tMap);

        expect(result, isA<LocalUserModel>());
        expect(result, equals(tLocalUserModel));
      });

      test('should throw an [Error] when map is invalid', () {
        final map = tMap..remove('uid');

        const call = LocalUserModel.fromMap;

        expect(() => call(map), throwsA(isA<Error>()));
      });
    });

    group('to map', () {
      test('should return correct [DataMap] from LocalUserModel', () {
        final result = tLocalUserModel.toMap();
        expect(result, equals(tMap));
      });
    });

    group('copy with', () {
      test('should return [LocalUserModel] with updated values', () {
        final result = tLocalUserModel.copyWith(uid: '0');
        expect(result.uid, '0');
      });
    });
  });
}
