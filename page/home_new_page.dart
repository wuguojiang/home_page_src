import 'dart:async';

import 'package:bruno/bruno.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tencent_cloud_chat_uikit/customer/jsondata/tool.dart';
import 'package:tencent_cloud_chat_uikit/customer/jsondata/user_info.dart';

import 'package:timuikit/src/json/Index_list.dart';
import 'package:timuikit/src/json/day_sign.dart';
import 'package:timuikit/src/pages/my/widget/home_recommend.dart';
import 'package:timuikit/src/pages/my/widget/sing_dialog.dart';
import 'package:timuikit/src/pages/new_home/model/models.dart';
import 'package:timuikit/src/pages/new_home/page/search/home_search_page.dart';
import 'package:timuikit/src/pages/new_home/widget/home_item_widget.dart';
import 'package:timuikit/src/pages/tools/vip_utils.dart';
import 'package:timuikit/utils/event.dart';
import 'package:timuikit/utils/network/httpUrl.dart';
import 'package:tencent_cloud_chat_uikit/customer/jsondata/user_info.dart' as tmp;
import 'package:timuikit/utils/route_observer.dart';

class HomeNewPage extends StatefulWidget {
  const HomeNewPage({Key? key,}) : super(key: key);

  @override
  State<HomeNewPage> createState() => _HomeNewPageState();
}

class _HomeNewPageState extends State<HomeNewPage> with AutomaticKeepAliveClientMixin, RouteAware {
  static final String FiltrateKey = "Filtrate";
  int last_key = 1;
  int page_size = 20;
  int is_last = 1;
  bool isMore = true;

  RefreshController refreshController = RefreshController(initialRefresh: false);

  tmp.UserInfo? detail = Tools.getInstance().getPersonInfo();

  FiltrateModel? filtrate;

  List<IndexData> dataArray = [];

