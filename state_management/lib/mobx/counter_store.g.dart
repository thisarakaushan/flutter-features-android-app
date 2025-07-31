// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CounterStore on _CounterStore, Store {
  Computed<String>? _$counterStatusComputed;

  @override
  String get counterStatus => (_$counterStatusComputed ??= Computed<String>(
    () => super.counterStatus,
    name: '_CounterStore.counterStatus',
  )).value;
  Computed<bool>? _$isEvenComputed;

  @override
  bool get isEven => (_$isEvenComputed ??= Computed<bool>(
    () => super.isEven,
    name: '_CounterStore.isEven',
  )).value;

  late final _$counterAtom = Atom(
    name: '_CounterStore.counter',
    context: context,
  );

  @override
  int get counter {
    _$counterAtom.reportRead();
    return super.counter;
  }

  @override
  set counter(int value) {
    _$counterAtom.reportWrite(value, super.counter, () {
      super.counter = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_CounterStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$incrementAsyncAsyncAction = AsyncAction(
    '_CounterStore.incrementAsync',
    context: context,
  );

  @override
  Future<void> incrementAsync() {
    return _$incrementAsyncAsyncAction.run(() => super.incrementAsync());
  }

  late final _$_CounterStoreActionController = ActionController(
    name: '_CounterStore',
    context: context,
  );

  @override
  void increment() {
    final _$actionInfo = _$_CounterStoreActionController.startAction(
      name: '_CounterStore.increment',
    );
    try {
      return super.increment();
    } finally {
      _$_CounterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrement() {
    final _$actionInfo = _$_CounterStoreActionController.startAction(
      name: '_CounterStore.decrement',
    );
    try {
      return super.decrement();
    } finally {
      _$_CounterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$_CounterStoreActionController.startAction(
      name: '_CounterStore.reset',
    );
    try {
      return super.reset();
    } finally {
      _$_CounterStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
counter: ${counter},
isLoading: ${isLoading},
counterStatus: ${counterStatus},
isEven: ${isEven}
    ''';
  }
}
