
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DirectoryUtil {

  //创建文件夹
  Future createDir(String dirName) async {
    String path = await getDirPath(dirName);
    var dir = Directory(path);
    var exist = dir.existsSync();
    if (exist) {
      print('当前文件夹已存在');
    } else {
      var result = await dir.create(recursive: false);
      print('$result');
    }
  }

  Future getDirPath (String dirName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return dirName == 'emojiManager'
        ? '${documentsDirectory.path}${Platform.pathSeparator}$dirName'
        : '${documentsDirectory.path}${Platform.pathSeparator}'+"emojiManager"+'${Platform.pathSeparator}$dirName';
  }

  //遍历文件夹下文件
  Future dirList(String dirName) async {
    String path = await getDirPath(dirName);
    Stream<FileSystemEntity> fileList = Directory(path).list(recursive: false);
    await for (FileSystemEntity fileSystemEntity in fileList) {
      print('......');
      print('$fileSystemEntity');
      FileSystemEntityType type = FileSystemEntity.typeSync(fileSystemEntity.path);
      print(type);
    }
  }

  //文件夹重命名
  Future dirRename(String oldName, String newName) async {
    String path = await getDirPath(oldName);
    var dir = Directory(path);
    var dir3= await dir.rename('${dir.parent.absolute.path}${Platform.pathSeparator}$newName');
    print(dir3);
  }

  //文件夹删除
Future deleteDir(String dirName) async {
  String path = await getDirPath(dirName);
  await Directory(path).delete();
  print('delete');
  }


}