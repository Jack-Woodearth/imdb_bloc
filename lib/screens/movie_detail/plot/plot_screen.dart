import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imdb_bloc/beans/details.dart';

class PlotScreen extends StatelessWidget {
  const PlotScreen({super.key, required this.movieBeanStr, required this.plot});
  final String movieBeanStr;
  final String plot;
  @override
  Widget build(BuildContext context) {
    final paragraphs = plot.split('\n');
    final movieBean = MovieBean.fromJson(jsonDecode(movieBeanStr));
    return Scaffold(
      appBar: AppBar(title: Text('${movieBean.title}(${movieBean.yearRange})')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: paragraphs.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(paragraphs[index]);
          },
        ),
      ),
    );
  }
}
