abstract class AppStates {}

class InitialAppState extends AppStates {}

class LoadingGetBooksAppState extends AppStates {}

class SuccessGetBooksAppState extends AppStates {}

class ErrorGetBooksAppState extends AppStates {

  dynamic error;
  ErrorGetBooksAppState(this.error);
}

class LoadingSearchBookAppState extends AppStates {}

class SuccessSearchBookAppState extends AppStates {}

class ErrorSearchBookAppState extends AppStates {

  dynamic error;
  ErrorSearchBookAppState(this.error);
}


class SuccessClearAppState extends AppStates {}

class CheckConnectionAppState extends AppStates {}

class ChangeStatusAppState extends AppStates {}