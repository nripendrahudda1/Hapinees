import 'package:dio/dio.dart';

double? dheight;
double? dwidth;
double topSfarea = 0;
double bottomSfarea = 0;
bool isFirst = false;
String? fcmtoken;
late final datePattern;
final dio = Dio(BaseOptions(
  validateStatus: (status) {
    return true;
  },
));

class AppConst {
  static const int bounceDuration = 150;
}

// dio.options.headers["Authorization"] =
//                       "Bearer " + value['data']['token'],