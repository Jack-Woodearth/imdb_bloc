import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class EventHistoryResp {
  EventHistoryResp({
    required this.code,
    this.result,
    this.msg,
  });

  factory EventHistoryResp.fromJson(Map<String, dynamic> json) =>
      EventHistoryResp(
        code: asT<int>(json['code'])!,
        result: json['result'] == null
            ? null
            : EventHistoryBean.fromJson(
                asT<Map<String, dynamic>>(json['result'])!),
        msg: asT<String?>(json['msg']),
      );

  int code;
  EventHistoryBean? result;
  String? msg;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'result': result,
        'msg': msg,
      };
}

class EventHistoryBean {
  EventHistoryBean({
    this.awardName,
    this.history,
  });

  factory EventHistoryBean.fromJson(Map<String, dynamic> json) =>
      EventHistoryBean(
        awardName: asT<String?>(json['award_name']),
        history: json['history'] == null
            ? null
            : History.fromJson(asT<Map<String, dynamic>>(json['history'])!),
      );

  String? awardName;
  History? history;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'award_name': awardName,
        'history': history,
      };
}

class History {
  History({
    this.year,
    this.numberWithinYear,
    this.awards,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    final List<Awards>? awards = json['awards'] is List ? <Awards>[] : null;
    if (awards != null) {
      for (final dynamic item in json['awards']!) {
        if (item != null) {
          awards.add(Awards.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return History(
      year: asT<int?>(json['year']),
      numberWithinYear: asT<int?>(json['number_within_year']),
      awards: awards,
    );
  }

  int? year;
  int? numberWithinYear;
  List<Awards>? awards;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'year': year,
        'number_within_year': numberWithinYear,
        'awards': awards,
      };
}

class Awards {
  Awards({
    this.name,
    this.subs,
  });

  factory Awards.fromJson(Map<String, dynamic> json) {
    final List<Subs>? subs = json['subs'] is List ? <Subs>[] : null;
    if (subs != null) {
      for (final dynamic item in json['subs']!) {
        if (item != null) {
          subs.add(Subs.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Awards(
      name: asT<String?>(json['name']),
      subs: subs,
    );
  }

  String? name;
  List<Subs>? subs;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'subs': subs,
      };
}

class Subs {
  Subs({
    required this.tSubAwardId,
    required this.awardId,
    this.subAwardName,
    this.nominations,
  });

  factory Subs.fromJson(Map<String, dynamic> json) {
    final List<Nominations>? nominations =
        json['nominations'] is List ? <Nominations>[] : null;
    if (nominations != null) {
      for (final dynamic item in json['nominations']!) {
        if (item != null) {
          nominations
              .add(Nominations.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Subs(
      tSubAwardId: asT<String>(json['t_sub_award_id'])!,
      awardId: asT<String>(json['award_id'])!,
      subAwardName: asT<Object?>(json['sub_award_name']),
      nominations: nominations,
    );
  }

  String tSubAwardId;
  String awardId;
  Object? subAwardName;
  List<Nominations>? nominations;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        't_sub_award_id': tSubAwardId,
        'award_id': awardId,
        'sub_award_name': subAwardName,
        'nominations': nominations,
      };
}

class Nominations {
  Nominations({
    required this.tNominationId,
    required this.subAwardId,
    this.nominationWinannouncementtime,
    this.nominationNotes,
    this.nominationSongnames,
    this.nominationEpisodenames,
    this.nominationCharacternames,
    this.isWinner,
    this.nominees,
  });

  factory Nominations.fromJson(Map<String, dynamic> json) {
    final List<Object>? nominationSongnames =
        json['nomination_songNames'] is List ? <Object>[] : null;
    if (nominationSongnames != null) {
      for (final dynamic item in json['nomination_songNames']!) {
        if (item != null) {
          nominationSongnames.add(asT<Object>(item)!);
        }
      }
    }

    final List<Object>? nominationEpisodenames =
        json['nomination_episodeNames'] is List ? <Object>[] : null;
    if (nominationEpisodenames != null) {
      for (final dynamic item in json['nomination_episodeNames']!) {
        if (item != null) {
          nominationEpisodenames.add(asT<Object>(item)!);
        }
      }
    }

    final List<Object>? nominationCharacternames =
        json['nomination_characterNames'] is List ? <Object>[] : null;
    if (nominationCharacternames != null) {
      for (final dynamic item in json['nomination_characterNames']!) {
        if (item != null) {
          nominationCharacternames.add(asT<Object>(item)!);
        }
      }
    }

    final List<Nominees>? nominees =
        json['nominees'] is List ? <Nominees>[] : null;
    if (nominees != null) {
      for (final dynamic item in json['nominees']!) {
        if (item != null) {
          nominees.add(Nominees.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Nominations(
      tNominationId: asT<String>(json['t_nomination_id'])!,
      subAwardId: asT<String>(json['sub_award_id'])!,
      nominationWinannouncementtime:
          asT<int?>(json['nomination_winAnnouncementTime']),
      nominationNotes: asT<String?>(json['nomination_notes']),
      nominationSongnames: nominationSongnames,
      nominationEpisodenames: nominationEpisodenames,
      nominationCharacternames: nominationCharacternames,
      isWinner: asT<bool?>(json['is_winner']),
      nominees: nominees,
    );
  }

  String tNominationId;
  String subAwardId;
  int? nominationWinannouncementtime;
  String? nominationNotes;
  List<Object>? nominationSongnames;
  List<Object>? nominationEpisodenames;
  List<Object>? nominationCharacternames;
  bool? isWinner;
  List<Nominees>? nominees;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        't_nomination_id': tNominationId,
        'sub_award_id': subAwardId,
        'nomination_winAnnouncementTime': nominationWinannouncementtime,
        'nomination_notes': nominationNotes,
        'nomination_songNames': nominationSongnames,
        'nomination_episodeNames': nominationEpisodenames,
        'nomination_characterNames': nominationCharacternames,
        'is_winner': isWinner,
        'nominees': nominees,
      };
}

class Nominees {
  Nominees({
    required this.id,
    required this.nominationId,
    required this.subjectId,
    this.subjectName,
    this.nomineeNote,
    this.subjectOriginalName,
    this.isPrimary,
  });

  factory Nominees.fromJson(Map<String, dynamic> json) => Nominees(
        id: asT<int>(json['id'])!,
        nominationId: asT<String>(json['nomination_id'])!,
        subjectId: asT<String>(json['subject_id'])!,
        subjectName: asT<String?>(json['subject_name']),
        nomineeNote: asT<Object?>(json['nominee_note']),
        subjectOriginalName: asT<Object?>(json['subject_original_name']),
        isPrimary: asT<bool?>(json['is_primary']),
      );

  int id;
  String nominationId;
  String subjectId;
  String? subjectName;
  Object? nomineeNote;
  Object? subjectOriginalName;
  bool? isPrimary;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'nomination_id': nominationId,
        'subject_id': subjectId,
        'subject_name': subjectName,
        'nominee_note': nomineeNote,
        'subject_original_name': subjectOriginalName,
        'is_primary': isPrimary,
      };
}
