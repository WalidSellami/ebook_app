import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebook/models/bookModel/BookModel.dart';
import 'package:ebook/modules/detailsBookScreen/DetailsBookScreen.dart';
import 'package:ebook/modules/searchScreen/SearchScreen.dart';
import 'package:ebook/shared/adaptive/CircularLoadingAdaptive.dart';
import 'package:ebook/shared/adaptive/CircularRingAdaptive.dart';
import 'package:ebook/shared/components/Components.dart';
import 'package:ebook/shared/components/Constants.dart';
import 'package:ebook/shared/cubit/Cubit.dart';
import 'package:ebook/shared/cubit/States.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> refreshIndicator =
      GlobalKey<RefreshIndicatorState>();

  int pressed = 0;

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    return Builder(
      builder: (context) {
        AppCubit.get(context).getBooks(context);
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var booksData = cubit.bookDataModel;

            return WillPopScope(
              onWillPop: () async {
                final difference = DateTime.now().difference(timeBackPressed);
                final isExitWarning = difference >= const Duration(seconds: 1);
                timeBackPressed = DateTime.now();

                if (isExitWarning) {
                  const message = 'Press back again to exit';
                  showToast(
                    message,
                    context: context,
                    backgroundColor: Colors.grey.shade800,
                    animation: StyledToastAnimation.scale,
                    reverseAnimation: StyledToastAnimation.fade,
                    position: StyledToastPosition.bottom,
                    animDuration: const Duration(milliseconds: 1500),
                    duration: const Duration(seconds: 4),
                    curve: Curves.elasticOut,
                    reverseCurve: Curves.linear,
                  );

                  return false;
                } else {
                  SystemNavigator.pop();
                  return true;
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'EBooK',
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (cubit.hasInternet) {
                          Navigator.of(context)
                              .push(createRoute(screen: const SearchScreen()));
                        } else {
                          pressed++;
                          showFlutterToast(
                              message: 'No Internet Connection',
                              state: ToastStates.error,
                              context: context);
                          if (pressed == 3) {
                            showAlert(context);
                            setState(() {
                              pressed = 0;
                            });
                          }
                        }
                      },
                      icon: const Icon(
                        EvaIcons.searchOutline,
                      ),
                      tooltip: 'Search',
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                  ],
                ),
                body: cubit.hasInternet
                    ? ConditionalBuilder(
                        condition: (booksData?.items.length ?? 0) > 0,
                        builder: (context) => homebody(booksData),
                        fallback: (context) => (state
                                    is LoadingGetBooksAppState ||
                                booksData == null)
                            ? Center(child: CircularLoadingAdaptive(os: getOs()))
                            : const Center(
                                child: Text(
                                'There is no books yet',
                                style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                      )
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
              ),
            );
          },
        );
      }
    );
  }

  Widget homebody(BookModel? book) => RefreshIndicator(
        key: refreshIndicator,
        backgroundColor: HexColor('181818'),
        strokeWidth: 2.5,
        onRefresh: () async {
          AppCubit.get(context).getBooks(context);
          return Future<void>.delayed(const Duration(seconds: 2));
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 210.0,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildItemBook(book!.items[index], context),
                      separatorBuilder: (context, index) => const SizedBox(
                            width: 14.0,
                          ),
                      itemCount: book?.items.length ?? 0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text('Other Books',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 16.0,
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) =>
                        buildItemBestBook(book!.items[index], context, index),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10.0,
                        ),
                    itemCount: book?.items.length ?? 0),
              ],
            ),
          ),
        ),
      );

  Widget buildItemBook(ItemsData model, context) => GestureDetector(
        onTap: () {
          if (AppCubit.get(context).hasInternet) {
            Navigator.of(context).push(createRoute(
                screen: DetailsBookScreen(
              itemData: model,
            )));
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              12.0,
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network(
            '${model.volumeInfo?.imageLinks?.thumbnail}',
            fit: BoxFit.fill,
            height: 210.0,
            width: 150.0,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return child;
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Container(
                  height: 200.0,
                  width: 140.0,
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
                height: 200.0,
                width: 140.0,
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
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
              );
            },
          ),
        ),
      );

  Widget buildItemBestBook(ItemsData model, context, index) => InkWell(
        borderRadius: BorderRadius.circular(
          12.0,
        ),
        onTap: () {
          if (AppCubit.get(context).hasInternet) {
            Navigator.of(context).push(createRoute(
                screen: DetailsBookScreen(
              itemData: model,
            )));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  await showImage(context, '${model.id}',
                      '${model.volumeInfo?.imageLinks?.thumbnail}');
                },
                child: Hero(
                  tag: '${model.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      '${model.volumeInfo?.imageLinks?.smallThumbnail}',
                      fit: BoxFit.fill,
                      height: 110.0,
                      width: 110.0,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Container(
                            height: 110.0,
                            width: 110.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                                child: CircularRingAdaptive(os: getOs())),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 110.0,
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
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.volumeInfo?.title}',
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (model.volumeInfo?.authors != null)
                      const SizedBox(
                        height: 6.0,
                      ),
                    if (model.volumeInfo?.authors != null)
                      Text(
                        '${model.volumeInfo?.authors?.join(',')}',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 16.0,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      children: [
                        Icon(
                          EvaIcons.star,
                          color: HexColor('ffdd4f'),
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          '${model.volumeInfo?.averageRating ?? 'Not Rating'}',
                          style: const TextStyle(
                            fontSize: 14.5,
                            // fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // const SizedBox(
                        //   width: 4.0,
                        // ),
                        // Text(
                        //   '(1234)',
                        //   style: TextStyle(
                        //     fontSize: 15.0,
                        //     color: Colors.grey.shade300,
                        //     fontWeight: FontWeight.bold,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future showImage(BuildContext context, String tag, image) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
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
                              return const SizedBox(
                                  height: 450.0,
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    'Failed to load',
                                    style: TextStyle(fontSize: 16.0),
                                  )));
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )));
  }

  dynamic showAlert(context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8.0,
          ),
        ),
        title: const Text(
          'No Internet Connection!',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'You are currently offline!',
          style: TextStyle(
            fontSize: 17.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                pressed = 0;
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Wait',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                pressed = 0;
              });
              SystemNavigator.pop();
            },
            child: const Text(
              'Exit',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
