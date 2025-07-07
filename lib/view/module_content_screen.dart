import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_managment_system/api_service/modules_view_api_service.dart';
import 'package:learning_managment_system/model/modules_content_model.dart';
import 'package:learning_managment_system/utilis/text_style_const.dart';
import 'package:learning_managment_system/view/vimeo_video_player_screen.dart';
import 'package:learning_managment_system/view/you_tube_video_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ModuleContentScreen extends StatefulWidget {
  const ModuleContentScreen({super.key});

  @override
  State<ModuleContentScreen> createState() => _ModuleContentScreenState();
}

class _ModuleContentScreenState extends State<ModuleContentScreen> {
  late Future<List<ModulesViewModel>> _modules;
  @override
  void initState() {
    super.initState();
    _modules = ModulesApiService().getModulesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modules", style: AppTextStyles.mainHeading)),
      body: FutureBuilder(
        future: _modules,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Shimmer(
                duration: Duration(seconds: 3), //Default value
                interval: Duration(
                  seconds: 5,
                ), //Default value: Duration(seconds: 0)
                color: Colors.white, //Default value
                colorOpacity: 1, //Default value
                enabled: true, //Default value
                direction: ShimmerDirection.fromLTRB(), //Default Value
                child: Container(color: Colors.grey.shade50),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          } else {
            final modulesContent = snapshot.data!;
            return ListView.builder(
              itemCount: modulesContent.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    if (modulesContent[index].videoType == 'YouTube') {
                      Get.to(
                        () => PlayVideoFromYoutube(
                          url: modulesContent[index].videoUrl,
                        ),
                        transition: Transition.cupertino,
                      );
                    } else {
                      Get.to(
                        () => VimeoVideoViewer(),
                        transition: Transition.cupertino,
                      );
                    }
                  },
                  child: modulesContentCard(
                    title: modulesContent[index].moduleTitle,
                    subTitle: modulesContent[index].moduleDescription,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

Widget modulesContentCard({title, subTitle}) {
  return Card(
    child: ListTile(
      leading: Icon(Icons.play_arrow),
      title: Text(title, style: AppTextStyles.subHeadingStyle),
      subtitle: Text(subTitle, style: AppTextStyles.bodyStyle),
    ),
  );
}
