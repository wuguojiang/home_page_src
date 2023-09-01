
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/customer/jsondata/sys_config_nolimit.dart';
import 'package:timuikit/src/pages/new_home/model/models.dart';
import 'package:timuikit/src/pages/new_home/widget/flutter_xlider.dart';

class SilderItemWidget extends StatefulWidget {
  final String title;
  final String small;
  final FiltrateModel filtrMode;
  final SysconfigNoLimit limitModel;
  const SilderItemWidget({Key? key,required this.title,required this.small,required this.filtrMode,required this.limitModel}) : super(key: key);

  @override
  State<SilderItemWidget> createState() => _SilderItemWidgetState();
}

class _SilderItemWidgetState extends State<SilderItemWidget> {
  String strat = "";
  String end = "";

  String stratSelect = "-1";
  String endSelect = "-1";

  @override
  Widget build(BuildContext context) {
    if(widget.title == "年龄"){
      strat = widget.limitModel!.result!.systemCommonAge!.first.value!;
      end = widget.limitModel!.result!.systemCommonAge!.last.value!;
      stratSelect = widget.filtrMode!.startAge!  == "-1" ? strat : widget.filtrMode!.startAge!;
      endSelect = widget.filtrMode!.endAge!  == "-1" ? end : widget.filtrMode!.endAge!;
    }else if(widget.title == "身高"){
      strat = widget.limitModel!.result!.systemCommonHeight!.first.value!;
      end = widget.limitModel!.result!.systemCommonHeight!.last.value!;
      stratSelect = widget.filtrMode!.startHeight! == "-1" ? strat : widget.filtrMode!.startHeight!;
      endSelect = widget.filtrMode!.endHeight! == "-1" ? end : widget.filtrMode!.endHeight!;
    }else if(widget.title == "收入"){
      strat = widget.limitModel!.result!.systemCommonIncome!.first.value!;
      end = widget.limitModel!.result!.systemCommonIncome!.last.value!;
      stratSelect = widget.filtrMode!.startIncome! == "-1" ? strat : widget.filtrMode!.startIncome!;
      endSelect = widget.filtrMode!.endIncome! == "-1" ? end : widget.filtrMode!.endIncome!;
    }else if(widget.title == "颜值"){
      strat = widget.limitModel!.result!.systemCommonFace!.first.value!;
      end = widget.limitModel!.result!.systemCommonFace!.last.value!;
      stratSelect = widget.filtrMode!.startFaceValueId! == "-1" ? strat : widget.filtrMode!.startFaceValueId!;
      endSelect = widget.filtrMode!.endFaceValueId! == "-1" ? end : widget.filtrMode!.endFaceValueId!;
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
                TextSpan(text: widget.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF333333))),
                TextSpan(text: widget.small, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w400, color: Color(0xFF333333))),
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
                      ignoreSteps: [
                        FlutterSliderIgnoreSteps(from: 8000, to: 12000),
                        FlutterSliderIgnoreSteps(from: 18000, to: 22000),
                      ],
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
                        print("滑动---${startValue}--${endValue}");
                        if(widget.title == "年龄"){
                          widget.filtrMode!.startAge = startValue.toString();
                          widget.filtrMode!.endAge = endValue.toString();
                        }else if(widget.title == "身高"){
                          widget.filtrMode!.startHeight = startValue.toString();
                          widget.filtrMode!.endHeight = endValue.toString();
                        }else if(widget.title == "收入"){
                          widget.filtrMode!.startIncome = startValue.toString();
                          widget.filtrMode!.endIncome = endValue.toString();
                        }else if(widget.title == "颜值"){
                          widget.filtrMode!.startFaceValueId = startValue.toString();
                          widget.filtrMode!.endFaceValueId = endValue.toString();
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
}
