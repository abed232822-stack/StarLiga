import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:starliga/core/constants/constatnts.dart';
import 'package:starliga/features/home/data/models/news.dart';
import 'package:starliga/utils/colors.dart';

class CustomCarousel extends StatelessWidget {
  final List<News> news;
  const CustomCarousel({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    if (news.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 7),
        enlargeCenterPage: true,
        viewportFraction: 0.88,
        reverse: true,
      ),
      items: news.map((newsItem) {
        return Builder(
          builder: (BuildContext context) {
            final imageUrl = newsItem.imageUrl != null && newsItem.imageUrl!.isNotEmpty
                ? (newsItem.imageUrl!.startsWith('http')
                    ? newsItem.imageUrl!
                    : '$ImagesBaseUrl${newsItem.imageUrl}')
                : '';

            return ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // الصورة الخلفية
                  imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.primary,
                              alignment: Alignment.center,
                              child: Text(
                                'إعلان',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 24,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: AppColors.primary,
                          alignment: Alignment.center,
                          child: Text(
                            'إعلان',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 24,
                            ),
                          ),
                        ),

                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            newsItem.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            newsItem.body,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
