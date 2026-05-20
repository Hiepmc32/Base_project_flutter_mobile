import 'package:flutter/material.dart';

import 'base_list_state.dart';

/// Reusable body for list-based screens with empty and refresh handling.
class BaseListBody<T> extends StatelessWidget {
  const BaseListBody({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.itemBuilder,
    required this.emptyMessage,
    this.padding = const EdgeInsets.all(16),
    this.emptyIcon = const Icon(
      Icons.inbox_outlined,
      size: 64,
      color: Colors.grey,
    ),
  });

  final BaseListState<T> state;
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyMessage;
  final EdgeInsetsGeometry padding;
  final Widget emptyIcon;

  @override
  Widget build(BuildContext context) {
    if (!state.hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            emptyIcon,
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? emptyMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: padding,
        itemCount: state.items.length,
        itemBuilder: (BuildContext context, int index) {
          final T item = state.items[index];
          return itemBuilder(context, item);
        },
      ),
    );
  }
}
