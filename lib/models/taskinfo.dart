//import 'package:flutter_downloader/flutter_downloader.dart';

class TaskInformation {
  String? name;
  String? link;
  String? filepath;
  String? taskId;
  int? progress = 0;
  //DownloadTaskStatus? status = DownloadTaskStatus.undefined;

  TaskInformation({this.name, this.link, this.filepath,
   // this.status,
    this.taskId,this.progress});
}