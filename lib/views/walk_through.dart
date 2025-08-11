import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({super.key});

  @override
  State<WalkThrough> createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  int currentPage = 0;
  final pageController = PageController(initialPage: 0);

  List<Widget> screens = [
    const Text("Page 1"),
    const Text("Page 2"),
    const Text("Page 3"),
    const Text("Page 4"),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;

    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          ),
          backgroundColor: Colors.transparent
          // shape: OvalBorder(
          //   eccentricity: 1
          // )
        )
      ),
      child: Scaffold(
          body: SizedBox(
            height: screenSize.height,
            child: LayoutBuilder(builder: (context, constraints) {
              return ExpandablePageView.builder(
                itemCount: screens.length,
                itemBuilder: (context, index) {
                  return Container(
                      // color: Colors.blue,
                      height: constraints.maxHeight,
                      alignment: Alignment.center,
                      child: screens[index]);
                },
                controller: pageController,
                onPageChanged: (i) {
                  setState(() {
                    currentPage = i;
                  });
                },
              );
            }),
          ),
          bottomSheet: Container(
            color: Colors.green.withOpacity(0.1),
            child: ClipPath(
              // clipper: BottomWaveClipper(),
              child: SizedBox(
                height: 72.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if(currentPage != 0)
                          TextButton(
                              onPressed: () => pageController.previousPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOutCubic),
                              child: const Text("Back")
                          )
                        else
                          const SizedBox.shrink(),
                        if(currentPage != screens.length-1)
                          TextButton(
                              onPressed: () => pageController.jumpToPage(screens.length - 1),
                              child: const Text("Skip")
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                    buildDots(currentPage, screens.length),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget buildDots(int index, int length) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i in Iterable.generate(length))
          if (index == i)
            const Icon(Icons.circle, size: 16, color: Colors.blue)
          else
            Icon(Icons.circle, size: 10, color: Colors.grey.withOpacity(0.5))
      ],
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    // Start the path from the bottom left
    path.lineTo(0.0, size.height - 100);

    // Create a curved wave at the bottom
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    // Complete the path by drawing to the top right corner and closing the path
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
