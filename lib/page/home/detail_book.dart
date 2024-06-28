import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readbook/blocs/auth/auth_cubit.dart';
import 'package:readbook/blocs/book/comment_cubit.dart';
import 'package:readbook/page/home/read_content.dart';
import 'package:readbook/blocs/withlist/withlist_cubit.dart';

import '../../model/book.dart';
import '../../model/user.dart';

class DetailBookWrapper extends StatelessWidget {
  final Book book;
  final Auth auth;

  const DetailBookWrapper({super.key, required this.book, required this.auth});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => CommentCubit(),
        ),
      ],
      child: DetailBook(book: book, auth: auth),
    );
  }
}

class DetailBook extends StatefulWidget {
  final Book book;
  final Auth auth;

  const DetailBook({super.key, required this.book, required this.auth});

  @override
  State<DetailBook> createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  bool isWithlist = false;
  bool isExpande = false;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    String? bookId = widget.book.id ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommentCubit>().getComment(bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    String? userId = widget.auth.user?.id ?? "";
    String? bookId = widget.book.id ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.notifications_active),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  widget.book.image ?? "",
                  height: 500,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.title ?? "",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.book.author ?? "",
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xff3d3968),
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.book.description ?? "",
                          maxLines: isExpande ? null : 2,
                          overflow: isExpande
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, color: Color(0xff817e9c)),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              isExpande = !isExpande;
                            });
                          },
                          child: Text(
                            isExpande ? "Thu gọn" : "Xem thêm",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: const ButtonStyle(
                              backgroundColor:
                              MaterialStatePropertyAll(Colors.red)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReadContent(
                                        content: widget.book.content,
                                        title: widget.book.title)));
                          },
                          child: const Center(
                            child: Text(
                              "Đọc truyện",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    // onTap: () {
                    //   context
                    //       .read<AuthCubit>()
                    //       .addWithList(userId, bookId);
                    //   if (state is Auth) {
                    //     setState(() {
                    //       if(isWithlist) {
                    //         isWithlist = true;
                    //       }else{
                    //         isWithlist = false;
                    //       }
                    //     });
                    //     ScaffoldMessenger.of(context)
                    //         .showSnackBar(SnackBar(
                    //       content: isWithlist
                    //           ? Text("Xóa khỏi yêu thích thành công")
                    //           : Text("Thêm vào yêu thích thành công"),
                    //     ));
                    //   }
                    // },
                    child: isWithlist
                        ? Image.asset(
                      "assets/images/withlist.png",
                      fit: BoxFit.cover,
                      width: 20,
                      height: 25,
                    )
                        : Image.asset(
                      "assets/images/withlist.png",
                      color: Colors.grey,
                      fit: BoxFit.cover,
                      width: 20,
                      height: 25,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Color(0xffededed),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Bình luận",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: commentController,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Viết bình luận",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon:  InkWell(
                    onTap: (){
                      context.read<CommentCubit>().addComment(userId, bookId, commentController.text);

                    },
                      child:commentController.text.isEmpty ? Icon(Icons.send,color: Colors.blue,) : Icon(Icons.send,color: Colors.grey,) ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<CommentCubit, CommentState>(
                builder: (context, state) {
                  if (state is CommentInitial) {
                    return const Center(
                      child: Text("Sách chưa có bình luận nào"),
                    );
                  } else if (state is CommentLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.comment.length,
                      itemBuilder: (context, index) {
                        final comment = state.comment[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comment.userId?.username ?? "",style: TextStyle(fontSize: 15),),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(comment.coment ?? "")
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color(0xffededed),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is CommentError) {
                    return Center(
                      child: Text(state.error),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
