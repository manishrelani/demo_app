import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/size.dart';
import '../../../../core/util/extension/context_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../widget/bottom_sheet/list_bottom_sheet.dart';
import '../../../../widget/button/btn_primary.dart';
import '../../../../widget/button/btn_secondary.dart';
import '../../../../widget/dialog/calender_dialog.dart';
import '../../../../widget/dialog/generic_dialog.dart';
import '../../../../widget/form_field/custom_text_form_field.dart';
import '../../../../widget/platform_spacer.dart';
import '../../util/enum.dart';
import '../cubit/manage_employee_cubit.dart';

class ManageEmployeeScreen extends StatelessWidget {
  const ManageEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ManageEmployeeCubit>();
    return BlocListener<ManageEmployeeCubit, ManageEmployeeState>(
      listenWhen: (previous, current) => current is EmployeeUpdateState,
      listener: (context, state) {
        if (state is EmployeeUpdateState) {
          Navigator.pop(context, state.employee);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${cubit.isUpdate ? "Edit" : "Add"} Employee Details"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppSizes.maxWidth),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CustomTextForm(
                          hintText: "Employee Name",
                          controller: cubit.tecEmployeeName,
                          isRequired: true,
                          maxLines: 1,
                          prefixIcon: const Icon(
                            Icons.person_2_outlined,
                            color: ColorName.blueColor,
                          ),
                          formatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[A-Z a-z]'),
                            ),
                            LengthLimitingTextInputFormatter(50)
                          ],
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        CustomTextForm(
                          hintText: "Select Role",
                          readOnly: true,
                          controller: cubit.tecRole,
                          prefixIcon: const Icon(
                            Icons.work_outline,
                            size: 20,
                          ),
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 24,
                          ),
                          onTap: () {
                            context.showGenerericBottomSheet(
                              builder: (context) {
                                return ListBottomSheet(
                                  items: EmployeeRole.values,
                                  title: (e) => e.title,
                                  onTap: cubit.onSelectRole,
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: CustomTextForm(
                                hintText: "No Date",
                                controller: cubit.tecStartDate,
                                readOnly: true,
                                prefixIcon: Assets.svgs.calendarIcon.svg(
                                  height: 20,
                                  width: 20,
                                ),
                                onTap: () {
                                  onStartDate(context, cubit);
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: ColorName.blueColor,
                                size: 18,
                              ),
                            ),
                            Flexible(
                              child: CustomTextForm(
                                hintText: "No Date",
                                controller: cubit.tecEndDate,
                                readOnly: true,
                                prefixIcon: Assets.svgs.calendarIcon.svg(
                                  height: 20,
                                  width: 20,
                                ),
                                onTap: () {
                                  onEndDate(context, cubit);
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Divider(
              height: 1,
              color: ColorName.borderColor,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BtnSecondary(
                    title: "Cancel",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  BtnPrimary(
                    title: "Save",
                    onPressed: cubit.onSave,
                  ),
                ],
              ),
            ),
            const PlatformSpacer(),
          ],
        ),
      ),
    );
  }

  void onStartDate(BuildContext context, ManageEmployeeCubit cubit) {
    showDialog(
      context: context,
      builder: (context) {
        return GenericDialog(
          child: CustomCalendar(
            firstDay: DateTime(cubit.today.year - 3, cubit.today.month, cubit.today.day),
            lastDay: DateTime(cubit.today.year, cubit.today.month + 5, cubit.today.day),
            selectedDate: cubit.startDateTime,
            onSelect: (date) {
              if (date != null) cubit.onSelectStartDate(date);
            },
          ),
        );
      },
    );
  }

  void onEndDate(BuildContext context, ManageEmployeeCubit cubit) async {
    showDialog(
      context: context,
      builder: (context) {
        return GenericDialog(
          child: CustomCalendar(
            firstDay: DateTime(cubit.today.year - 3, cubit.today.month, cubit.today.day),
            lastDay: DateTime(cubit.today.year, cubit.today.month + 5, cubit.today.day),
            selectedDate: cubit.endDateTime,
            showNoDate: true,
            onSelect: cubit.onSelectEndDate,
          ),
        );
      },
    );
  }
}
