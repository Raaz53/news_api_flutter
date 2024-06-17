import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key, required this.article});

  final Article article;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.article.source?.id != null
                      ? '${widget.article.source?.id}\n${widget.article.source?.name}'
                      : '${widget.article.source?.name}',
                  style: GoogleFonts.oswald(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),
              Text(
                '${widget.article.title}',
                style: GoogleFonts.robotoCondensed(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.article.description}',
                style: GoogleFonts.robotoCondensed(fontSize: 13),
              ),
              Link(
                  uri: Uri.parse(widget.article.url ?? ''),
                  target: LinkTarget.self,
                  builder: (context, openLink) => TextButton(
                      onPressed: openLink,
                      child: Text('${widget.article.url}'))),
              SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    widget.article.urlToImage ??
                        'https://ipsf.net/wp-content/uploads/2021/12/dummy-image-square.webp',
                    fit: BoxFit.cover,
                  )),
              Text(
                '${widget.article.content}',
                style: GoogleFonts.robotoCondensed(fontSize: 13),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.article.author}',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 9, fontStyle: FontStyle.italic),
                  ),
                  Text(
                    '${widget.article.publishedAt}',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 9, fontStyle: FontStyle.italic),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
