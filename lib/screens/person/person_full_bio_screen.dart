import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../apis/person.dart';
import '../../utils/common.dart';

class PersonFullBioScreen extends StatefulWidget {
  const PersonFullBioScreen({Key? key, required this.pid}) : super(key: key);
  final String pid;
  @override
  State<PersonFullBioScreen> createState() => _PersonFullBioScreenState();
}

class _PersonFullBioScreenState extends State<PersonFullBioScreen> {
  final _bio = [];
  final _data = <BioItem>[];
  @override
  void didUpdateWidget(covariant PersonFullBioScreen oldWidget) {
    if (oldWidget.pid != widget.pid) {
      _getData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  final List<bool> _hideSubBio = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bio'),
      ),
      body: SingleChildScrollView(
        // controller:
        child: ExpansionPanelList(
          // expandedHeaderPadding: const EdgeInsets.all(8.0),
          expansionCallback: ((panelIndex, isExpanded) {
            // _hideSubBio[panelIndex] = isExpanded;
            _data[panelIndex].isExpanded = !isExpanded;
            setState(() {});
            debugPrint('isExpanded=$isExpanded');
          }),
          children: _data
              .map((_bioItem) => ExpansionPanel(
                  canTapOnHeader: true,
                  isExpanded: _bioItem.isExpanded,
                  headerBuilder: ((context, isExpanded) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _bioItem.header.trim(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (_bioItem.details)
                        .map(
                          (bioDetail) => SizedBox(
                            width: screenWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${_bioItem.details.indexOf(bioDetail) + 1}. $bioDetail'
                                    .replaceAll(RegExp(r'\n{2,}'), '\n')
                                    .replaceAll(RegExp(r'\s{2,}'), ' ')
                                    .replaceAll(
                                        RegExp(r'(<br/>)|(<br>)|(</br>)'),
                                        '\n'),
                                // .replaceAll(RegExp(r'\n\n\n+'), '\n'),
                                // textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )))
              .toList(),
        ),
      ),
    );
  }

  void _getData() async {
    EasyLoading.show();
    var res = await getPersonFullBio(widget.pid);
    // _bio.clear();
    // _bio.addAll(res);
    // _hideSubBio = List.filled(_bio.length, false);

    _data.clear();
    _data.addAll(((res ?? []) as List)
        .map((e) => BioItem(isExpanded: false, header: e[0], details: e[1])));
    if (mounted) {
      setState(() {});
    }
    EasyLoading.dismiss();
  }
}

class BioItem {
  bool isExpanded;
  final String header;
  final List details;
  BioItem({
    required this.isExpanded,
    required this.header,
    required this.details,
  });
}
