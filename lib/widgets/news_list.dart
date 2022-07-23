import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_news/models/article.dart';
import 'package:flutter_news/models/news_page.dart';
import 'package:flutter_news/services/news_api.dart';
import 'package:flutter_news/widgets/news_item.dart';
import 'package:flutter/material.dart' as material;

class NewsListPage extends StatefulWidget {
  final NewsPage newsPage;
  final NewsAPI newsAPI = const NewsAPI();
  const NewsListPage({Key? key, required this.newsPage}) : super(key: key);

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = widget.newsAPI.fetchArticles(widget.newsPage.category);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
        header: PageHeader(
          title: Text(widget.newsPage.title),
        ),
        content: FutureBuilder<List<Article>>(
            future: futureArticles,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 270,
                        mainAxisExtent: 290,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    padding: EdgeInsets.all(16),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, index) {
                      return NewsItem(
                        article: snapshot.data![index],
                      );
                    });
              } else if (snapshot.hasError) {
                Typography typography = FluentTheme.of(context).typography;
                return Column(
                  children: [
                    Spacer(),
                    Center(
                      child: Text(
                        '$snapshot.error',
                        style: typography.bodyStrong,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FilledButton(
                        child: Text('Refresh'),
                        onPressed: () {
                          setState(() {
                            futureArticles = widget.newsAPI
                                .fetchArticles(widget.newsPage.category);
                          });
                        }),
                    Spacer(),
                  ],
                );
              }
              return Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: ProgressRing(),
                ),
              );
            }));
  }
}
