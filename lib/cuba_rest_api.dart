library cubarestapi;

import 'dart:developer';

import 'package:cubarestapi/models/base_entity.dart';
import 'package:cubarestapi/repository/request/entities.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class CubaRestApi {
  static final hiveCredsBox = 'credsBox';
  static final hiveCredentials = 'credentials';
  static final hiveUsername = 'username';

  static String baseUrl = 'http://localhost:8080/app';
  static String identifier = 'client';
  static String secret = 'secret';
  static String logoutUrl = 'http://localhost:8080/app-portal/api/logout';

  static Future<oauth2.Client> getAuthToken(
      String username, String password) async {
    final oauthTokenEndpoint = Uri.parse(baseUrl + '/rest/v2/oauth/token?');
    oauth2.Client client = await oauth2.resourceOwnerPasswordGrant(
        oauthTokenEndpoint, username, password,
        identifier: identifier, secret: secret);
    final box = await Hive.openBox(hiveCredsBox);
    box.put(hiveCredentials, client.credentials.toJson());
    box.put(username, client.credentials.toJson());
    return client;
  }

  static Future<dynamic> getEntities(String entityName,
      {String view, int limit, int offset, String sort}) async {
    final getSpeakersEndpoint = '/rest/v2/entities/$entityName';
    final Box<dynamic> box = await _getBox(hiveCredsBox);
    final token =
        oauth2.Credentials.fromJson(box.get(hiveCredentials)).accessToken;
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    final requestDto = Entities(
      view: view,
      limit: limit,
      offset: offset,
      sort: sort,
    );
    log('Sending request to ${baseUrl + getSpeakersEndpoint}');
    Response response = await dio.get(
      baseUrl + getSpeakersEndpoint,
      queryParameters: requestDto.toMap(),
    );
    log('Got response from ${baseUrl + getSpeakersEndpoint}: ${response.data}');
    return response.data;
  }

  static Future<dynamic> createEntity(
      String entityName, Map<String, dynamic> map) async {
    final createEndpoint = '/rest/v2/entities/$entityName';
    final Box<dynamic> box = await _getBox(hiveCredsBox);
    final token =
        oauth2.Credentials.fromJson(box.get(hiveCredentials)).accessToken;
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    log('Sending request to ${baseUrl + createEndpoint}');
    Response response = await dio.post(
      baseUrl + createEndpoint,
      data: map,
    );
    log('Got response from ${baseUrl + createEndpoint}: ${response.data}');
    return response.data;
  }

  static Future<dynamic> editEntity(
      String entityName, BaseEntity entity) async {
    final editEndpoint = '/rest/v2/entities/$entityName/${entity.id}';
    final Box<dynamic> box = await _getBox(hiveCredsBox);
    final token =
        oauth2.Credentials.fromJson(box.get(hiveCredentials)).accessToken;
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    log('Sending request to ${baseUrl + editEndpoint}');
    Response response = await dio.put(
      baseUrl + editEndpoint,
      data: entity.toMap(),
    );
    log('Got response from ${baseUrl + editEndpoint}: ${response.data}');
    return response.data;
  }

  static Future<dynamic> logOut() async {
    final Box<dynamic> box = await _getBox(hiveCredsBox);
    final token =
        oauth2.Credentials.fromJson(box.get(hiveCredentials)).accessToken;
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    log('Sending request to $logoutUrl');
    Response response = await dio.post(
      logoutUrl,
      data: {'session': token},
    );
    log('Got response from $logoutUrl: ${response.data}');
    return response.data;
  }

  static _getBox(String name) async =>
      Hive.isBoxOpen(name) ? Hive.box(name) : await Hive.openBox(name);
}
