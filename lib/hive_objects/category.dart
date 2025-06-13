import 'package:hive_flutter/hive_flutter.dart';

part 'category.g.dart';

@HiveType(typeId: 1, adapterName: "CategoryAdapter")
class Category extends HiveObject {
  @HiveField(0)
  String name;

  Category(this.name);
}