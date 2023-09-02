import 'package:flutter/material.dart';

class HomeSearchSegmentWidget extends StatelessWidget {
  final int index;
  final Function selectIndex;
  const HomeSearchSegmentWidget({Key? key,this.index = 0,required this.selectIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 0,
              blurRadius: 2.5,
              offset: Offset(0, 0),
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildItem(icon:"shaixuan-unsel",title: "筛选",select: 0),
            Container(width: 1,height: 24,color: Color(0xFFE6E6E6),),
            buildItem(icon:"searchicon",title: "搜索",select: 1),
          ],
        ),
      ),
    );
  }

  Widget buildItem({required String icon,required String title,required int select}){
    bool isSelect = index == select;
    return InkWell(
      onTap: (){
        selectIndex(select);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 11,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/${icon}.png",width: 14,height: 14,color: isSelect?Color(0xFFEC4D71):Color(0xFFCCCCCC),),
                SizedBox(width: 8,),
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: isSelect?Color(0xFFEC4D71):Color(0xFFCCCCCC)),
                ),
              ],
            ),
            SizedBox(height: 7,),
            Opacity(opacity:isSelect?1:0, child: Container(width: 60,height: 3,color: Color(0xFFEC4D71),)),
          ],
        ),
      ),
    );
  }

}
