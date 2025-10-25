import '../models/entities/user_model.dart';
import '../models/entities/program_model.dart';
import '../models/entities/achievements_model.dart';
import './base_controller.dart';

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
  import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/entities/user_model.dart';
import '../models/entities/program_model.dart';
import '../models/entities/achievements_model.dart';
import './base_controller.dart';
// ...existing code...
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
    await handleAsync(() async {
      // small delay for UX parity
      await Future.delayed(const Duration(milliseconds: 300));

      try {
        final usersJson = await rootBundle.loadString('assets/data/users.json');
        final programsJson = await rootBundle.loadString('assets/data/programs.json');

        final dynamic usersDecoded = json.decode(usersJson);
        final List<dynamic> usersList = usersDecoded is List
            ? usersDecoded
            : (usersDecoded is Map && usersDecoded['users'] is List
                ? usersDecoded['users'] as List
                : <dynamic>[]);

        if (usersList.isNotEmpty) {
          final Map<String, dynamic> firstUser =
              Map<String, dynamic>.from(usersList.first as Map);
          _user = UserModel.fromJson(firstUser);
        } else {
          // fallback dummy user
          _user = UserModel(
            id: 'user-001',
            name: 'Sarah',
            email: 'sarah.j@example.com',
            avatar: 'https://i.pravatar.cc/150?u=sarah',
            role: 'student',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }

        final dynamic programsDecoded = json.decode(programsJson);
        final List<dynamic> programsList = programsDecoded is List
            ? programsDecoded
            : (programsDecoded is Map && programsDecoded['programs'] is List
                ? programsDecoded['programs'] as List
                : <dynamic>[]);

        _experiences = programsList
            .map((e) => ProgramModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();

        // defaults for favorites/upcoming
        _favorites = _experiences.take(3).toList();
        _upcoming = _experiences.length >= 4
            ? _experiences.sublist(1, 4)
            : _experiences.reversed.take(3).toList();

        // default achievements u 
        _achievements = const AchievementsModel(
          enrolled: 10,
          completed: 6,
          badges: 4,
        );
      } catch (_) {
        // On any failure, keep previous in-memory dummy data
        _user ??= UserModel(
          id: 'user-001',
          name: 'Sarah',
          email: 'sarah.j@example.com',
          avatar: 'https://i.pravatar.cc/150?u=sarah',
          role: 'student',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        _achievements ??= const AchievementsModel(
          enrolled: 10,
          completed: 6,
          badges: 4,
        );

        if (_experiences.isEmpty) {
          final program1 = ProgramModel(
            id: 'prog-101',
            title: 'Machine Learning',
            description: '',
            category: 'Data Science',
            duration: '12 Weeks',
            level: 'Intermediate',
            instructorId: 'inst-201',
            instructorName: 'St. Louis University',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final program2 = ProgramModel(
            id: 'prog-202',
            title: 'Project Manage..',
            description: '',
            category: 'Business',
            duration: '8 Weeks',
            level: 'Beginner',
            instructorId: 'inst-202',
            instructorName: 'St. Louis University',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final program3 = ProgramModel(
            id: 'prog-303',
            title: 'App Development',
            description: '',
            category: 'Mobile',
            duration: '10 Weeks',
            level: 'Beginner',
            instructorId: 'inst-303',
            instructorName: 'Excelerate Inst.',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          final program4 = ProgramModel(
            id: 'prog-404',
            title: 'Graphic Design',
            description: '',
            category: 'Design',
            duration: '6 Weeks',
            level: 'Intermediate',
            instructorId: 'inst-404',
            instructorName: 'Design School',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          _experiences = [program1, program2, program3, program4];
          _favorites = [program4, program2, program1, program3];
          _upcoming = [program3, program1, program4, program2];
        }
      }
    });
  }
}
      // --- Updated Lists with More Data ---
      _experiences = [program1, program2, program3, program4];
      _favorites = [program4, program2, program1, program3];
      _upcoming = [program3, program1, program4, program2];
    });
  }
}
