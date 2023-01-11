class FullCreditResp {
  int? code;
  List<FullCreditPersonBean>? result;

  FullCreditResp({this.code, this.result});

  FullCreditResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = <FullCreditPersonBean>[];
      json['result'].forEach((v) {
        result!.add(FullCreditPersonBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FullCreditPersonBean {
  int? id;
  String? mid;
  String? personId;
  String? personName;
  String? personAvatar;
  String? personCredit;
  String? personType;

  FullCreditPersonBean(
      {this.id,
      this.mid,
      this.personId,
      this.personName,
      this.personAvatar,
      this.personCredit,
      this.personType});

  FullCreditPersonBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mid = json['mid'];
    personId = json['person_id'];
    personName = json['person_name'];
    personAvatar = json['person_avatar'];
    personCredit = json['person_credit'];
    personType = json['person_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mid'] = mid;
    data['person_id'] = personId;
    data['person_name'] = personName;
    data['person_avatar'] = personAvatar;
    data['person_credit'] = personCredit;
    data['person_type'] = personType;
    return data;
  }
}
