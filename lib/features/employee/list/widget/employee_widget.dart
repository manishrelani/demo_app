import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/util/extension/date_extension.dart';
import '../../../../domain/model/employee_model.dart';

class EmployeeWidget extends StatelessWidget {
  final EmployeeModel employee;
  final bool isPrevious;
  final VoidCallback onDelete;
  final bool wrapClip;
  final VoidCallback onTap;
  const EmployeeWidget({
    required this.employee,
    required this.onDelete,
    required this.onTap,
    this.isPrevious = false,
    this.wrapClip = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return wrapClip
        ? ClipRect(
            child: child,
          )
        : child;
  }

  Widget get child {
    return Slidable(
      key: ValueKey(employee.id),
      endActionPane: ActionPane(
        dismissible: DismissiblePane(onDismissed: onDelete),
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            // foregroundColor: Colors.white,
            icon: CupertinoIcons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        dense: true,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        isThreeLine: true,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Text(
            employee.name,
            style: CustomTextStyles.k16Medium,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              employee.role,
              style: CustomTextStyles.k14.copyWith(
                color: ColorName.lightTextColor,
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),
            if (isPrevious)
              Text(
                "${employee.startDate.todMMMyyyy()} - ${employee.endDate?.todMMMyyyy()}",
                style: CustomTextStyles.k12.copyWith(
                  color: ColorName.lightTextColor,
                ),
              )
            else
              Text(
                "From ${employee.startDate.todMMMyyyy()}",
                style: CustomTextStyles.k12.copyWith(
                  color: ColorName.lightTextColor,
                ),
              )
          ],
        ),
      ),
    );
  }
}
