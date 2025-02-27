import 'package:flutter/material.dart';

import '../../util/constant.dart';

class ItemCard extends StatelessWidget {
  final String imgSrc;
  final String title;
  final Function press;
  const ItemCard({
    Key key,
    this.imgSrc,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: kShadowColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Image.asset(imgSrc, height: 130,),
                  Spacer(),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: kSubTextStyle,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}