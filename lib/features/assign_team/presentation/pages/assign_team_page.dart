import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:starliga/components/add_player_dialogue.dart';
import 'package:starliga/components/ball_loading_indicator.dart';
import 'package:starliga/components/connection_error.dart';
import 'package:starliga/components/custom_select_menu.dart';
import 'package:starliga/components/custom_text_field.dart';
import 'package:starliga/components/image_picker.dart';
import 'package:starliga/components/player_wide_card.dart';
import 'package:starliga/core/models/city.dart';
import 'package:starliga/core/models/player.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/features/assign_team/presentation/bloc/assign_team_bloc.dart';
import 'package:starliga/utils/colors.dart';
import 'package:top_snackbar/top_snackbar.dart';

class AssignTeamPage extends StatefulWidget {
  const AssignTeamPage({super.key});

  @override
  State<AssignTeamPage> createState() => _AssignTeamPageState();
}

class _AssignTeamPageState extends State<AssignTeamPage> {
  File? _image;
  City? _selectedCity;
  List<City> _cities = [];
  final List<Player> _players = [];
  final _teamNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _teamNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _openAddPlayerDialog() async {
    final Player? newPlayer = await showDialog<Player>(
      context: context,
      builder: (context) => const AddPlayerDialog(),
    );

    if (newPlayer != null) {
      setState(() {
        _players.add(newPlayer);
      });
    }
  }

  void _resetForm() {
    setState(() {
      _teamNameController.clear();
      _phoneController.clear();
      _selectedCity = null;
      _image = null;
      _players.clear();
    });
  }

  String? _validateTeamForm() {
    if (_teamNameController.text.trim().isEmpty) {
      return 'يرجى إدخال اسم الفريق';
    }
    if (_phoneController.text.trim().isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    if (_selectedCity == null) {
      return 'يرجى اختيار المدينة';
    }
    if (_players.isEmpty) {
      return 'يجب إضافة لاعبين للفريق';
    }
    if (_players.length < 8) {
      return 'يجب أن يحتوي الفريق على 8 لاعبين على الأقل';
    }

    final captainCount = _players
        .where((p) => p.role == 'C' || p.role == 'كابتن')
        .length;
    final gkCount = _players
        .where((p) => p.role == 'GK' || p.role == 'حارس')
        .length;

    if (captainCount != 1) {
      return 'يجب أن يحتوي الفريق على كابتن واحد فقط';
    }
    if (gkCount != 1) {
      return 'يجب أن يحتوي الفريق على حارس مرمى واحد فقط';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssignTeamBloc, AssignTeamState>(
      listener: (context, state) {
        if (state is CitiesLoadedState) {
          _cities = state.cities;
        } else if (state is AssignTeamSuccessState) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            barrierDismissible: false,
            title: 'تم إنشاء الفريق',
            text: 'تم تسجيل بيانات الفريق واللاعبين بنجاح.',
            confirmBtnText: 'تم',
            backgroundColor: AppColors.surface,
            titleColor: AppColors.secondary,
            textColor: AppColors.textSecondary,
            confirmBtnColor: AppColors.tertiary,
            confirmBtnTextStyle: const TextStyle(
              color: AppColors.neutral,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            onConfirmBtnTap: () {
              Navigator.pop(context);
              _resetForm();
            },
          );
        } else if (state is AssignTeamFailureState) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            barrierDismissible: false,
            title: 'حدث خطأ',
            confirmBtnText: 'تم',
            backgroundColor: AppColors.surface,
            titleColor: AppColors.secondary,
            textColor: AppColors.textSecondary,
            confirmBtnColor: AppColors.tertiary,
            confirmBtnTextStyle: const TextStyle(
              color: AppColors.neutral,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            onConfirmBtnTap: () {
              Navigator.pop(context);
            },
          );
        }
      },
      builder: (context, state) {
        if (state is CitiesLoadingState) {
          return const BallLoadingIndicator();
        }

        if (state is CitiesErrorState) {
          return ConnectionErrorWidget(
            onRetry: () {
              context.read<AssignTeamBloc>().add(FetchCitiesEvent());
            },
            message: 'إعادة المحاولة',
          );
        }

        if (state is CitiesLoadedState || _cities.isNotEmpty) {
          final isSubmitting = state is AssignTeamSubmittingState;

          return SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'إنشاء فريق جديد',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // فورم معلومات الفريق
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          TeamImagePicker(
                            onImageSelected: (image) => _image = image,
                          ),
                          const SizedBox(height: 10),
                          CustomAppTextField(
                            controller: _teamNameController,
                            label: 'اسم الفريق',
                            hint: 'أدخل اسم الفريق',
                          ),
                          const SizedBox(height: 10),
                          CustomAppTextField(
                            controller: _phoneController,
                            label: 'رقم الهاتف',
                            hint: 'أدخل رقم الهاتف',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),
                          CustomAppDropdownField<City>(
                            label: 'المدينة',
                            hint: 'اختر المدينة',
                            value: _selectedCity,
                            items: _cities,
                            itemLabel: (city) => city.name,
                            onChanged: (city) {
                              setState(() {
                                _selectedCity = city;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // رأس قسم اللاعبين + كبسة الإضافة
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentYellow,
                            foregroundColor: AppColors.neutral,
                          ),
                          onPressed: isSubmitting ? null : _openAddPlayerDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('إضافة لاعب'),
                        ),
                        const Text(
                          'قائمة اللاعبين',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // عرض قائمة اللاعبين أو رسالة فارغة
                    _players.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Text(
                              'لم تتم إضافة أي لاعب بعد',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _players.length,
                            itemBuilder: (context, index) {
                              return PlayerWideCard(
                                player: _players[index],
                                onDelete: isSubmitting
                                    ? null
                                    : () {
                                        setState(
                                          () => _players.removeAt(index),
                                        );
                                      },
                              );
                            },
                          ),
                    const SizedBox(height: 10),

                    // كبسة تسجيل الفريق
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: isSubmitting
                            ? null
                            : () {
                                final errorMessage = _validateTeamForm();
                                if (errorMessage != null) {
                                  CustomTopSnackbar.showError(
                                    context,
                                    errorMessage,
                                    duration: const Duration(seconds: 2),
                                  );
                                  return;
                                }

                                context.read<AssignTeamBloc>().add(
                                  CreateTeamEvent(
                                    team: Team(
                                      name: _teamNameController.text.trim(),
                                      phoneNumber: _phoneController.text.trim(),
                                      cityId: _selectedCity!.id,
                                      cityName: _selectedCity!.name,
                                    ),
                                    players: _players,
                                    image: _image,
                                  ),
                                );
                              },
                        child: isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: AppColors.neutral,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'تسجيل الفريق',
                                style: TextStyle(
                                  color: AppColors.neutral,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
