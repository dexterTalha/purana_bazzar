import 'package:flutter/material.dart';

class CategoryBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 180,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: Image.asset("assets/png/otp_icon.png", height: 80, width: 80, fit: BoxFit.contain,)),
            SizedBox(height: 4,),
            Text("Testing", style: TextStyle(
              fontSize: 14,
              color: Colors.black
            ),),
          ],
        ),
      ),
    );
  }
}
