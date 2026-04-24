import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/widgets/app_loading_button.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms/rooms_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms/rooms_state.dart';

class LeaveRoomDialog extends StatelessWidget {
  const LeaveRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        BlocBuilder<RoomsCubit, RoomsState>(
          builder: (context, state) {
            return AppLoadingButton(
              label: "Leave",
              backgroundColor: AppColors.errorColor,
              onPressed: context.read<RoomsCubit>().leaveRoom,
              isLoading: state.isLeaving,
            );
          },
        ),
        TextButton(
          child: Text('Cancel', style: AppTextStyles.bodyMedium),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      title: Text(
        'You are already in a room.',
        style: AppTextStyles.headlineSmall,
      ),
      content: Text(
        'Do you want to leave the old room and join the new room?',
        style: AppTextStyles.bodyMedium,
      ),
    );
  }
}
