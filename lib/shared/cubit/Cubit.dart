import 'package:bloc/bloc.dart';
import 'package:ebook/models/bookModel/BookModel.dart';
import 'package:ebook/shared/components/Components.dart';
import 'package:ebook/shared/cubit/States.dart';
import 'package:ebook/shared/network/DioHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  BookModel? bookDataModel;

  void getBooks(context) {
    emit(LoadingGetBooksAppState());
    DioHelper.getData(
      url: '/volumes',
      query: {
        'q': 'Any',
        'key': 'AIzaSyANRigeCi9Uod5wYnQjx9_5VNuybNXfYPQ',
      },
    ).then((value) {
      bookDataModel = BookModel.fromJson(value?.data);
      emit(SuccessGetBooksAppState());
    }).catchError((error) {
      if (kDebugMode) {
        print('$error in getting data books.');
      }
      showFlutterToast(
          message: 'Error , data not fetched',
          state: ToastStates.error,
          context: context);
      emit(ErrorGetBooksAppState(error));
    });
  }

  void searchBook({
    required String value,
    required BuildContext context,
  }) {
    emit(LoadingSearchBookAppState());
    DioHelper.getData(
      url: '/volumes',
      query: {
        'q': value,
        'key': 'AIzaSyANRigeCi9Uod5wYnQjx9_5VNuybNXfYPQ',
      },
    ).then((value) {
      bookDataModel = BookModel.fromJson(value?.data);
      emit(SuccessSearchBookAppState());
    }).catchError((error) {
      if (kDebugMode) {
        print('$error in search book.');
      }
      // showFlutterToast(
      //     message: 'Error , something happen try again',
      //     state: ToastStates.error,
      //     context: context);
      emit(ErrorSearchBookAppState(error));
    });
  }

  void clearSearchBooks() {
    bookDataModel = null;
    emit(SuccessClearAppState());
  }

  bool hasInternet = false;
  bool isSplashScreen = true;

  void checkConnection(context) {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      this.hasInternet = hasInternet;
      (isSplashScreen == false) ? showSimpleNotification(
              (hasInternet)
                  ? const Text(
                      'You are connected with internet',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text(
                      'You are not connected with internet',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              background: (hasInternet) ? HexColor('158b96') : Colors.red,
            ) : null;

      if(hasInternet) {
        getBooks(context);
      }
      emit(CheckConnectionAppState());
    });
    // emit(CheckConnectionAppState());
  }

  void changeStatusScreen() {
    isSplashScreen = false;
    emit(ChangeStatusAppState());
  }
}
