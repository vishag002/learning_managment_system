import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_managment_system/api_service/subject_view_api_service.dart';
import 'package:learning_managment_system/model/subject_views_model.dart';
import 'package:learning_managment_system/utilis/color_const.dart';
import 'package:learning_managment_system/utilis/text_style_const.dart';
import 'package:learning_managment_system/view/module_content_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SubjectViewScreen extends StatefulWidget {
  final String subjectname;
  final String subjectDescription;
  final String imageUrl;
  const SubjectViewScreen({
    super.key,
    required this.subjectname,
    required this.subjectDescription,
    required this.imageUrl,
  });
  @override
  State<SubjectViewScreen> createState() => _SubjectViewScreenState();
}

class _SubjectViewScreenState extends State<SubjectViewScreen> {
  late Future<List<SubjectsViewModel>> _moduleList;

  @override
  void initState() {
    super.initState();
    _moduleList = SubjectViewApiService().getSubjectModules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.subjectname), centerTitle: false
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            subjectBanner(context: context, imageUrl: widget.imageUrl),
            const SizedBox(height: 30),
            subjectText(
              subjectName: widget.subjectname,
              subjectDescription: widget.subjectDescription,
            ),
            const SizedBox(height: 30),

            Text("Modules", style: AppTextStyles.headingStyle),
            const SizedBox(height: 0),

            Expanded(
              child: FutureBuilder(
                future: _moduleList,
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
                        child: Container(color: Colors.transparent),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  } else {
                    final modules = snapshot.data!;
                    return ListView.builder(
                      itemCount: modules.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => ModuleContentScreen(),
                              transition: Transition.cupertino,
                            );
                          },

                          child: modulesCard(
                            title: modules[index].subjectsModuleTitle,
                            subTitle: modules[index].subjectsModuleDescription,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget subjectBanner({context, imageUrl}) {
  return Container(
    // margin: EdgeInsets.all(20),
    height: MediaQuery.of(context).size.height * 0.2,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(30),
      image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
    ),
  );
}

Widget subjectText({subjectName, subjectDescription}) {
  return SizedBox(
    // /height: 50,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(subjectName, style: AppTextStyles.mainHeading),
        Text(
          subjectDescription,
          style: AppTextStyles.mainHeading,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget modulesCard({title, subTitle}) {
  return Card(
    child: ListTile(
      title: Text(title, style: AppTextStyles.subHeadingStyle),
      subtitle: Text(subTitle, style: AppTextStyles.bodyStyle),
    ),
  );
}
