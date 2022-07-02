// TODO: Put public facing types in this file.

import 'dart:async';

import 'package:meta/meta.dart';

import 'event_handler.dart';
import 'exceptions/state_machine_exception.dart';

/// Checks if you are awesome. Spoiler: you are.
abstract class StateMachine<S> {
  StateMachine(this._initialState) {
    start();
  }
  final S _initialState;
  late S _state;
  // final E? initialEvent;
  // final _handlersMap = <Type, Function>{};
  // final StateReference _reference;
  late final StreamController<S> _stateStreamController;

  @nonVirtual
  void shift(S newState) {
    if (_state == newState) return;
    onShift(_state, newState);
    _state = newState;
    _stateStreamController.add(newState);
  }

  // StateReference get reference => _reference;
  S get state => _state;
  Stream<S> get stateStream => _stateStreamController.stream;

  // void handle<ET extends E>(Function(ET event) handler) {
  //   _handlersMap[ET] = handler;
  // }

  // void addEvent(E event) {
  //   final handler = _handlersMap[event.runtimeType];
  //   if (handler != null) {
  //     handler(event);
  //   } else {
  //     throw EventHandlerNotRegistered(event);
  //   }
  // }
  void onShift(S oldState, S newState) {
    print('$runtimeType($hashCode) shifted from $oldState to $newState');
  }

  void start() {
    _stateStreamController = StreamController<S>(
      onListen: () => print('$runtimeType($hashCode) LISTENER ADDED'),
      onCancel: () => print('$runtimeType($hashCode) NO LISTENERS'),
    );
    _state = _initialState;
    print('$runtimeType($hashCode) is STARTED with state: $_state');
  }

  @mustCallSuper
  void stop() {
    // _reference.cancel();
    _stateStreamController.close();
    print('$runtimeType($hashCode) is stopped');
    // _messageStreamController.close();
  }
}
