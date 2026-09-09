import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starliga/core/models/team.dart';
import 'package:starliga/features/teams/presentation/bloc/TeamDetailsBloc/team_detail_bloc.dart';
import 'package:starliga/features/teams/presentation/pages/team_details_page.dart';
import 'package:starliga/injection_container.dart';
import 'package:starliga/utils/colors.dart';

class TeamCardComponent extends StatelessWidget {
  const TeamCardComponent({super.key, required this.team});
  final Team team;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  sl<TeamDetailsBloc>()
                    ..add(FetchTeamDetailsEvent(team.id.toString())),
              child: TeamDetailsPage(team: team),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        width: 200,
        height: 175,
        child: Column(
          children: [
            SizedBox(height: 10),
            // حاوية الشعار/الصورة
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  team.imageUrl ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.shield,
                    color: AppColors.divider,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // اسم الفريق
            Text(
              team.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

             // كبسولة اسم المدينة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white12, width: 1),
              ),
              child: Text(
                team.cityName!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
