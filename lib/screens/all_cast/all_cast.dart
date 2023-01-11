import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import '../../apis/full_credit.dart';
import '../../beans/cast_bean.dart';
import '../../utils/common.dart';
import '../../utils/string/string_utils.dart';
import '../../widgets/my_group_buttons.dart';
import 'person_card.dart';

class AllCastScreenData {
  final String mid;
  final String title;
  final String? contentType;
  const AllCastScreenData(
      {required this.mid, required this.title, this.contentType});
}

class AllCastScreen extends StatelessWidget {
  const AllCastScreen({
    Key? key,
    required this.data,
  }) : super(key: key);
  final AllCastScreenData data;
  @override
  Widget build(BuildContext context) {
    return AllCastScreenIW(
        child: _AllCastScreenDirectChild(
          mid: data.mid,
          title: data.title,
          contentType: data.contentType,
        ),
        mid: data.mid,
        title: data.title,
        contentType: data.contentType);
  }
}

class AllCastScreenIW extends InheritedWidget {
  const AllCastScreenIW({
    Key? key,
    required this.child,
    required this.mid,
    required this.title,
    required this.contentType,
  }) : super(key: key, child: child);

  @override
  final Widget child;
  final String mid;
  final String title;
  final String? contentType;
  static AllCastScreenIW? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AllCastScreenIW>();
  }

  @override
  bool updateShouldNotify(AllCastScreenIW oldWidget) {
    return oldWidget.mid != mid;
  }
}

class _AllCastScreenDirectChild extends StatefulWidget {
  const _AllCastScreenDirectChild(
      {Key? key, required this.mid, required this.title, this.contentType})
      : super(key: key);
  final String mid;
  final String title;
  final String? contentType;
  @override
  State<_AllCastScreenDirectChild> createState() =>
      _AllCastScreenDirectChildState();
}

class _AllCastScreenDirectChildState extends State<_AllCastScreenDirectChild> {
  late final List<FullCreditPersonBean> _people;

  List<FullCreditPersonBean> _filteredPeople = [];
  List<FullCreditPersonBean> _typedAndFilteredPeople = [];

  Set<String?> _types = {};
  String _typeSelected = 'ALL';
  bool loading = true;
  // final bool _busy = false;
  final GroupButtonController _groupButtonController = GroupButtonController()
    ..selectIndex(2);
  @override
  void initState() {
    super.initState();
    _getData();
    _groupButtonController.selectIndex(2);
  }

  @override
  void dispose() {
    _groupButtonController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _AllCastScreenDirectChild oldWidget) {
    if (widget.mid != oldWidget.mid) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  _getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    loading = true;
    var originalPeople = await getFullCreditApi(widget.mid);

    //合并同一人不同角色/职责
    var peopleRemovedDup = <String, FullCreditPersonBean>{};
    for (var p in originalPeople) {
      if (!peopleRemovedDup.containsKey(p.personId)) {
        peopleRemovedDup[p.personId!] = p;
      } else {
        peopleRemovedDup[p.personId!]!.personCredit =
            '${peopleRemovedDup[p.personId!]!.personCredit} / ${p.personCredit}';
      }
    }

    _people = peopleRemovedDup.values.toList();
    for (var i = 0; i < _people.length; i++) {
      if (_people[i].personAvatar ==
          'https://m.media-amazon.com/images/S/sash/N1QWYSqAfSJV62Y.png') {
        _people[i].personAvatar = '';
      }
    }
    _people.sort(((a, b) =>
        b.personAvatar.toString().compareTo(a.personAvatar.toString())));
    for (var p in _people) {
      if (notBlank(p.personName)) {
        _autoCompletes.add(p.personName!.toLowerCase());
      }
      if (notBlank(p.personCredit)) {
        _autoCompletes.add(p.personCredit!.toLowerCase());
      }
    }
    // print(_people[0].personAvatar);
    _filteredPeople.addAll(_people);

    _makeTypes();
    _typed();
    loading = false;
    if (mounted) setState(() {});
  }

  void _makeTypes() {
    _types = _filteredPeople.map((e) => e.personType).toSet();
    _types.add('ALL');
    _types = _types.map((e) => e!.toUpperCase()).toSet();
  }

  final Lock lock = Lock();
  final List<String> _autoCompletes = [];
  @override
  Widget build(BuildContext context) {
    debugPrint('types=$_types');
    return Scaffold(
      appBar: AppBar(title: const Text('All cast & crew')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenHeight(context),
                width: screenWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          Expanded(
                            child: Autocomplete<String>(
                              optionsBuilder: ((textEditingValue) {
                                _onTextValueChange(textEditingValue.text);
                                if (textEditingValue.text == '') {
                                  return [];
                                }
                                return _autoCompletes.where((element) =>
                                    element.contains(
                                        textEditingValue.text.toLowerCase()));
                              }),
                              onSelected: _onTextValueChange,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      '${_people.length} People',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    // type selection buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          MyGroupButton(
                            controller: _groupButtonController,
                            onSelected: (value, index, isSelected) {
                              debugPrint('$value button is selected');
                              _typeSelected =
                                  '$value'.toUpperCase().replaceAll(' ', '_');
                              _typed();

                              setState(() {});
                            },
                            buttons: _types
                                .map((e) => capInitial(e?.replaceAll('_', ' ')))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    _typedAndFilteredPeople.isEmpty
                        ? const Center(child: Text('No result'))
                        : Expanded(
                            child: ListView.builder(
                              // addAutomaticKeepAlives: false,
                              itemCount: _typedAndFilteredPeople.length,
                              itemBuilder: (BuildContext context, int index) {
                                // debugPrint('itemBuilder');
                                var p = _typedAndFilteredPeople[index];
                                return PersonCardOfFullCastScreen(
                                  personId: p.personId!,
                                  name: p.personName,
                                  avatar: p.personAvatar,
                                  playAs: p.personCredit,
                                  type: p.personType!.toUpperCase(),
                                  movieId: widget.mid,
                                  isTvSeries: isTvSeries(widget.contentType),
                                  // contentType: widget.contentType,
                                  child:
                                      const PersonCardOfFullCastScreenMainChild(),
                                  // info: p.pl,
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
          heroTag: 'all cast screen FloatingActionButton ',
          child: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _filteredPeople;
            });
          }),
    );
  }

  void _onTextValueChange(String value) {
    List<FullCreditPersonBean> tmp = _filterNameAndCredit(value);
    setState(() {
      _filteredPeople = tmp;
      _makeTypes();
      _typed();
    });
  }

  void _typed() {
    debugPrint('_typed() called');
    if (_typeSelected == 'ALL') {
      _typedAndFilteredPeople = _filteredPeople;
    } else {
      _typedAndFilteredPeople = _filteredPeople
          .where(
            (element) =>
                element.personType!.toUpperCase() ==
                _typeSelected.toUpperCase(),
          )
          .toList();
    }
  }

  List<FullCreditPersonBean> _filterNameAndCredit(String value) {
    if (value == '') {
      return _people;
    }
    List<FullCreditPersonBean> tmp = [];
    for (var i = 0; i < _people.length; i++) {
      var e = _people[i];
      if (e.personName!.toLowerCase().contains(value.toLowerCase()) ||
          e.personCredit
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase())) {
        tmp.add(e);
      }
    }
    return tmp;
  }
}

bool isTvSeries(String? contentType) {
  return '$contentType'.toLowerCase().contains('tv') &&
      '$contentType'.toLowerCase().contains('series');
}
