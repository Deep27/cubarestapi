import 'package:cubarestapi/cuba_rest_api.dart';
import 'package:test/test.dart';

void main() {
  test('Successfull authorization', () async {
    final client = await CubaRestApi.getAuthToken('lab', '2');
    expect(client, isNot((equals(null))));
  });
}
