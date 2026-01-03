import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart'
    show ConnectivityResult;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sof/core/util/bloc/internet_connection_bloc/repository/network_info.dart';

part 'internet_connection_event.dart';

part 'internet_connection_state.dart';

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  final AbstractNetworkInfo _connectionCheck;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  Timer? _periodicCheckTimer;

  InternetConnectionBloc({required AbstractNetworkInfo connectionCheck})
    : _connectionCheck = connectionCheck,
      super(const InternetConnectionState(isConnected: false)) {
    on<CheckConnection>(_onCheckConnection);
    on<SetConnectionToFalse>(_onSetConnectionToFalse);
    // Perform initial connectivity check
    add(const CheckConnection());
    // Start listening to connectivity changes
    _checkConnectionStream();
  }

  static InternetConnectionState currentState = const InternetConnectionState(
    isConnected: false,
  );

  static InternetConnectionBloc bloc(BuildContext context) =>
      context.read<InternetConnectionBloc>();

  /// this event only called in the situation of _checkConnectionStream is false
  void _onSetConnectionToFalse(event, emit) {
    // Immediately emit disconnected state
    currentState = const InternetConnectionState(isConnected: false);
    emit(currentState);
    // Start periodic check when disconnected to detect reconnection
    _startPeriodicCheck();
  }

  FutureOr<void> _onCheckConnection(event, emit) async {
    try {
      final bool isConnected = await _connectionCheck.isConnected;

      // Only emit if state actually changed to avoid unnecessary rebuilds
      if (currentState.isConnected != isConnected) {
        currentState = InternetConnectionState(isConnected: isConnected);
        emit(currentState);
      }

      // Manage periodic check based on connection state
      if (isConnected) {
        // Stop periodic check when connected
        _stopPeriodicCheck();
      } else {
        // Start periodic check when disconnected
        _startPeriodicCheck();
      }
    } catch (e) {
      // On error, assume disconnected
      if (currentState.isConnected) {
        currentState = const InternetConnectionState(isConnected: false);
        emit(currentState);
      }
      // Start periodic check when error occurs
      _startPeriodicCheck();
    }
  }

  /// Start periodic connectivity checks when disconnected
  /// This ensures we detect reconnection even if the stream doesn't fire
  void _startPeriodicCheck() {
    // Only start if not already running and we're disconnected
    if (_periodicCheckTimer != null || currentState.isConnected) {
      return;
    }

    _periodicCheckTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      // Only check if we're still disconnected
      if (!currentState.isConnected) {
        add(const CheckConnection());
      } else {
        // If we're connected, stop the timer
        timer.cancel();
        _periodicCheckTimer = null;
      }
    });
  }

  /// Stop periodic connectivity checks
  void _stopPeriodicCheck() {
    _periodicCheckTimer?.cancel();
    _periodicCheckTimer = null;
  }

  /// listen to the stream and each time the user close data or wifi
  /// the it will force to set connection to false
  void _checkConnectionStream() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectionCheck.checkConnectionStream().listen(
      (List<ConnectivityResult> result) {
        // Stream fires immediately when connectivity changes
        if (result.contains(ConnectivityResult.none)) {
          // Immediately set to disconnected
          add(const SetConnectionToFalse());
        } else {
          // When connectivity is restored, immediately check the actual connection
          add(const CheckConnection());
        }
      },
      onError: (error) {
        // On error, assume disconnected
        add(const SetConnectionToFalse());
      },
      cancelOnError: false, // Keep listening even on error
    );
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _stopPeriodicCheck();
    return super.close();
  }
}
