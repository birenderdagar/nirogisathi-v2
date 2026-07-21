import '../../domain/entities/home_entity.dart';

class HomeModel {
  final String title;

  HomeModel({required this.title});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }

  HomeEntity toEntity() {
    return HomeEntity(title: title);
  }
}