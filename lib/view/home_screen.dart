import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_managment_system/api_service/subject_api_service.dart';
import 'package:learning_managment_system/model/subject_model.dart';
import 'package:learning_managment_system/utilis/text_style_const.dart';
import 'package:learning_managment_system/view/subject_view_screen.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<SubjectModel>> _subjectList;
  @override
  void initState() {
    super.initState();
    _subjectList = SubjectApiService().getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LMS_APP", style: AppTextStyles.mainHeading),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://www.shutterstock.com/image-vector/elearning-concept-laptop-book-on-260nw-1035367822.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                  //  color: AppColors.primaryLight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                "Popular Subjects",
                style: AppTextStyles.headingStyle,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _subjectList,
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
                    final subjects = snapshot.data!;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.25,
                            crossAxisSpacing: 0,
                          ),
                      itemCount: subjects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => SubjectViewScreen(
                                subjectname: subjects[index].subjectTitle,
                                subjectDescription:
                                    subjects[index].subjectDescription,
                                imageUrl: subjects[index].subjectImageUrl,
                              ),
                              transition: Transition.cupertino,
                            );
                          },
                          child: subjectListingWidget(
                            context: context,
                            subjectImageUrl: subjects[index].subjectImageUrl,
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

//
Widget subjectListingWidget({context, subjectImageUrl}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      // height: MediaQuery.of(context).size.height * 0.2,
      //width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        //  color: AppColors.primaryLight,
        image: DecorationImage(
          image: NetworkImage(subjectImageUrl),
          fit: BoxFit.scaleDown,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  );
}
