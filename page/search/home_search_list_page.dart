import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:timuikit/src/json/home_search_result.dart';
import 'package:timuikit/src/pages/home/home_detail.dart';
import 'package:timuikit/utils/network/httpUrl.dart';
import 'package:timuikit/utils/toast.dart';


class HomeSearchListPage extends StatefulWidget {
  const HomeSearchListPage({Key? key}) : super(key: key);

  @override
  State<HomeSearchListPage> createState() => _HomeSearchListPageState();
}

class _HomeSearchListPageState extends State<HomeSearchListPage> {
  TextEditingController _idController = TextEditingController();
  Data? data;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                margin: EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          border: new Border.all(color: Color(0xFFEEEEEE), width: 0.5),
                          //border: BoxBorder()
                        ),
                        child: Container(
                          //flex: 1,
                            child: TextField(
                              decoration: InputDecoration(hintText: "请输入用户ID", contentPadding: const EdgeInsets.only(left: 10.0, right: 10), hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), border: InputBorder.none),
                              controller: _idController,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xFFEC4D71)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              String id = _idController.text;
                              if (id == null || id.length < 1) {
                                Utils.toast("用户id不能为空");
                                return;
                              }
                              HttpRequest.request(API.SEARCH_BYID, context, params: {"id": id}).then((value) {
                                HomeSearchResult result = HomeSearchResult.fromJson(value);

                                if (result != null && result.result != null && result.result!.data!.length > 0) {
                                  data = result!.result!.data![0];
                                  setState(() {
                                  });
                                } else {
                                  EasyLoading.showToast("未查到此会员ID信息");
                                  if(data != null){
                                    setState(() {
                                      data = null;
                                    });
                                  }
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                Text(
                                  "搜索",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 12,
                    ),
                  ],
                )),
            ObjectUtil.isNotEmpty(data)?InkWell(
              onTap: (){
                Get.to(HomeDetailinfoPage(
                  accountId: data!.accountId??"",
                ));
              },
              child: Container(
                  margin: EdgeInsets.only(top: 20, left: 12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Container(
                            width: 80,
                            height: 120,
                            child: Image.network(
                              data!.header??"",
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID:${data!.id??""}",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "昵称:${data!.nickName??""}",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Container(
                              width: 85,
                              height: 23,
                              decoration: BoxDecoration(
                                color: Color(0xFFF6A5E2),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: new Border.all(color: Color(0x1E000000), width: 0.5),
                              ),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    data!.sex == "2" ? "assets/nv.png" : "assets/nan.png",
                                    width: 12,
                                    height: 12,
                                  ),
                                  Text(
                                    data!.sex == "2" ? " 女  " : " 男  ",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    data!.age ?? "",
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ), //Text(,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ):SizedBox.shrink(),
          ],
        ));
  }
}