  StreamSubscription? eventBusTabChange;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteUtils.routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  //回到当前页面
  @override
  void didPopNext() {
    requestData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SpUtil.putObject(FiltrateKey, FiltrateModel());
    refresh(showdialog: true);
    requestData();

    eventBusTabChange = eventBus.on<OnTabChange>().listen((it) async {
      if (it.index == 0) {
        refresh(showdialog: true);
        requestData();
      }
    });

    if (Tools.getInstance().getPersonInfo().result.isVip == 'Y') {
      HttpRequest.request(API.RECOMM_LIST, context, method: "get", params: {},showdialog: false).then((res) {
        IndexList recoom = IndexList.fromJson(res);

        if (recoom != null && ObjectUtil.isNotEmpty(recoom.result)) {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return HomeRecommendDialog(
                cards: recoom.result,
              );
            },
          );
        }
      });
    }

    HttpRequest.request(API.GET_USERINFO, context, params: {},showdialog: false).then((value) {
      Tools.getInstance().setPersonInfo(tmp.UserInfo.fromJson(value));
      detail = Tools.getInstance().getPersonInfo();
      if (detail != null && detail?.result != null && detail?.result?.wedding == '2') {
        BrnDialogManager.showSingleButtonDialog(context,
            //title: "温馨提示",
            message: "你的婚姻状态为已经有对象，系统已经隐藏您的资料，请知悉!", onTap: () {
              Navigator.pop(context);
            }, label: '确定');
      }
      if (detail != null && detail?.result != null && detail?.result?.isSign == 'Y') {
        HttpRequest.request(API.SIGN_DAY, context, method: "get", params: {},showdialog: false).then((res) {
          DaySign days = DaySign.fromJson(res);
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return HomeSignDialog(
                cards: days.result?.data,
                attractive: detail!.result!.attractive!,
              );
            },
          );
        });
      }
    });
  }

  void requestData() {
    HttpRequest.request(API.GET_USERINFO, context, params: {}, showdialog: false).then((res) {
      if (res['code'] == 200) {
        Tools.getInstance().setPersonInfo(UserInfo.fromJson(res));
      }
    }).onError((error, stackTrace) {
      print("获取用户信息失败！");
    });
  }

  @override
  void dispose() {
    RouteUtils.routeObserver.unsubscribe(this);
    super.dispose();
    eventBusTabChange?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (dataArray.length == 0) {
      isMore = true;
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            //把scaffold的背景色改成透明
            title: Text(
              "首页",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
            ),
            centerTitle: true,
            leadingWidth: 90,
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: IconButton(
                icon: Row(
                  children: [
                    Image.asset(
                      "assets/find.png",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "搜索",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  if (Tools.getInstance().getPersonInfo().result.isVip == 'Y') {
                    Get.to(HomeSearchPage(backCall: (model) {
                      filtrate = model;
                      refresh(showdialog: true);
                    }));
                  } else {
                    VipUtils.instance().toVipWithTips(context);
                  }
                },
              ),
            )),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: refreshController,
          onRefresh: refresh,
          onLoading: loadMore,
          child: dataArray!.length > 0
              ? ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (!isMore && index == dataArray.length) {
                      return Container(padding: EdgeInsets.symmetric(vertical: 10), child: Center(child: Text("—— 没有更多异性了  ——", style: TextStyle(fontSize: 12, color: Color(0xFF999999), fontWeight: FontWeight.w400),)),);
                    }
                    return HomeItemWidget(model: dataArray[index]);
                  },
                  itemCount: dataArray.length + (isMore ? 0 : 1),
                )
              : Center(
              child: Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 20),
                width: Get.width - 50,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/no_data.png",
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 52,),
                    Text(
                      "暂无数据",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xFFB9B9B9)),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }


  Future refresh({bool showdialog = false}) async {
    Map<String, dynamic> params = {
      "last_key": last_key,
      "page_size": page_size,
      "is_last": 1,
    };
    if (ObjectUtil.isNotEmpty(filtrate) && Tools.getInstance().getPersonInfo().result.isVip == 'Y') {
      params.addAll(filtrate!.toMap());
    }
    try {
      HttpRequest.request(API.HOME, context, method: "get", params: params, showdialog: showdialog).then((res) {
        if (res['code'] == 200) {
          IndexResult? Result = IndexHomeList.fromJson(res).result;
          if (ObjectUtil.isNotEmpty(Result) && ObjectUtil.isNotEmpty(Result!.data)) {
            dataArray = Result!.data!;
            refreshController?.refreshCompleted();
            // 小于分页的数量,禁止上拉加载更多
            if (dataArray.length < page_size) {
              refreshController?.loadNoData();
              isMore = false;
            } else {
              //防止上次上拉加载更多失败,需要重置状态
              refreshController?.loadComplete();
            }
          } else {
            refreshController?.refreshCompleted(resetFooterState: true);
            dataArray.clear();
          }
        }else {
          refreshController?.refreshCompleted(resetFooterState: true);
          dataArray.clear();
        }
        if (mounted) setState(() {});
      });
    } catch (s) {
      refreshController?.refreshFailed();
    }
  }

  /// 上拉加载更多
  Future loadMore() async {
    Map<String, dynamic> params = {
      "last_key": last_key,
      "page_size": page_size,
      "is_last": 1,
    };
    if (ObjectUtil.isNotEmpty(filtrate) && Tools.getInstance().getPersonInfo().result.isVip == 'Y') {
      params.addAll(filtrate!.toMap());
    }
    try {
      ++last_key;
      HttpRequest.request(API.HOME, context, method: "get", params: params, showdialog: false).then((res) {
        if (res['code'] == 200) {
          IndexResult? Result = IndexHomeList.fromJson(res).result;
          if (ObjectUtil.isNotEmpty(Result) && ObjectUtil.isNotEmpty(Result!.data)) {
            dataArray.addAll(Result!.data!);
            if (Result!.data!.length < page_size) {
              refreshController?.loadNoData();
              isMore = false;
            } else {
              refreshController?.loadComplete();
            }
          } else {
            /// 数据为空,当前页索引减一,防止上拉无线增大
            last_key--;
            refreshController?.loadNoData();
          }
        }else {
          /// 数据为空,当前页索引减一,防止上拉无线增大
          last_key--;
          refreshController?.loadNoData();
        }
        if (mounted) setState(() {});
      });
    } catch (s, e) {
      last_key--;
      refreshController?.loadFailed();
    }
    if (mounted) setState(() {});
  }

}
