import 'package:flutter/foundation.dart';
import '../models/entities/user_model.dart';
import '../models/entities/program_model.dart';
import '../models/entities/achievements_model.dart';
import './base_controller.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class HomeController extends BaseController {
  UserModel? _user;
  AchievementsModel? _achievements;
  List<ProgramModel> _experiences = [];
  List<ProgramModel> _favorites = [];
  List<ProgramModel> _upcoming = [];

  UserModel? get user => _user;
  AchievementsModel? get achievements => _achievements;
  List<ProgramModel> get experiences => _experiences;
  List<ProgramModel> get favorites => _favorites;
  List<ProgramModel> get upcoming => _upcoming;

  HomeController() {
    fetchHomePageData();
  }

  
  Future<void> fetchHomePageData() async {
    try {
      // Simulate delay (optional)
      await Future.delayed(const Duration(seconds: 1));
       if (kDebugMode) {
         print('\n Fetching home page data...');
       }
      // Load user from JSON
      final userJson = await rootBundle.loadString('assets/data/users.json');
      final List<dynamic> userList = json.decode(userJson);
      if (kDebugMode) {
        print('Total users found: ${userList.length}');
      }
      _user = UserModel.fromJson(
        userList.firstWhere(
          (user) => user['id'] == 'user-001',
          orElse: () => userList.first,
        ),
      );
      if (kDebugMode) {
        print(' Logged-in User: ${_user!.name}');
      }

      // Load achievements (can be static for now)
      _achievements = const AchievementsModel(
        enrolled: 10,
        completed: 6,
        badges: 4,
      );

      // Load program list
      if (kDebugMode) {
        print('Loading programs data from assets/data/programs.json...');
      }
      final programJson = await rootBundle.loadString(
        'assets/data/programs.json',
      );
      final programList = json.decode(programJson) as List<dynamic>;
      List<ProgramModel> programs = programList
          .map((e) => ProgramModel.fromJson(e))
          .toList();
    // Print each program’s details
    for (var program in programs) {
      if (kDebugMode) {
        print(' Program ID: ${program.id}');
      }
      if (kDebugMode) {
        print('   Title: ${program.title}');
      }
      if (kDebugMode) {
        print('   Category: ${program.category}');
      }
      if (kDebugMode) {
        print('   Level: ${program.level}');
      }
      if (kDebugMode) {
        print('   Duration: ${program.duration}');
      }
      if (kDebugMode) {
        print('   Rating: ${program.rating}');
      }
      if (kDebugMode) {
        print('   Instructor: ${program.instructorName}');
      }
      if (kDebugMode) {
        print('---------------------------------------------');
      }
    }
      // --- Updated Lists with More Data ---
      if (programs.length >= 4) {
        final program1 = programs[0];
        final program2 = programs[1];
        final program3 = programs[2];
        final program4 = programs[3];

        _experiences = [program1, program2, program3, program4];
        _favorites = [program4, program2, program1, program3];
        _upcoming = [program3, program1, program4, program2];
      } else {
        _experiences = programs;
        _favorites = programs;
        _upcoming = programs;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching home data: $e');
      }
      rethrow;
    }
  }
}
