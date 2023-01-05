import 'package:hive_flutter/adapters.dart';

part 'employeesData.g.dart';

@HiveType(typeId: 0)
class Employeedata {
  Employeedata({
    this.liveLati,
    this.liveLong,
    this.loginTime,
    this.logoutTime,
    this.latides,
    this.longdes,
    this.status,
    this.latisrc,
    this.longsrc,
  });

  @HiveField(0)
  double? liveLati;

  @HiveField(1)
  double? liveLong;

  @HiveField(2)
  String? loginTime;

  @HiveField(3)
  String? logoutTime;

  @HiveField(4)
  double? latides;

  @HiveField(5)
  double? longdes;

  @HiveField(6)
  int? status;

  @HiveField(7)
  double? latisrc;

  @HiveField(8)
  double? longsrc;
}
