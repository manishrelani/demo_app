import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:realtime/core/util/extension/object_extension.dart';

import '../../../../core/routes/screen_name.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/util/extension/bool_extension.dart';
import '../../../../domain/model/employee_model.dart';
import '../../../../gen/assets.gen.dart';
import '../bloc/employee_list_bloc.dart';
import '../widget/employee_widget.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EmployeeListBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee List"),
      ),
      body: BlocBuilder<EmployeeListBloc, EmployeeListState>(
        buildWhen: (previous, current) {
          return current is EmployeeListLoadedState || current is EmployeeListLoading;
        },
        builder: (context, state) {
          if (state is EmployeeListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EmployeeListLoadedState) {
            if (bloc.currentEmployees.isEmpty && bloc.previousEmployees.isEmpty) {
              return Center(
                child: Assets.svgs.noEmployeeGraphic.svg(),
              );
            }

            return OrientationBuilder(
              builder: (context, orientation) {
                final isPortrait = orientation == Orientation.portrait;
                if (isPortrait) {
                  return _portraitView(bloc);
                } else {
                  return _horizontalView(bloc);
                }
              },
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorName.blueColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          final value = await Navigator.pushNamed(
            context,
            ScreenName.manageEmployee,
          );
          if (value is EmployeeModel) {
            bloc.add(AddUpdateEmployeeEvent(value));
          }
        },
      ),
    );
  }

  Widget _portraitView(EmployeeListBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bloc.currentEmployees.isNotEmpty) const _CurrentEmployeeList(),
        if (bloc.previousEmployees.isNotEmpty) const _PreviousEmployeeList(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 32.0),
          child: Text(
            "Swipe left to delete",
            style: CustomTextStyles.k15.copyWith(
              color: ColorName.lightTextColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _horizontalView(EmployeeListBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              if (bloc.currentEmployees.isNotEmpty) const _CurrentEmployeeList(isPortrait: false),
              if (bloc.currentEmployees.isNotEmpty && bloc.previousEmployees.isNotEmpty)
                const SizedBox(
                  width: 16.0,
                ),
              if (bloc.previousEmployees.isNotEmpty) const _PreviousEmployeeList(isPortrait: false),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 24.0),
          child: Text(
            "Swipe left to delete",
            style: CustomTextStyles.k15.copyWith(
              color: ColorName.lightTextColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentEmployeeList extends StatelessWidget {
  final bool isPortrait;
  const _CurrentEmployeeList({this.isPortrait = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeListBloc, EmployeeListState>(
      buildWhen: (previous, current) => current is EmployeeListLoadedState,
      builder: (context, state) {
        final bloc = context.read<EmployeeListBloc>();
        final plist = bloc.previousEmployees;
        final clist = bloc.currentEmployees;
        return Flexible(
          flex: isPortrait
              ? plist.length < 3 || clist.length < 3
                  ? min(3, clist.length)
                  : 1
              : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Curerrnt Employee",
                  style: CustomTextStyles.k16Medium.copyWith(
                    color: ColorName.blueColor,
                  ),
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                  child: PagedListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 1,
                        color: Colors.grey.shade100,
                      );
                    },
                    shrinkWrap: true,
                    pagingController: bloc.cEmpPagingController,
                    builderDelegate: PagedChildBuilderDelegate<EmployeeModel>(
                      itemBuilder: (context, item, index) {
                        item.toJson().showLog;
                        return EmployeeWidget(
                          employee: item,
                          wrapClip: isPortrait.isFalse,
                          onDelete: () => bloc.add(
                            DeleteEmployeeEvent(index: index, isPrevious: false),
                          ),
                          onTap: () async {
                            final value =
                                await Navigator.pushNamed(context, ScreenName.manageEmployee, arguments: item);

                            if (value is EmployeeModel) {
                              bloc.add(AddUpdateEmployeeEvent(value));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PreviousEmployeeList extends StatelessWidget {
  final bool isPortrait;
  const _PreviousEmployeeList({this.isPortrait = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeListBloc, EmployeeListState>(
      buildWhen: (previous, current) => current is EmployeeListLoadedState,
      builder: (context, state) {
        final bloc = context.read<EmployeeListBloc>();
        final plist = bloc.previousEmployees;
        final clist = bloc.currentEmployees;
        return Flexible(
          flex: isPortrait
              ? plist.length < 3 || clist.length < 3
                  ? min(3, plist.length)
                  : 1
              : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Previous Employee",
                  style: CustomTextStyles.k16Medium.copyWith(
                    color: ColorName.blueColor,
                  ),
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                  child: PagedListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    pagingController: bloc.pEmpPagingController,
                    builderDelegate: PagedChildBuilderDelegate<EmployeeModel>(
                      itemBuilder: (context, item, index) {
                        item.toJson().showLog;
                        return EmployeeWidget(
                          employee: item,
                          isPrevious: true,
                          wrapClip: isPortrait.isFalse,
                          onDelete: () => bloc.add(
                            DeleteEmployeeEvent(index: index, isPrevious: true),
                          ),
                          onTap: () async {
                            final value =
                                await Navigator.pushNamed(context, ScreenName.manageEmployee, arguments: item);

                            if (value is EmployeeModel) {
                              bloc.add(AddUpdateEmployeeEvent(value));
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
