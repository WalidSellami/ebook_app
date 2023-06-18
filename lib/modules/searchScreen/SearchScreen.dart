import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebook/models/bookModel/BookModel.dart';
import 'package:ebook/modules/detailsBookScreen/DetailsBookScreen.dart';
import 'package:ebook/shared/components/Components.dart';
import 'package:ebook/shared/cubit/Cubit.dart';
import 'package:ebook/shared/cubit/States.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , index) {},
      builder: (context , index) {

        var cubit = AppCubit.get(context);
        var bookData = cubit.bookDataModel;

        return WillPopScope(
          onWillPop: () async {
            cubit.getBooks(context);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  if(cubit.bookDataModel == null) {
                    cubit.getBooks(context);
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                ),
                tooltip: 'Back',
              ),
              title: const Text(
                'Search Book',
              ),
            ),
            body: searchBody(bookData),
          ),
        );
      },
    );
  }

  Widget searchBody(BookModel? book) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: 'Type ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    width: 2.0,
                  ),
                ),
                prefixIcon: const Icon(
                  EvaIcons.searchOutline,
                ),
                suffixIcon: (searchController.text.isNotEmpty)
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            searchController.text = '';
                          });
                          AppCubit.get(context).clearSearchBooks();
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                        ),
                      )
                    : null,
              ),
              onChanged: (value) {
                if(AppCubit.get(context).hasInternet) {
                  AppCubit.get(context).searchBook(value: value, context: context);
                } else {
                  showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                }
              },
              onFieldSubmitted: (value) {
                if(value.isNotEmpty && AppCubit.get(context).hasInternet) {
                  AppCubit.get(context).searchBook(value: value, context: context);
                } else {
                  showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                }
              },
            ),
             const SizedBox(
               height: 16.0,
             ),
             AppCubit.get(context).hasInternet ? Expanded(
               child: ConditionalBuilder(
                condition: (book?.items.length ?? 0) > 0,
                builder: (context) => ListView.separated(
                    itemBuilder: (context , index) => buildItemSearchBook(book!.items[index]),
                    separatorBuilder: (context , index) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                      ),
                      child: Divider(
                        thickness: 0.7,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    itemCount: book?.items.length ?? 0),
                fallback: (context) => const Center(
                  child: Text(
                    'There is no books',
                    style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ),
             ) : const Center(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
                     'No Internet',
                     style: TextStyle(
                       fontSize: 19.0,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   SizedBox(
                     width: 8.0,
                   ),
                   Icon(EvaIcons.wifiOffOutline),
                 ],
               ),
             ),
          ],
        ),
      );

  Widget buildItemSearchBook(ItemsData model) => InkWell(
    borderRadius: BorderRadius.circular(3.0),
    onTap: () {
      if(AppCubit.get(context).hasInternet) {
        Navigator.of(context).push(createRoute(screen: DetailsBookScreen(itemData: model)));
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 14.0,
      ),
      child: Row(
        children: [
          const Text(
            '-',
            style: TextStyle(
              fontSize: 17.0,
            ),
          ),
          const SizedBox(
            width: 30.0,
          ),
          Expanded(
            child: Text(
              '${model.volumeInfo?.title}',
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 17.0,
          ),
        ],
      ),
    ),
  );
}
