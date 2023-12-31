import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';

abstract class BaseViewModel {
  final BuildContext context;

  @protected
  StreamController<void> networkErrorController =
      StreamController<void>.broadcast();

  Stream<void> get networkError => networkErrorController.stream;

  BaseViewModel(this.context) {
    networkError.listen((event) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "هنالك مشكلة فى الإتصال بالأنترنت، الرجاء المحاولة مرة أخرى")));
    });
  }

  @mustCallSuper
  void onClose() {
    networkErrorController.close();
  }
}

mixin ViewModelLogic<T> on BaseViewModel {
  final T logic = Injector.appInstance.get<T>();
}

mixin ViewModelArgs<A> on BaseViewModel {
  late A? args;
  bool __argsPushed = false;

  void pushArgs(A? args) {
    if (!__argsPushed) {
      __argsPushed = true;
      this.args = args;
      onArgsPushed();
    }
  }

  void onArgsPushed() {}
}

abstract class BaseViewModelWithLogic<T> extends BaseViewModel
    with ViewModelLogic<T> {
  BaseViewModelWithLogic(BuildContext context) : super(context);
}

abstract class BaseViewModelWithArgs<A> extends BaseViewModel
    with ViewModelArgs<A> {
  BaseViewModelWithArgs(BuildContext context) : super(context);
}

abstract class BaseViewModelWithLogicAndArgs<T, A> extends BaseViewModel
    with ViewModelLogic<T>, ViewModelArgs<A> {
  BaseViewModelWithLogicAndArgs(BuildContext context) : super(context);
}
