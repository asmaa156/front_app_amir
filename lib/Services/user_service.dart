import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:amir/models/user_model.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:amir/Services/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class UserController {
  List<UsersModel> results = [];
  final _storage = const FlutterSecureStorage();
  Future<List<UsersModel>> getAllUsers() async {
  Dio.Response response = await dio().get('/users');

   
    if (response.statusCode == 200) {
 
      return userFromJson(response.data["data"]);
    } else {
      throw Exception("failed");
    }
  }

  Stream<List<UsersModel?>?> getUserData(Duration refreshTime) async* {
    String? tokens = await _storage.read(key: 'token');
    if (tokens != null) {
      while (true) {
        await Future.delayed(refreshTime);
        yield await getAllUsers();
      }
    }
  }

  Future deleteUser(String id) async {
    try {
      Dio.Response response = await dio().delete('/users/$id');
      if (response.statusCode == 204) {
        Get.snackbar("success", "utilisateur a étes suprimer",
            backgroundColor: Colors.green, colorText: Colors.white);
        //return true;
      } else {
        Get.snackbar("erruer", "il y a un probleme");
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
