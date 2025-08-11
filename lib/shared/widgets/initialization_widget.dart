import 'package:flutter/material.dart';

import '../pages/page_loader.dart';

enum ILZState {
  waiting(0),
  failed(1001),
  notFound(404),
  noContent(204),
  timeout(408),
  connectionError(1009),
  internalServerError(500),
  success(200);

  final int code;

  const ILZState(this.code);
}

class InitializationWidget extends StatelessWidget {
  final ValueNotifier<ILZState> state;
  final Function(BuildContext context, Widget child) builder;
  final Function(BuildContext context, Widget child)? loadingBuilder;

  const InitializationWidget({super.key,
    required this.state,
    required this.builder,
    this.loadingBuilder
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ILZState>(
        valueListenable: state,
        builder: (context, value, child){
          switch(value){
            case ILZState.waiting:
              return PageLoader();
            case ILZState.failed:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ILZState.notFound:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ILZState.noContent:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ILZState.timeout:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ILZState.connectionError:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ILZState.internalServerError:
              // TODO: Handle this case.
              throw UnimplementedError();
            case ILZState.success:
              // TODO: Handle this case.
              throw UnimplementedError();
          }
          return Container();
        }
    );
  }
}