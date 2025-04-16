import 'package:flutter/material.dart';
import 'package:projet_flutter/models/category.dart';
import 'package:projet_flutter/widgets/quiz_options.dart';

class HomePage extends StatelessWidget {
  final List<Color> tileColors = [
    Color(0xFFA8DADC),
    Color(0xFFBFD8B8),
    Color(0xFFFFD6A5),
    Color(0xFFE2ECE9),
    Color(0xFFF4A261),
    Color(0xFFFAF3DD),
    Color(0xFFB5EAD7),
    Color(0xFFFAD2E1),
    Color(0xFFF8EDEB),
    Color(0xFFC7CEEA),
  ];

  final List<QuizCategory> categories = [
    QuizCategory(9, "Geography", icon: getCategoryIcon(9)),
    QuizCategory(11, "Films", icon: getCategoryIcon(11)),
    QuizCategory(12, "Music", icon: getCategoryIcon(12)),
    QuizCategory(15, "Video Games", icon: getCategoryIcon(15)),
    QuizCategory(17, "Science", icon: getCategoryIcon(17)),
    QuizCategory(18, "Computers", icon: getCategoryIcon(18)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      drawer: Drawer(

      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mindly',
              style: TextStyle(
                color: Color(0xFF3A6351),
                fontWeight: FontWeight.w900,
                fontSize: 28,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.auto_awesome,
              color: Color(0xFF3A6351),
              size: 22,
            ),
          ],
        ),
      ),
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding:
                EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: Center(
                  child: Text(
                    "Pick a topic you love ",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding:   EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 1000
                      ? 6
                      : MediaQuery.of(context).size.width > 600
                          ? 4
                          : 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  _buildQuizCategoryItem,
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCategoryItem(BuildContext context, int index) {
    final quizCategory = categories[index];
    final bgColor = Color(0xFFE2ECE9);

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () => _QuizCategoryPressed(context, quizCategory),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (quizCategory.icon != null)
                Icon(
                  quizCategory.icon,
                  color: Colors.black45,
                  size: 40,
                ),
              SizedBox(height: 12),
              Text(
                quizCategory.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _QuizCategoryPressed(BuildContext context, QuizCategory category) {
    showDialog(
      context: context,
      builder: (sheetContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: QuizOptionsDialog(category: category),
      ),
    );
  }
}
