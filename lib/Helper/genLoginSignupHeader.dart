import 'package:flutter/material.dart';

class genLoginSignupHeader extends StatelessWidget {


  String headerName;
  genLoginSignupHeader(this.headerName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mediaquery variable to get device screen size
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          SizedBox(height: screenSize.height/10),
          Text(
            headerName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 30.0),
          ),
          SizedBox(height:screenSize.height/16),

        ],
      ),
    );
  }
}
