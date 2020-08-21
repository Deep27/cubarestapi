import 'package:cubarestapi/cuba_rest_api.dart';
import 'package:test/test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

void main() {
  test('Successfull authorization', () async {
    await Hive.initFlutter();
    final client = await CubaRestApi.getAuthToken('lab', '2');
    expect(client, isNot((equals(null))));
  });
}
