import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return LoadingIndicator(
        indicatorType: Indicator.orbit,
        colors: const [Colors.white, Colors.yellow],
        strokeWidth: 2,
        backgroundColor: Color(0xFF002d56),
        pathBackgroundColor: Colors.black
    );
  }
}
