import 'package:bruno/bruno.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_city_picker/listener/picker_listener.dart';
import 'package:flutter_city_picker/model/address.dart';
import 'package:get/get.dart';
import 'package:tencent_cloud_chat_uikit/customer/jsondata/sys_config_nolimit.dart';
import 'package:timuikit/src/pages/new_home/model/models.dart';
import 'package:timuikit/src/pages/new_home/widget/flutter_xlider.dart';
import 'package:timuikit/src/pages/reg/widget/city_picker_modify.dart';
import 'package:timuikit/src/pages/reg/widget/select_delegate.dart';
import 'package:timuikit/src/pages/tools/http_util.dart';
import 'package:timuikit/utils/network/httpUrl.dart';
import 'package:timuikit/utils/toast.dart';

class HomeSearchFiltratePage extends StatefulWidget {
  final Function backCall;
  const HomeSearchFiltratePage({Key? key,required this.backCall}) : super(key: key);

  @override
  State<HomeSearchFiltratePage> createState() => _HomeSearchFiltratePageState();
}

class _HomeSearchFiltratePageState extends State<HomeSearchFiltratePage> with CityPickerListener,AutomaticKeepAliveClientMixin{
  static final String FiltrateKey = "Filtrate";
  FiltrateModel? filtrMode;
  bool isRequest = false;
  SysconfigNoLimit? limitModel;
  List<String> gridData = ["民族","婚姻","购房","购车","星座","属相"];
  List<AddressNode> _selectedAddress = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    HttpRequest.request(API.GET_CONFIG_NOLIMIT, context,  params: {}).then((res) {
      if (res['code'] == 200) {
        isRequest = true;
        if (!(SpUtil.haveKey(FiltrateKey)??false)){
          filtrMode = FiltrateModel();
          SpUtil.putObject(FiltrateKey, FiltrateModel());
        }else{
          filtrMode = SpUtil.getObj(FiltrateKey, (v) => FiltrateModel.fromJson(v));
        }
        setState(() {
          limitModel = SysconfigNoLimit.fromJson(res);
        });
      }
    }).onError((error, stackTrace) {
      Utils.toast("获取配置信息失败!");
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: isRequest?Column(
              children: [
                SizedBox(
                  height: 2,
                ),
                buildCityWidget(),
                SizedBox(
                  height: 25,
                ),
                buildSilderItem(title: "年龄", small: "(岁)",),
                buildSilderItem(title: "身高", small: "(厘米)",),
                buildSilderItem(title: "收入", small: "(千/月)",),
                buildSilderItem(title: "颜值", small: "(分)",),
                buildGridView(),
              ],
            ):SizedBox.shrink(),
          ),
        ),
        buildBottomWidget()
      ],
    );
  }

  //现居住地
  Widget buildCityWidget() {
    return InkWell(
      onTap: (){
        cityShow();
      },
      child: Container(
        margin: EdgeInsets.only(left: 13, right: 13),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(0, 0),
          )
        ]),
        child: Row(
          children: [
            Container(
                width: 95,
                child: Text(
                  "现在居住地:",
                  style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
                )),
            Text(
              filtrMode!.cityName == "-1"? "请选择" : filtrMode!.cityName!,
              style: TextStyle(fontSize: 16, color: Color(0xFF999999)),
            ),
            Spacer(),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFEC4D71).withOpacity(0.2)),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFEC4D71),
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //滑动条
  Widget buildSilderItem({required String title, required String small}) {
    String strat = "";
    String end = "";

    String stratSelect = "-1";
    String endSelect = "-1";

    if(title == "年龄"){
      strat = limitModel!.result!.systemCommonAge!.first.value!;
      end = limitModel!.result!.systemCommonAge!.last.value!;
      stratSelect = filtrMode!.startAge!  == "-1" ? strat : filtrMode!.startAge!;
      endSelect = filtrMode!.endAge!  == "-1" ? end : filtrMode!.endAge!;
    }else if(title == "身高"){
      strat = limitModel!.result!.systemCommonHeight!.first.value!;
      end = limitModel!.result!.systemCommonHeight!.last.value!;
      stratSelect = filtrMode!.startHeight! == "-1" ? strat : filtrMode!.startHeight!;
      endSelect = filtrMode!.endHeight! == "-1" ? end : filtrMode!.endHeight!;
    }else if(title == "收入"){
      strat = limitModel!.result!.systemCommonIncome!.first.value!;
      end = limitModel!.result!.systemCommonIncome!.last.value!;
      stratSelect = filtrMode!.startIncome! == "-1" ? strat : filtrMode!.startIncome!;
      endSelect = filtrMode!.endIncome! == "-1" ? end : filtrMode!.endIncome!;
    }else if(title == "颜值"){
      strat = limitModel!.result!.systemCommonFace!.first.value!;
      end = limitModel!.result!.systemCommonFace!.last.value!;
      stratSelect = filtrMode!.startFaceValueId! == "-1" ? strat : filtrMode!.startFaceValueId!;
      endSelect = filtrMode!.endFaceValueId! == "-1" ? end : filtrMode!.endFaceValueId!;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 90,
            padding: EdgeInsets.only(top: 15),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF333333))),
                TextSpan(text: small, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400, color: Color(0xFF333333))),
              ]),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 40),
                child: Row(
                  children: [
                    Text(
                      "${strat}",
                      style: TextStyle(fontSize: 20, color: Color(0xFF333333)),
                    ),
                    Spacer(),
                    Text(
                      "${end}",
                      style: TextStyle(fontSize: 20, color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 20,
                child: FlutterSlider(
                  values: [double.parse(stratSelect), double.parse(endSelect),],
                  rangeSlider: true,
//rtl: true,
//                   ignoreSteps: [
//                     FlutterSliderIgnoreSteps(from: 8000, to: 12000),
//                     FlutterSliderIgnoreSteps(from: 18000, to: 22000),
//                   ],
                  max: double.parse(end),
                  min: double.parse(strat),
                  step: FlutterSliderStep(step: 1),
                  jump: true,
                  trackBar: FlutterSliderTrackBar(
                    activeTrackBarHeight: 5,
                    inactiveTrackBar: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                    ),
                    activeTrackBar: BoxDecoration(
                      color: Color(0xFFEC4D71),
                    ),
                  ),
                  //顶部
                  tooltip: FlutterSliderTooltip(
                    positionOffset: FlutterSliderTooltipPositionOffset(top: 15),
                    boxStyle: FlutterSliderTooltipBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0x33EC4D71),
                      ),
                    ),
                    textStyle: TextStyle(fontSize: 20, color: Color(0xFFEC4D71)),
                  ),
                  //左边
                  handler: FlutterSliderHandler(
                    decoration: BoxDecoration(),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.red),
                      child: Container(width: 15, height: 15, decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white)),
                    ),
                  ),
                  //右边
                  rightHandler: FlutterSliderHandler(
                    decoration: BoxDecoration(),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.red),
                      child: Container(width: 15, height: 15, decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white)),
                    ),
                  ),
                  disabled: false,

                  onDragging: (handlerIndex, startValue, endValue) {
                    if(title == "年龄"){
                      filtrMode!.startAge = startValue.toString();
                      filtrMode!.endAge = endValue.toString();
                    }else if(title == "身高"){
                      filtrMode!.startHeight = startValue.toString();
                      filtrMode!.endHeight = endValue.toString();
                    }else if(title == "收入"){
                      filtrMode!.startIncome = startValue.toString();
                      filtrMode!.endIncome = endValue.toString();
                    }else if(title == "颜值"){
                      filtrMode!.startFaceValueId = startValue.toString();
                      filtrMode!.endFaceValueId = endValue.toString();
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  //
  Widget buildGridView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17,vertical: 20),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //横轴三个子widget
            childAspectRatio: 170/83, //宽高比为1时，子widget,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: gridData.length,
          itemBuilder: (context, index) {
            return buildItem(title: gridData[index]);
          }),
    );
  }

  Widget buildItem({required String title}) {
    String smallStr = "请选择";
    String smallIndex = "-1";
    List<SystemCommonSex> types = [];
    List<Map<String, List>> pickerList = [];
    if(title == "民族"){
      smallStr = filtrMode!.nationStr!;
      smallIndex = filtrMode!.nation!;
      types = limitModel!.result!.systemCommonNation??[];
    }else if(title == "婚姻"){
      smallStr = filtrMode!.weddingStr!;
      smallIndex = filtrMode!.wedding!;
      types = limitModel!.result!.systemCommonWedding??[];
    }else if(title == "购房"){
      smallStr = filtrMode!.houseStr!;
      smallIndex = filtrMode!.house!;
      types = limitModel!.result!.systemCommonHouse??[];
    }else if(title == "购车"){
      smallStr = filtrMode!.carStr!;
      smallIndex = filtrMode!.car!;
      types = limitModel!.result!.systemCommonCar??[];
    }else if(title == "星座"){
      smallStr = filtrMode!.constellationStr!;
      smallIndex = filtrMode!.constellation!;
      types = limitModel!.result!.systemCommonConstellation??[];
    }else if(title == "属相"){
      smallStr = filtrMode!.zodiacStr!;
      smallIndex = filtrMode!.zodiac!;
      types = limitModel!.result!.systemCommonZodiac??[];
    }

    for(int i = 0;i<types.length;i++){
      SystemCommonSex model = types[i];

      if(smallStr == model.label){
        smallIndex = i.toString();
      }
      Map<String, List<String>> mp2 = {
        model.label.toString(): [model.value.toString()]
      };
      pickerList.add(mp2);
    }
    return InkWell(
      onTap: (){
        BrnMultiDataPicker(
          context: context,
          title: '',
          delegate: Brn1RowDelegate(list: pickerList,firstSelectedIndex: smallIndex == "-1"?0: int.parse(smallIndex)),
          confirmClick: (list) {
            setState(() {
              if(title == "民族"){
                filtrMode!.nationStr = pickerList[list[0]].keys.first;
                filtrMode!.nation = pickerList[list[0]].values.first[0];
              }else if(title == "婚姻"){
                filtrMode!.weddingStr = pickerList[list[0]].keys.first;
                filtrMode!.wedding = pickerList[list[0]].values.first[0];

              }else if(title == "购房"){
                filtrMode!.houseStr = pickerList[list[0]].keys.first;
                filtrMode!.house = pickerList[list[0]].values.first[0];

              }else if(title == "购车"){
                filtrMode!.carStr = pickerList[list[0]].keys.first;
                filtrMode!.car = pickerList[list[0]].values.first[0];
              }else if(title == "星座"){
                filtrMode!.constellationStr = pickerList[list[0]].keys.first;
                filtrMode!.constellation = pickerList[list[0]].values.first[0];
              }else if(title == "属相"){
                filtrMode!.zodiacStr = pickerList[list[0]].keys.first;
                filtrMode!.zodiac = pickerList[list[0]].values.first[0];
              }
            });
          },
        ).show();
      },
      child: Container(
        padding: EdgeInsets.only(left: 26,right: 20,top: 15,bottom: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xFF333333)),),
                  SizedBox(height: 8,),
                  Text(smallStr,maxLines: 1,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xFF999999)),),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color(0xFFEC4D71).withOpacity(0.2)),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFEC4D71),
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Future<List<AddressNode>> onDataLoad(int index, String code, String name) async {
    if (index == 0) {
      return HttpUtils.getCityData2("");
    } else {
      if (index == 2) {
        return Future.value([]);
      }
      return HttpUtils.getCityData2(code);
    }
  }

  @override
  void onFinish(List<AddressNode> data) {
    print("onFinish");
    String cityName = "";
    String provinceCode = "";
    String cityCode = "";
    if (data.isNotEmpty) {
      if (data.length > 0) {
        cityName += data[0].name??"";
        provinceCode = data[0].code??"";
      }
      if(data.length > 1){
        if(ObjectUtil.isNotEmpty(data[1].name??"")){
          cityName += "-";
        }
        cityName += data[1].name??"";
        cityCode = data[1].code??"";
      }
      if(data.length > 3){
        if(ObjectUtil.isNotEmpty(data[2].name??"")){
          cityName += "-";
        }
        cityName += data[2].name??"";
      }
      filtrMode!.cityName = cityName;
      filtrMode!.provinceCode = provinceCode;
      filtrMode!.cityCode = cityCode;
      setState(() {});
    }

  }

  void cityShow() {
    CityPicker.show(
      context: context,
      theme: ThemeData(
        dialogBackgroundColor: Colors.white,
      ),
      duration: 200,
      opacity: 0.5,
      dismissible: true,
      height:  500.0,
      titleHeight: 50,
      corner: 20,
      paddingLeft: 15,
      titleWidget: Container(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          '请选择地址',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      selectText: "请选择",
      closeWidget: Icon(Icons.close),
      tabHeight: 40,
      showTabIndicator: true,
      tabIndicatorColor: Theme.of(context).primaryColor,
      tabIndicatorHeight: 2,
      labelTextSize: 15,
      selectedLabelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.black54,
      itemHeadHeight: 30,
      itemHeadLineColor: Colors.black,
      itemHeadLineHeight: 0.1,
      itemHeadTextStyle: TextStyle(fontSize: 15, color: Colors.black),
      itemHeight: 40,
      indexBarWidth: 0,
      indexBarItemHeight: 0,
      indexBarBackgroundColor: Colors.transparent,
      indexBarTextStyle: TextStyle(fontSize: 14, color: Colors.black54),
      itemSelectedIconWidget: Icon(Icons.done, color: Theme.of(context).primaryColor, size: 16),
      itemSelectedTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      itemUnSelectedTextStyle: TextStyle(fontSize: 14, color: Colors.black54),
      initialAddress: _selectedAddress,
      cityPickerListener: this,
    );
  }

  //底部操作
  Widget buildBottomWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 27, right: 27, top: 10, bottom: MediaQuery.of(context).padding.bottom + (MediaQuery.of(context).padding.bottom != 0 ?0:20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(flex: 1, child: buildBottomItem(title: "重置", color: Color(0xFFCCCCCC), shadow: Color(0x3F63616E), onTap: () {
            try{
              filtrMode = FiltrateModel();
              SpUtil.putObject(FiltrateKey, FiltrateModel());
              setState(() {});
            }catch(s,e){}
          })),
          SizedBox(
            width: 22,
          ),
          Expanded(flex: 1, child: buildBottomItem(title: "确定", color: Color(0xFFEC4D71), shadow: Color(0x66EC4D71), onTap: () {
            try{
              SpUtil.putObject(FiltrateKey, filtrMode!);
              if(widget.backCall != null)widget.backCall(filtrMode!);
              Get.back();
            }catch(s,e){}
          })),
        ],
      ),
    );
  }

  //底部item
  Widget buildBottomItem({required String title, required Color color, required Color shadow, required GestureTapCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(100), boxShadow: [
          BoxShadow(
            color: shadow,
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 5),
          )
        ]),
        child: Center(
            child: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        )),
      ),
    );
  }
}
