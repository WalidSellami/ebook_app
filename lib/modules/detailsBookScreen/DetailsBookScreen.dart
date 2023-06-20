import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebook/models/bookModel/BookModel.dart';
import 'package:ebook/modules/webViewScreen/WebViewScreen.dart';
import 'package:ebook/shared/adaptive/CircularLoadingAdaptive.dart';
import 'package:ebook/shared/adaptive/CircularRingAdaptive.dart';
import 'package:ebook/shared/components/Components.dart';
import 'package:ebook/shared/components/Constants.dart';
import 'package:ebook/shared/cubit/Cubit.dart';
import 'package:ebook/shared/cubit/States.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class DetailsBookScreen extends StatelessWidget {
  final ItemsData itemData;

  const DetailsBookScreen({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        var booksData = cubit.bookDataModel;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 30.0,
              ),
              tooltip: 'Close',
            ),
          ),
          body: cubit.hasInternet
              ? detailsBookBody(booksData, context)
              : const Center(
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
        );
      },
    );
  }

  Widget detailsBookBody(BookModel? bookData, context) =>
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  await showImage(context, 'imageDetail',
                      '${itemData.volumeInfo?.imageLinks?.thumbnail}');
                },
                child: Hero(
                  tag: 'imageDetail',
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      '${itemData.volumeInfo?.imageLinks?.thumbnail}',
                      fit: BoxFit.fill,
                      height: 230.0,
                      width: 170.0,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Container(
                            height: 230.0,
                            width: 170.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child:
                            Center(child: CircularRingAdaptive(os: getOs())),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 230.0,
                          width: 170.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: const Center(
                            child: Text(
                              'Failed to load',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                    text: '${itemData.volumeInfo?.title} ',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      if(itemData.volumeInfo?.publishedDate != null)
                      TextSpan(
                        text: ' (${((itemData.volumeInfo?.publishedDate?.length ?? 0) > 10) ? itemData.volumeInfo?.publishedDate?.substring(0,10) : itemData.volumeInfo?.publishedDate})',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
              ),
              if (itemData.volumeInfo?.authors != null)
                const SizedBox(
                  height: 14.0,
                ),
              if (itemData.volumeInfo?.authors != null)
                Text(
                  '${itemData.volumeInfo?.authors?.join(',')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              // const SizedBox(
              //   height: 14.0,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Icon(
              //       EvaIcons.star,
              //       color: HexColor('ffdd4f'),
              //     ),
              //     const SizedBox(
              //       width: 4.0,
              //     ),
              //     Text(
              //       '${itemData.volumeInfo?.averageRating ?? 'Not Rating'}',
              //       style: const TextStyle(
              //         fontSize: 14.5,
              //         // fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (itemData.accessInfo?.epub?.downloadLink != null)
                    SizedBox(
                      width: 120.0,
                      child: MaterialButton(
                        height: 45.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: HexColor('009b9b').withOpacity(.8),
                        onPressed: () {
                          if (AppCubit
                              .get(context)
                              .hasInternet) {
                            String? url = itemData.accessInfo?.epub?.downloadLink;
                            url = url?.replaceFirst('http://', 'https://');
                            Navigator.of(context).push(createSecondRoute(
                                screen: WebViewScreen(
                                    url: url)));
                          } else {
                            showFlutterToast(
                                message: 'No Internet Connection',
                                state: ToastStates.error,
                                context: context);
                          }
                        },
                        child: const Text(
                          'Get it',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (itemData.accessInfo?.epub?.downloadLink != null)
                    const SizedBox(
                      width: 30.0,
                    ),
                  SizedBox(
                    width: 120.0,
                    child: MaterialButton(
                      height: 45.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: HexColor('4bb1fe').withOpacity(.7),
                      onPressed: () {
                        if (AppCubit
                            .get(context)
                            .hasInternet) {
                          String? url = itemData.volumeInfo?.previewLink;
                          url = url?.replaceFirst('http://', 'https://');
                          Navigator.of(context).push(createSecondRoute(
                              screen: WebViewScreen(
                                  url: url)));
                        } else {
                          showFlutterToast(
                              message: 'No Internet Connection',
                              state: ToastStates.error,
                              context: context);
                        }
                      },
                      child: const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50.0,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'You can also like',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              SizedBox(
                height: 160.0,
                child: ConditionalBuilder(
                  condition: (bookData?.items.length ?? 0) > 0,
                  builder: (context) =>
                      ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) =>
                              buildItemOtherBook(bookData!.items[index], context),
                          separatorBuilder: (context, index) =>
                          const SizedBox(
                            width: 12.0,
                          ),
                          itemCount: bookData?.items.length ?? 0),
                  fallback: (context) =>
                  const Center(
                      child: Text(
                        'There is no books yet',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      );

  Widget buildItemOtherBook(ItemsData model, context) =>
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(createRoute(
              screen: DetailsBookScreen(
                itemData: model,
              )));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(
            '${model.volumeInfo?.imageLinks?.smallThumbnail}',
            fit: BoxFit.fill,
            height: 160.0,
            width: 115.0,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return child;
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Container(
                  height: 160.0,
                  width: 110.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(child: CircularRingAdaptive(os: getOs())),
                );
              }
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 160.0,
                width: 110.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text(
                    'Failed to load',
                    style: TextStyle(fontSize: 13.0),
                  ),
                ),
              );
            },
          ),
        ),
      );

  Future showImage(BuildContext context, String tag, image) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                      ),
                    ),
                  ),
                  body: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Hero(
                        tag: tag,
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: Image.network(
                            '$image',
                            height: 450.0,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            frameBuilder: (context, child, frame,
                                wasSynchronouslyLoaded) {
                              return child;
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return SizedBox(
                                    height: 450.0,
                                    width: double.infinity,
                                    child: Center(
                                        child: CircularLoadingAdaptive(
                                            os: getOs())));
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Scaffold(
                                body: Center(
                                  child: SizedBox(
                                      height: 450.0,
                                      width: double.infinity,
                                      child: Center(
                                          child: Text(
                                            'Failed to load',
                                            style: TextStyle(fontSize: 16.0),
                                          ))),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )));
  }

}
