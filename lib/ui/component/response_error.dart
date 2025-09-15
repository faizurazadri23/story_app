import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResponseError extends StatelessWidget {
  final String message;

  const ResponseError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/img_response_failed.svg', width: 150),
        SizedBox(height: 10),
        Text(message, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
