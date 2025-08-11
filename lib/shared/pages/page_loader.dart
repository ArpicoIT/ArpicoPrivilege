import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PageLoader extends StatelessWidget {
  const PageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Material(
        type: MaterialType.canvas,
        child: Center(
          child: SizedBox.square(
            dimension: (size.width*0.16), // 72
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: SpinKitWave(
                  // color: colorScheme.primary,
                  size: size.width*0.06, // 24
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? colorScheme.primary : colorScheme.primary.withAlpha(200),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
