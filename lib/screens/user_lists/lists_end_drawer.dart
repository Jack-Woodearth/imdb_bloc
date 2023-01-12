// import 'package:flutter/material.dart';

// class ListsEndDrawerFilterGroupWidget extends StatelessWidget {
//   const ListsEndDrawerFilterGroupWidget({
//     Key? key,
//     // required this.onGroupNameTap,
//     required this.currentFilterNameWidget,
//     required this.filterOptionsWidget,
//     required this.groupName,
//     required this.controllerTag,
//   }) : super(key: key);
//   // final VoidCallback onGroupNameTap;
//   final Widget currentFilterNameWidget;
//   final Widget filterOptionsWidget;
//   final String groupName;
//   final String controllerTag;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(groupName),
//                   currentFilterNameWidget
//                   // Obx(() => Text(
//                   //     '${Get.find<BoxOfficeListSortController>().sort}')),
//                 ],
//               ),
//               Obx(() => ExpandIcon(
//                   isExpanded:
//                       Get.find<ListsEndDrawerFilterGroupShowOptionsController>(
//                               tag: controllerTag)
//                           .show
//                           .value,
//                   onPressed: (v) {
//                     Get.find<ListsEndDrawerFilterGroupShowOptionsController>(
//                             tag: controllerTag)
//                         .show
//                         .value = !Get.find<
//                                 ListsEndDrawerFilterGroupShowOptionsController>(
//                             tag: controllerTag)
//                         .show
//                         .value;
//                   })),
//             ],
//           ),
//         ),
//         const Divider(
//           height: 1.0,
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Obx(() =>
//               Get.find<ListsEndDrawerFilterGroupShowOptionsController>(
//                           tag: controllerTag)
//                       .show
//                       .value
//                   ? filterOptionsWidget
//                   : const SizedBox()),
//         )
//       ],
//     );
//   }
// }
