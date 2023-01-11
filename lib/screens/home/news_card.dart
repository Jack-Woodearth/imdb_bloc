import 'package:flutter/material.dart';

import '../../beans/news.dart';
import '../../constants/config_constants.dart';
import '../../widgets/my_network_image.dart';

class NewsCard extends StatelessWidget {
  // final String url;

  // final String title;

  // final String date;
  final NewsBean newsBean;
  const NewsCard({Key? key, required this.newsBean}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //todo
        // Get.to(() => NewsDetailScreen(newsBean: newsBean));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: MyNetworkImage(url: newsBean.image ?? defaultAvatar),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsBean.date ?? '',
                        style: tinyTitle,
                      ),
                      Text(
                        newsBean.title ?? '',
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        newsBean.content ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
