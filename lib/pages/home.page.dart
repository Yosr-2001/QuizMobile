import 'package:flutter/material.dart';
import 'package:projet_flutter/models/category.dart';
import 'package:projet_flutter/widgets/quiz_options.dart';



class HomePage extends StatelessWidget {
  final List<Color> tileColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.brown
  ];

  final List<QuizCategory> categories = [
    QuizCategory(9, "Geography", icon: getCategoryIcon(9)),
    //QuizCategory(10, "Books", icon: getCategoryIcon(10)),
    QuizCategory(11, "Films", icon: getCategoryIcon(11)),
    QuizCategory(12, "Music", icon: getCategoryIcon(12)),
    //QuizCategory(13, "Theatre", icon: getCategoryIcon(13)),
    //QuizCategory(14, "Television", icon: getCategoryIcon(14)),
    QuizCategory(15, "Video Games", icon: getCategoryIcon(15)),
    //QuizCategory(16, "Board Games", icon: getCategoryIcon(16)),
    QuizCategory(17, "Science", icon: getCategoryIcon(17)),
    QuizCategory(18, "Computers", icon: getCategoryIcon(18)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Quizer',
              style:
              TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 40.0),
                  child: Text(
                    "Select a QuizCategory to start the quiz",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 30.0),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1000
                            ? 7
                            : MediaQuery.of(context).size.width > 600
                            ? 5
                            : 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0),
                    delegate: SliverChildBuilderDelegate(
                      _buildQuizCategoryItem,
                      childCount: categories.length,
                    )),
              ),
            ],
          ),
        ));
  }

  Widget _buildQuizCategoryItem(BuildContext context, int index) {
    QuizCategory quizCategory = categories[index];
    return MaterialButton(
      elevation: 0.0,
      highlightElevation: 1.0,
      onPressed: () => _QuizCategoryPressed(context, quizCategory),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      textColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (quizCategory.icon != null) Icon(quizCategory.icon),
          if (quizCategory.icon != null) SizedBox(height: 5.0),
          Text(
            quizCategory .name,
            textAlign: TextAlign.center,
            maxLines: 3,
            style:
            TextStyle(color: Colors.black.withOpacity(.7), fontSize: 16),
          ),
        ],
      ),
    );
  }

  _QuizCategoryPressed(BuildContext context, QuizCategory category) {
    showDialog(
      context: context,
      builder: (sheetContext) => Dialog(
        child: QuizOptionsDialog(
          category: category,
        ),
      ),
    );
  }
}
