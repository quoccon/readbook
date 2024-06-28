import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readbook/blocs/book/book_cubit.dart';
import 'package:readbook/blocs/cat/cat_cubit.dart';
import 'package:readbook/menu_drawre.dart';
import 'package:readbook/page/home/detail_book.dart';
import 'package:readbook/page/home/notification.dart';

import '../../model/user.dart';

class Home extends StatelessWidget {
  final Auth auth;

  const Home({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookCubit(), // Fetch books when initializing
        ),
        BlocProvider(
          create: (context) => CatCubit(),
        ),
      ],
      child: HomePage(auth: auth),
    );
  }
}

class HomePage extends StatefulWidget {
  final Auth auth;

  const HomePage({super.key, required this.auth});

  @override
  State<HomePage> createState() => _HomePageState();
}

final advencedDrawerController = AdvancedDrawerController();

class _HomePageState extends State<HomePage> {
  void drawerShow() {
    advencedDrawerController.showDrawer();
  }

  Future<void> _refreshData () async{
    context.read<BookCubit>().getListBook();
    context.read<CatCubit>().getCat();
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    context.read<BookCubit>().getListBook();
    context.read<CatCubit>().getCat();
    return AdvancedDrawer(
      openRatio: 0.55,
      openScale: 0.75,
      controller: advencedDrawerController,
      backdropColor: Colors.grey[200],
      rtlOpening: false,
      animationDuration: const Duration(milliseconds: 500),
      drawer:  MenuDrawre(auth: widget.auth),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              drawerShow();
            },
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Read Ease",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          actions:  [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationForm()));
                },
                  child: Icon(Icons.notifications_active)),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Thể loại truyện",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<CatCubit, CatState>(
                    builder: (context, state) {
                      if(state is CatInitial){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }else if(state is CatLoaded){
                        return SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.cat.length,
                            itemBuilder: (context, index) {
                              final cat = state.cat[index];
                              return Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    border:
                                    Border.all(width: 1, color: Color(0xfdededed))),
                                child: Center(
                                  child: Text(cat.nameCat??""),
                                ),
                              );
                            },
                          ),
                        );
                      }else if(state is CatError){
                        return Center(
                          child: Text(state.error),
                        );
                      }
                      return const Center(
                        child: Text("Trống"),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "10 truyện mới nhất",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Được lựa chọn những truyện được đăng mới nhất",
                    style: TextStyle(fontSize: 18, color: Color(0xff838589)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<BookCubit, BookState>(
                    builder: (context, state) {
                      if (state is BookLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is BookLoaded) {
                        return SizedBox(
                          height: 350,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.dataBook.length,
                            itemBuilder: (context, index) {
                              final book = state.dataBook[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailBookWrapper(
                                                  book: book,
                                                  auth: widget.auth)));
                                },
                                child: Container(
                                  width: 180,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        book?.image ?? "",
                                        width: 200,
                                        height: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        book.title ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        book.description ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is BookError) {
                        return Center(
                          child: Text(state.error),
                        );
                      }
                      return const Center(
                        child: Text("Không có sách"),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "Truyện dành cho bạn",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Được lọc từ những truyện liên quan bạn đã đọc",
                    style: TextStyle(fontSize: 18, color: Color(0xff838589)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // BlocBuilder<BookCubit, BookState>(
                  //   builder: (context, state) {
                  //     if (state is BookLoading) {
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     } else if (state is BookLoaded) {
                  //       return SizedBox(
                  //         height: 350,
                  //         child: ListView.builder(
                  //           scrollDirection: Axis.horizontal,
                  //           itemCount: state.books.length,
                  //           itemBuilder: (context, index) {
                  //             final book = state.books[index];
                  //             return Container(
                  //               width: 180,
                  //               margin: const EdgeInsets.only(right: 10),
                  //               decoration: const BoxDecoration(
                  //                 borderRadius:
                  //                 BorderRadius.all(Radius.circular(20)),
                  //               ),
                  //               child: Column(
                  //                 children: [
                  //                   Image.network(
                  //                     book.image,
                  //                     fit: BoxFit.cover,
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 10,
                  //                   ),
                  //                   Text(
                  //                     book.title,
                  //                     style: const TextStyle(
                  //                         fontWeight: FontWeight.w600),
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 8,
                  //                   ),
                  //                   Text(
                  //                     book.description,
                  //                     maxLines: 2,
                  //                     overflow: TextOverflow.ellipsis,
                  //                   )
                  //                 ],
                  //               ),
                  //             );
                  //           },
                  //         ),
                  //       );
                  //     } else if (state is BookError) {
                  //       return Center(
                  //         child: Text(state.error),
                  //       );
                  //     }
                  //     return const Center(
                  //       child: Text("Không có sách"),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
