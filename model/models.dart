
import 'dart:convert';

class FiltrateModel {
  String startAge;
  String? endAge;

  String? startHeight;
  String? endHeight;

  String? startIncome;
  String? endIncome;

  String? startFaceValueId;
  String? endFaceValueId;

  String? nation;
  String? nationStr;

  String? wedding;
  String? weddingStr;

  String? house;
  String? houseStr;

  String? car;
  String? carStr;

  String? constellation;
  String? constellationStr;

  String? zodiac;
  String? zodiacStr;

  String? cityName;

  String? provinceCode;

  String? cityCode;

  FiltrateModel({
    this.startAge = "-1",
    this.endAge = "-1",
    this.startHeight = "-1",
    this.endHeight = "-1",
    this.startIncome = "-1",
    this.endIncome = "-1",
    this.startFaceValueId = "-1",
    this.endFaceValueId = "-1",
    this.nation = "-1",
    this.nationStr = "请选择",
    this.wedding = "-1",
    this.weddingStr = "请选择",
    this.house = "-1",
    this.houseStr = "请选择",
    this.car = "-1",
    this.carStr = "请选择",
    this.constellation = "-1",
    this.constellationStr = "请选择",
    this.zodiac = "-1",
    this.zodiacStr = "请选择",
    this.cityName = "-1",
    this.provinceCode = "-1",
    this.cityCode = "-1",
  });

  factory FiltrateModel.fromRawJson(String str) => FiltrateModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FiltrateModel.fromJson(Map<dynamic, dynamic> json) => FiltrateModel(
    startAge: json["start_age"] == null ? "-1" : json["start_age"].toString(),
    endAge: json["end_age"] == null ? "-1" : json["end_age"].toString(),

    startHeight: json["start_height"] == null ? "-1" : json["start_height"].toString(),
    endHeight: json["end_height"] == null ? "-1" : json["end_height"].toString(),

    startIncome: json["start_income"] == null ? "-1" : json["start_income"].toString(),
    endIncome: json["end_income"] == null ? "-1" : json["end_income"].toString(),

    startFaceValueId: json["start_face_value_id"] == null ? "-1" : json["start_face_value_id"].toString(),
    endFaceValueId: json["end_face_value_id"] == null ? "-1" : json["end_face_value_id"].toString(),

    nation: json["nation"] == null ? "-1" : json["nation"].toString(),
    nationStr: json["nationStr"] == null ? "请选择" : json["nationStr"].toString(),

    wedding: json["wedding"] == null ? "-1" : json["wedding"].toString(),
    weddingStr: json["weddingStr"] == null ? "请选择" : json["weddingStr"].toString(),

    house: json["house"] == null ? "-1" : json["house"].toString(),
    houseStr: json["houseStr"] == null ? "请选择" : json["houseStr"].toString(),

    car: json["car"] == null ? "-1" : json["car"].toString(),
    carStr: json["carStr"] == null ? "请选择" : json["carStr"].toString(),

    constellation: json["constellation"] == null ? "-1" : json["constellation"].toString(),
    constellationStr: json["constellationStr"] == null ? "请选择" : json["constellationStr"].toString(),

    zodiac: json["zodiac"] == null ? "-1" : json["zodiac"].toString(),
    zodiacStr: json["zodiacStr"] == null ? "请选择" : json["zodiacStr"].toString(),

    cityName: json["city_name"] == null ? "-1" : json["city_name"].toString(),

    provinceCode: json["province_code"] == null ? "-1" : json["province_code"].toString(),

    cityCode: json["city_code"] == null ? "-1" : json["city_code"].toString(),
  );


  Map<String, dynamic> toJson() => {
    //年龄
    if(startAge != "-1")"start_age": startAge,
    if(endAge != "-1")"end_age": endAge,

    if(startHeight != "-1")"start_height": startHeight,
    if(endHeight != "-1")"end_height": endHeight,

    if(startIncome != "-1")"start_income": startIncome,
    if(endIncome != "-1")"end_income": endIncome,

    if(startFaceValueId != "-1")"start_face_value_id": startFaceValueId,
    if(endFaceValueId != "-1")"end_face_value_id": endFaceValueId,

    if(nation != "-1")"nation": nation,
    if(nationStr != "请选择")"nationStr": nationStr,

    if(wedding != "-1")"wedding": wedding,
    if(weddingStr != "请选择")"weddingStr": weddingStr,

    if(house != "-1")"house": house,
    if(houseStr != "请选择")"houseStr": houseStr,

    if(car != "-1")"car": car,
    if(carStr != "请选择")"carStr": carStr,

    if(constellation != "-1")"constellation": constellation,
    if(constellationStr != "请选择")"constellationStr": constellationStr,

    if(zodiac != "-1")"zodiac": zodiac,
    if(zodiacStr != "请选择")"zodiacStr": zodiacStr,

    if(cityName != "-1")"city_name": cityName,
    if(provinceCode != "-1")"province_code": provinceCode,
    if(cityCode != "-1")"city_code": cityCode,
  };

  Map<String, dynamic> toMap() => {
    //年龄
    if(startAge != "-1")"start_age": startAge,
    if(endAge != "-1")"end_age": endAge,

    if(startHeight != "-1")"start_height": startHeight,
    if(endHeight != "-1")"end_height": endHeight,

    if(startIncome != "-1")"start_income": startIncome,
    if(endIncome != "-1")"end_income": endIncome,

    if(startFaceValueId != "-1")"start_face_value_id": startFaceValueId,
    if(endFaceValueId != "-1")"end_face_value_id": endFaceValueId,

    if(nation != "-1")"nation": nation,

    if(wedding != "-1")"wedding": wedding,

    if(house != "-1")"house": house,

    if(car != "-1")"car": car,

    if(constellation != "-1")"constellation": constellation,

    if(zodiac != "-1")"zodiac": zodiac,

    if(cityName != "-1")"city_name": cityName,
    if(provinceCode != "-1")"province_code": provinceCode,
    if(cityCode != "-1")"city_code": cityCode,
  };
}