import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../apis/list_repr_images_api.dart';
import '../beans/list_resp.dart';
import '../constants/config_constants.dart';
import '../utils/common.dart';
import '../utils/string/string_utils.dart';
import 'my_network_image.dart';

class UserListList extends StatefulWidget {
  const UserListList({
    Key? key,
    required this.userList,
    required this.onDelete,
    // this.from,
  }) : super(key: key);

  final ListResult userList;
  final Function(BuildContext) onDelete;
  // final String? from;
  @override
  State<UserListList> createState() => _UserListListState();
}

class _UserListListState extends State<UserListList> {
  @override
  void initState() {
    super.initState();
    // debugPrint('_UserListListState initState');
    _getData();
  }

  @override
  void didUpdateWidget(covariant UserListList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userList.listUrl != widget.userList.listUrl) {
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: GlobalKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: widget.onDelete,
            backgroundColor: const Color.fromARGB(255, 173, 31, 10),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          // SlidableAction(
          //   onPressed: (_) {},
          //   backgroundColor: Color(0xFF0392CF),
          //   foregroundColor: Colors.white,
          //   icon: Icons.save,
          //   label: 'Save',
          // ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Get.to(() =>
          //     // UserListDetailsScreen(
          //     //       // listUrl: widget.userList.listUrl ?? '',
          //     //       // title: widget.userList.listName ?? '',
          //     //       // isPeopleList: widget.userList.isPeopleList == true,
          //     //       listResult: ListResult.fromJson(widget.userList.toJson()),
          //     //     ),
          //     NewListScreen(listUrl: widget.userList.listUrl ?? ''));
        },
        child: SizedBox(
          width: screenWidth(context),
          child: Row(
            children: [
              SizedBox(
                  width: 50,
                  child: MyNetworkImage(
                    url: _cover ?? defaultCover,
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        '${widget.userList.listName}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      AutoSizeText('${widget.userList.listDescription}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _cover = defaultCover;
  _getData() async {
    // debugPrint('_UserListListState _getData');

    // _cover = await getListCoverApi(widget.userList.listUrl ?? '');

    if (isBlank(widget.userList.cover)) {
      if (widget.userList.listUrl != null) {
        var first =
            (await getListReprImagesApi(widget.userList.listUrl!)).first;
        if (!isBlank(first)) {
          _cover = first;
        }
      }
    } else {
      _cover = widget.userList.cover;
    }
    if (mounted) {
      setState(() {});
    }
  }
}
