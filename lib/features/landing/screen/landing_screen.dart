import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime/core/theme/text_style.dart';
import 'package:realtime/widget/button/btn_primary.dart';

import '../cubit/landing_cubit.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LandingCubit, LandingState>(
      listener: (context, state) {
        if (state is LandingNavigate) {
          Navigator.pushReplacementNamed(context, state.screen);
        }
      },
      child: Scaffold(
        body: BlocBuilder<LandingCubit, LandingState>(
          buildWhen: (previous, current) => current is LandingLoading || current is LandingError,
          builder: (context, state) {
            if (state is LandingError) {
              return const GenericView();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class GenericView extends StatelessWidget {
  const GenericView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Unable to load, Please refresh!",
            style: CustomTextStyles.k16,
          ),
          const SizedBox(
            height: 16.0,
          ),
          BtnPrimary(
            title: "Refresh",
            onPressed: () {
              context.read<LandingCubit>().onRefresh();
            },
          )
        ],
      ),
    );
  }
}
