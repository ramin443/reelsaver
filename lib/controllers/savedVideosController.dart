import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dbhelpers/SavedVideosDBHelper.dart';
import '../models/SavedVideos.dart';

class SavedVideosController extends GetxController{
  final dbHelper = SavedVideosDatabaseHelper();

  Widget savedvideoslist(BuildContext context){
    return FutureBuilder<List<SavedVideos>>(
      future: dbHelper.getAllVideos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final videos = snapshot.data!;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                title: Text(video.caption),
                subtitle: Text(video.url),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}