import 'dart:async';
import 'package:dio/dio.dart';


class Version{
  late String versionId;
  late String apkUrl;
  late String updateDescription;
  Version.fromJson(Map<String, dynamic> jsonMap) {
    versionId = jsonMap['versionId'] ?? 0;
    apkUrl = jsonMap['apkUrl'] ?? '';
    updateDescription = jsonMap['updateDescription'] ?? '';
  }
}



///检查更新接口
   String server = "http://49.232.26.214:8888";
class UpdateAPI {
  static final String _updateUrl = '$server/updating';

  static Future<Version?> checkUpdate(String versionId) async {
      try {
        Response response = await Dio().post(
            _updateUrl,
            queryParameters: {
              'VersionId': versionId,
            },
            options: Options(
              sendTimeout: 500,
              receiveTimeout: 500,
            )
        );
        if (response.data != null) {
          return Version.fromJson(response.data);
        }
      } catch (ignore) {}
    return null;
  }
}