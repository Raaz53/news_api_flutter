import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/model_class.dart';
import '../services/http_connection.dart';
import '../theme_notifier.dart';
import '../widget/tile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HttpConnection instance = HttpConnection();

  Future<void> _refreshData() async {
    setState(() {
      instance.getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Api',
          style: GoogleFonts.radioCanada(
              fontWeight: FontWeight.bold, fontSize: 30),
        ),
        actions: [
          Switch(
            value: themeNotifier.isDarkMode,
            onChanged: (value) {
              setState(() {
                themeNotifier.toggleTheme();
              });
            },
            thumbIcon: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const Icon(Icons.dark_mode_rounded);
              }
              return const Icon(Icons.light_mode);
            }),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<NewsApi>(
          future: instance.getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        instance.getData();
                      });
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(children: [
                        const Text('Failed to load data. Check connection'),
                        ElevatedButton(
                            onPressed: _refreshData, child: const Text('Retry'))
                      ]),
                    ),
                  ),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.articles!.isEmpty) {
              return const Center(
                child: Text('No data found'),
              );
            } else if (snapshot.hasData) {
              return TileWidget(fetchData: snapshot.data?.articles ?? []);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
