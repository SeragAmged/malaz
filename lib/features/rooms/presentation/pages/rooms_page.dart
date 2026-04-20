import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/router/app_router.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/util/errors/domain_errors.dart';
import 'package:malaz/core/widgets/blurred_circle_decoration.dart';
import 'package:malaz/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_state.dart';
import 'package:malaz/features/rooms/presentation/widgets/create_room_modal.dart';
import 'package:malaz/features/rooms/presentation/widgets/header.dart';
import 'package:malaz/features/rooms/presentation/widgets/leave_room_dialog.dart';
import 'package:malaz/features/rooms/presentation/widgets/room_card.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoomsCubit>(
      create: (context) => getIt<RoomsCubit>()..fetchRooms(),
      child: const _RoomsView(),
    );
  }
}

class _RoomsView extends StatefulWidget {
  const _RoomsView();

  @override
  State<_RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<_RoomsView> {
  late ScrollController _scrollController;
  BuildContext? _leaveDialogContext;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RoomsCubit>().loadMoreRooms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text('M A L A Z', style: AppTextStyles.appBarTitle),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Teal radial glow – top right, matches the screenshot
          BlurredCircleDecoration(
            width: 234.w,
            height: 641.h,
            color: AppColors.primaryColor,
            colorAlpha: 0.15,
            right: -120.w,
            top: -250.h,
          ),
          SafeArea(
            child: BlocConsumer<RoomsCubit, RoomsState>(
              listener: (context, state) {
                if (state.isLeaveSuccess) {
                  if (_leaveDialogContext != null) {
                    Navigator.of(_leaveDialogContext!).pop();
                    _leaveDialogContext = null;
                  }
                  context.read<RoomsCubit>().resetStatuses();
                }
                if (state.isJoinSuccess) {
                  context.read<RoomsCubit>().resetStatuses();
                  context.go('${AppRouter.rooms}/${state.joinedRoomId}');
                }
                if (state.isJoinFailure) {
                  if (state.joinError is AlreadyInRoom) {
                    showDialog(
                      context: context,
                      builder: (newContext) {
                        _leaveDialogContext = newContext;
                        return BlocProvider.value(
                          value: context.read<RoomsCubit>(),
                          child: LeaveRoomDialog(),
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.joinError?.message ?? 'Failed to join room.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onErrorColor,
                          ),
                        ),
                        backgroundColor: AppColors.errorColor,
                      ),
                    );
                  }
                  context.read<RoomsCubit>().resetStatuses();
                }
              },
              builder: (context, state) {
                if (state.isLoading || state.isInitial) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }
                if (state.isFailure) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Something went wrong.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.errorColor,
                      ),
                    ),
                  );
                }
                if (state.rooms.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Header(),
                      Expanded(
                        child: Center(
                          child: Text(
                            'No rooms available.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textTertiaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                final itemCount =
                    state.rooms.length + (state.isLoadingMore ? 1 : 0);
                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<RoomsCubit>().fetchRooms(forceRefresh: true),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      const SliverToBoxAdapter(child: Header()),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
                        sliver: SliverList.separated(
                          itemCount: itemCount,
                          separatorBuilder: (_, _) => SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            if (index == state.rooms.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              );
                            }
                            return RoomCard(room: state.rooms[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: context.read<RoomsCubit>(),
            child: const CreateRoomModal(),
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.onPrimaryColor,
        elevation: 6,
        child: Icon(Icons.add, size: 28.r),
      ),
    );
  }
}
