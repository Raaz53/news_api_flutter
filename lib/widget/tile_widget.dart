import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/screen/article_page.dart';
import 'package:timeago/timeago.dart' as time_ago;

class TileWidget extends StatelessWidget {
  const TileWidget({
    super.key,
    required this.fetchData,
  });

  final List<Article> fetchData;

  @override
  Widget build(BuildContext context) {
    final filteredData = fetchData.where((article) {
      return !(article.title?.contains('[Removed]') ?? true) &&
          !(article.description?.contains('[Removed]') ?? true);
    }).toList();

    return filteredData.isEmpty
        ? const Center(child: Text('The list is empty'))
        : ListView.builder(
            itemCount: filteredData.length,
            itemBuilder: (context, int index) {
              final singleData = filteredData[index];

              return index == 0
                  ? ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ArticlePage(article: singleData))),
                      title: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Image.network(
                            singleData.urlToImage ??
                                'https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square.webp',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Text(singleData.title ?? 'No title',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(time_ago.format(
                                singleData.publishedAt ?? DateTime.now(),
                                locale: '')),
                          ),
                          const Divider(
                            thickness: 1,
                            endIndent: 5,
                          )
                        ],
                      ),
                    )
                  : ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ArticlePage(article: singleData))),
                      title: Text(singleData.title ?? 'No title',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                width: MediaQuery.of(context).size.width * 0.2,
                                height: MediaQuery.of(context).size.width * 0.2,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  child: Image.network(
                                    singleData.urlToImage ??
                                        'https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square.webp',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Text(
                                      singleData.description ??
                                          'No description available',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(time_ago.format(
                                          singleData.publishedAt ??
                                              DateTime.now(),
                                          locale: '')),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            endIndent: 5,
                          )
                        ],
                      ),
                    );
            });
  }
}
