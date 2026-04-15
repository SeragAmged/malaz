import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malaz/core/di/providers.dart';
import 'package:malaz/core/theme/app_colors.dart';
import 'package:malaz/core/theme/app_text_styles.dart';
import 'package:malaz/core/widgets/blurred_circle_decoration.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_cubit.dart';
import 'package:malaz/features/rooms/presentation/cubit/rooms_state.dart';
import 'package:malaz/features/rooms/presentation/widgets/create_room_modal.dart';
import 'package:malaz/features/rooms/presentation/widgets/header.dart';
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('M A L A Z', style: AppTextStyles.appBarTitle),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout_rounded),
        //     onPressed: () => context.read<AuthCubit>().signOut(),
        //   ),
        // ],
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Header(),
                Expanded(
                  child: BlocBuilder<RoomsCubit, RoomsState>(
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
                        return Center(
                          child: Text(
                            'No rooms available.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textTertiaryColor,
                            ),
                          ),
                        );
                      }
                      final itemCount =
                          state.rooms.length + (state.isLoadingMore ? 1 : 0);
                      return ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 100.h),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
              value: context.read<RoomsCubit>(),
              child: const CreateRoomModal(),
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.onPrimaryColor,
        elevation: 6,
        child: Icon(Icons.add, size: 28.r),
      ),
    );
  }
}
