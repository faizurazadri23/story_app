import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResponseNoItem extends StatelessWidget {
  final String message;

  const ResponseNoItem({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/img_empty_data_item.svg', width: 150),
        SizedBox(height: 10),
        Text(message, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
