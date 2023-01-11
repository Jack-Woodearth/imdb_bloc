import 'package:flutter/material.dart';

import 'package:sliver_tools/sliver_tools.dart';

import '../../beans/box_office_bean.dart';
import '../../constants/config_constants.dart';
import '../../utils/date_utils.dart';
import '../../widgets/TitleAndSeeAll.dart';
import '../../widgets/WatchListIcon.dart';
import '../../widgets/YellowDivider.dart';
import '../../widgets/my_network_image.dart';

class BoxOfficeWidget extends StatelessWidget {
  const BoxOfficeWidget({Key? key, required this.boxOfficeBeans})
      : super(key: key);
  final List<BoxOfficeBean> boxOfficeBeans;
  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndSeeAll(
          title: 'Top box office (US)',
          onTap: () {
            //todo
            // Get.to(() => BoxOfficeListScreen(boxOfficeList: boxOfficeBeans));
          },
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
          child: Text(getLatestWeekend()),
        ),
        if (boxOfficeBeans.isNotEmpty)
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            final e = boxOfficeBeans[index];
            return InkWell(
              onTap: () {
                //todo
                // Get.to(() => MovieFullDetailScreenLazyLoad(mid: e.mid!));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: 20,
                        child: Text('${boxOfficeBeans.indexOf(e) + 1}')),
                    const SizedBox(
                      width: 5,
                    ),
                    const YellowDivider(),
                    const SizedBox(
                      width: 10,
                    ),
                    WatchListIcon(id: e.mid!),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: AspectRatio(
                        aspectRatio: 2 / 3,
                        child: MyNetworkImage(url: e.poster ?? defaultCover),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${e.title}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text('${e.weekend}')
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }, childCount: boxOfficeBeans.length)),
        // Column(
        //   children: boxOfficeBeans
        //       .map((e) => InkWell(
        //             onTap: () {
        //               Get.to(() => MovieFullDetailScreenLazyLoad(mid: e.mid!));
        //             },
        //             child: Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Row(
        //                 children: [
        //                   Container(
        //                       alignment: Alignment.centerRight,
        //                       width: 20,
        //                       child: Text('${boxOfficeBeans.indexOf(e) + 1}')),
        //                   const SizedBox(
        //                     width: 5,
        //                   ),
        //                   const YellowDivider(),
        //                   const SizedBox(
        //                     width: 10,
        //                   ),
        //                   WatchListIcon(id: e.mid!),
        //                   const SizedBox(
        //                     width: 10,
        //                   ),
        //                   Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         '${e.title}',
        //                         style: Theme.of(context).textTheme.titleSmall,
        //                       ),
        //                       Text('${e.weekend}')
        //                     ],
        //                   )
        //                 ],
        //               ),
        //             ),
        //           ))
        //       .toList(),
        // ),
      ],
    );
  }
}
