import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/business_logic/view_models/tui_chat_global_model.dart';

import 'package:tencent_cloud_chat_uikit/customer/jsondata/tool.dart';
import 'package:timuikit/src/json/Index_list.dart';
import 'package:timuikit/src/pages/home/home_detail.dart';
import 'package:timuikit/src/pages/tools/vip_utils.dart';
import 'package:timuikit/src/tim_uikit_chat2.dart';
import 'package:timuikit/utils/network/httpUrl.dart';

class HomeItemWidget extends StatefulWidget {
  final IndexData model;
  HomeItemWidget({Key? key,required this.model}) : super(key: key);

  @override
  State<HomeItemWidget> createState() => _HomeItemWidgetState();
}

class _HomeItemWidgetState extends State<HomeItemWidget> {
  List<Widget> label = [];
  late double imgWidth;
  late double imgHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgWidth = Get.width - 50;
    imgHeight = imgWidth * 400 / 320;

    //年龄
    label.add(Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
          color: Color(0xFFFF9C52),
          borderRadius: BorderRadius.all(Radius.circular(11.5)),
          border: new Border.all(color: Color(0xFFF288D5), width: 0.5),
          gradient: LinearGradient(
            //渐变位置
              begin: Alignment.topRight, //右上
              end: Alignment.bottomLeft, //左下
              stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
              //渐变颜色[始点颜色, 结束颜色]
              colors: [Color(0xFFF481D5), Color(0xFFF6A5E2)])),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            widget.model.sex == 2 ? "assets/nv.png" : "assets/nan.png",
            width: 12,
            height: 12,
          ),
          Text(
            (widget.model.sex == 2) ? " 女" : " 男" + "  ",
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.2, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            widget.model.age.toString(),
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.2, fontWeight: FontWeight.w400),
          ),
        ],
      ), //Text(,
    ));

    if (ObjectUtil.isNotEmpty(widget.model.cityName)) {
      //城市
      label.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: new Border.all(color: Color(0xFF6DB2D9), width: 0.5),
              gradient: LinearGradient(
                //渐变位置
                  begin: Alignment.topRight, //右上
                  end: Alignment.bottomLeft, //左下
                  stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                  //渐变颜色[始点颜色, 结束颜色]
                  colors: [Color(0xFF6FB8E2), Color(0xFF9AD2EE)])),
          child: Text(
            widget.model.cityName ?? "",
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.2, fontWeight: FontWeight.w400),
          ) //Text(,
      ));
    }

    if (ObjectUtil.isNotEmpty(widget.model.education)) {
      //学历
      label.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: new Border.all(color: Color(0xFF7470EE), width: 0.5),
              gradient: LinearGradient(
                //渐变位置
                  begin: Alignment.topRight, //右上
                  end: Alignment.bottomLeft, //左下
                  stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                  //渐变颜色[始点颜色, 结束颜色]
                  colors: [Color(0xFF8A87F4), Color(0xFFA29FF5)])),
          child: Text(
            widget.model.education ?? "",
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.2, fontWeight: FontWeight.w400),
          ) //Text(,
      ));
    }

    if (ObjectUtil.isNotEmpty(widget.model.customerTypeName)) {
      //工作
      label.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: new Border.all(color: Color(0xFFFF9C52), width: 0.5),
              gradient: LinearGradient(
                //渐变位置
                  begin: Alignment.topRight, //右上
                  end: Alignment.bottomLeft, //左下
                  stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                  //渐变颜色[始点颜色, 结束颜色]
                  colors: [Color(0xFFFF9C52), Color(0xFFFDB46D)])),
          child: Text(
            widget.model.customerTypeName ?? "",
            style: TextStyle(color: Colors.white, fontSize: 12, height: 1.2, fontWeight: FontWeight.w400),
          ) //Text(,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        //VipUtils().viewDetail(context,widget.model.accountId!);
        var res = await HttpRequest.request(API.GET_AGREE, context, params: {"friend_account_id": widget.model.accountId!, "is_auto_hi": "N"});
        if ((res != null && res['result'] != null && res['result'] == true) || Tools.getInstance().getPersonInfo().result.isVip == 'Y') {

          Get.to(HomeDetailinfoPage(
            accountId: widget.model.accountId!,
            backFollow: (value){
              setState(() {
                widget.model.isFollow = value;
              });
            },
          ));
        } else if (res != null && res['result'] != null && res['result'] == false) {
          VipUtils.instance().toVipWithTips(context);
        } else {
          return;
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 25,right: 25,bottom: 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color(0x3FABABAB),
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(0, 3),
            )
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: imgWidth,
                  height: imgHeight + 50,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.model.cover.toString(),
                    fit: BoxFit.cover,
                    width: imgWidth,
                    height: imgHeight,
                  ),
                ),
                Positioned(
                  bottom: 65,
                  left: 12,
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0x8FEC4D71),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/meilizhi.png",
                            width: 14,
                            height: 16,
                          ),
                          Text(
                            " 魅力值" + widget.model.attractive.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                ),
                Positioned(
                    bottom: 5,
                    left: 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: widget.model.hideVip == 'Y' || widget.model.icons?.isVip == 'N'?false:true,
                          child: Image.asset(
                            "assets/home-vip.png",
                            width: 26,
                            height: 24,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                            width: 150,
                            height: 33,
                            child: Text(
                              widget.model.nickName.toString() == "" ? widget.model.accountName.toString() : widget.model.nickName.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w400, color: widget.model.sex == '1' ? Color(0xFF3DBBF5) : Color(0xFFEC4D71), fontSize: 24),
                            ))
                      ],
                    )),
                Positioned(
                  bottom: 25,
                  right: 15,
                  child: Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1E000000),
                            spreadRadius: 0,
                            blurRadius: 3,
                            offset: Offset(0, 1.5),
                          )
                        ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Image.asset(
                              (widget.model.isFollow!) ? "assets/home-heart.png" : "assets/home-heart-no.png",
                              width: 26,
                              height: 24,
                            ),
                            onTap: () {
                              if(Tools.getInstance().getPersonInfo().result.isVip == 'Y'){
                                if (widget.model.isFollow!) {
                                  HttpRequest.request(API.DEL_FOLLOW, context, params: {"to_account_id": widget.model.accountId}).then((value) {
                                    if (value['code'] == 200) {
                                      setState(() {
                                        widget.model.isFollow = false;
                                      });
                                      EasyLoading.showToast("取消关注");
                                    }else{
                                      EasyLoading.showToast("取消关注失败");
                                    }
                                  });
                                } else {
                                  HttpRequest.request(API.ADD_FOLLOW, context, params: {"to_account_id": widget.model.accountId}).then((value) {
                                    if (value['code'] == 200) {
                                      setState(() {
                                        widget.model.isFollow = true;
                                      });
                                      EasyLoading.showToast("已关注");
                                    }else{
                                      EasyLoading.showToast("关注失败");
                                    }
                                  });
                                }
                              }else{
                                VipUtils.instance().toVipWithTips(context);
                              }
                            },
                          ),
                          VerticalDivider(
                            color: Colors.grey,
                            width: 30,
                            endIndent: 5,
                            indent: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              message();
                            },
                            child: Image.asset(
                              "assets/home-msg.png",
                              width: 26,
                              height: 24,
                            ),
                          )
                        ],
                      )),
                ), //T
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFE7B889),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/home-id.png",
                          width: 13,
                          height: 13,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4,),
                        Text("已实名",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFDEC4).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/home_gh.png",
                          width: 13,
                          height: 13,
                        ),
                        SizedBox(width: 4,),
                        Text("工会认证",style: TextStyle(fontSize: 12,color: Color(0xFFD09A45),fontWeight: FontWeight.w500),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Image.asset(
                    "assets/home-id.png",
                    width: 18,
                    height: 18,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    (widget.model.icons?.isAuthHouse == "Y") ? "assets/home-fc-sel.png" : "assets/home-fc-unsel.png",
                    width: 18,
                    height: 18,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    (widget.model.icons?.isAuthCar == "Y") ? "assets/home-car-sel.png" : "assets/home-car-unsel.png",
                    width: 18,
                    height: 18,
                  ),
                ],
              ),
            ),
            ObjectUtil.isNotEmpty(label)
                ? Padding(
              padding: const EdgeInsets.only(left: 15,right: 15, bottom: 15),
              child: Wrap(spacing: 8, runSpacing: 8, crossAxisAlignment: WrapCrossAlignment.start, children: label),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  message() async {
    // baseApi=https%3A%2F%2Fsandbox-gonghui.jufubao.cn
    // &friend_account_id=009501e2-f368-11ec-a992-02420a0002e5&is_auto_hi=N&content=&token=
    var res = await HttpRequest.request(API.GET_AGREE, context, params: {"friend_account_id": widget.model.accountId.toString(), "is_auto_hi": "N"});

    if ((res != null && res['result'] != null && res['result'] == true) || Tools.getInstance().getPersonInfo().result.isVip == 'Y') {
      print("我要给她发消息" + widget.model.accountId.toString() + "name=" + widget.model.accountName.toString());

      Get.to(TIMUIKitChat2(conversationID: widget.model.accountId.toString(), conversationType: ConvType.c2c, conversationShowName: widget.model.accountName.toString()));
    } else if (res != null && res['result'] != null && res['result'] == false) {
      VipUtils.instance().toVipWithTips(context);
    } else {
      return;
    }
  }
}
