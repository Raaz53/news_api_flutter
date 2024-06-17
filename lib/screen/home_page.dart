import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/model_class.dart';
import '../services/http_connection.dart';
import '../theme_notifier.dart';
import '../widget/tile_widget.dart';

GlobalKey _formKey = GlobalKey<FormState>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HttpConnection instance = HttpConnection();

  final TextEditingController _controller = TextEditingController();
  String? query;

  Future<void> _refreshData() async {
    setState(() {
      query = _controller.text;
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
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _controller,
              minLines: 1,
              decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search_rounded),
                    color: Colors.grey[350],
                    onPressed: _refreshData,
                  )),
              style: GoogleFonts.montserrat(fontSize: 18),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: FutureBuilder<NewsApi>(
                future: instance.getData(query: query),
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
                              instance.getData(query: query);
                            });
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Column(children: [
                              const Text(
                                  'Failed to load data. Check connection'),
                              ElevatedButton(
                                  onPressed: _refreshData,
                                  child: const Text('Retry'))
                            ]),
                          ),
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles!.isEmpty) {
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
          ),
        ],
      ),
    );
  }
}
