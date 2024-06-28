import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readbook/blocs/book/book_cubit.dart';
import 'package:readbook/page/home/detail_book.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class Search extends StatelessWidget {
  final Auth auth;

  const Search({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => BookCubit(),
        child: ExplorePage(
          auth: auth,
        ),
      ),
    );
  }
}

class ExplorePage extends StatefulWidget {
  final Auth auth;

  const ExplorePage({super.key, required this.auth});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<String> recentSearch = [];
  TextEditingController searchController = TextEditingController();
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    _loadRecentSearch();
    searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    searchController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void _onSearch() {
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      final query = searchController.text;
      if (query.isNotEmpty) {
        context.read<BookCubit>().searchBook(query);
        // _saveRecentSearch(query);
      } else {
        context.read<BookCubit>().clearSearch();
      }
    });
  }

  _loadRecentSearch() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      recentSearch = preferences.getStringList('recent') ?? [];
    });
  }

  _saveRecentSearch(String search) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!recentSearch.contains(search)) {
      recentSearch.add(search);

      if (recentSearch.length > 10) {
        recentSearch.removeAt(0);
      }

      await sharedPreferences.setStringList('recent', recentSearch);
      setState(() {});
    }
  }

  _clearSearch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('recent');
    setState(() {
      recentSearch = [];
    });
  }

  _clearSearchItem(String search) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    recentSearch.remove(search);
    await sharedPreferences.setStringList('recent', recentSearch);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text('Tìm Sách', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.grey[200]),
              child: TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm tại đây ...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        searchController.clear();
                      },
                      child: const Icon(Icons.clear)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (recentSearch.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lịch sử tìm kiếm',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...recentSearch.map(
                    (search) => ListTile(
                      title: GestureDetector(
                          onTap: () {
                            searchController.text = search;
                          },
                          child: Text(search)),
                      trailing: GestureDetector(
                          onTap: () {
                            _clearSearchItem(search);
                          }, child: Icon(Icons.clear)),
                    ),
                  ),
                  TextButton(
                      onPressed: _clearSearch,
                      child: const Text("Clear Search"))
                ],
              ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocBuilder<BookCubit, BookState>(
                builder: (context, state) {
                  if (state is BookLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BookLoaded) {
                    return ListView.builder(
                      itemCount: state.dataBook.length,
                      itemBuilder: (context, index) {
                        final book = state.dataBook[index];
                        final query = searchController.text;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kết quả tìm kiếm",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailBookWrapper(
                                            book: book, auth: widget.auth)));
                                _saveRecentSearch(query);
                              },
                              child: ListTile(
                                leading: Image.network(
                                  book.image ?? "",
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(book.title ?? ""),
                                subtitle: Text(book.author ?? ""),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is BookError) {
                    return Center(child: Text(state.error));
                  } else {
                    return  Center(child:  Container());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
