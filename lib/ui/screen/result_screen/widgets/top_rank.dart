import 'package:flutter/material.dart';

import '../../../../theme/theme.dart';

class TopRank extends StatelessWidget {
  const TopRank({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TrackerTheme.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd Place
              Column(
                children: [
                  Text(
                    'B',
                    style: AppTextStyles.heading.copyWith(
                      color: TrackerTheme.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 140,
                    decoration: BoxDecoration(color: TrackerTheme.white),
                    child: Image.asset(
                      "assets/images/2nd.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 160,
                    decoration: BoxDecoration(
                      color: TrackerTheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1:31:10',
                          style: AppTextStyles.heading.copyWith(
                            color: TrackerTheme.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 1st Place
              Column(
                children: [
                  Text(
                    'A',
                    style: AppTextStyles.heading.copyWith(
                      color: TrackerTheme.black,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 140,
                    decoration: BoxDecoration(color: TrackerTheme.white),
                    child: Image.asset(
                      "assets/images/1st.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 200,
                    decoration: BoxDecoration(
                      color: TrackerTheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1:30:25',
                          style: AppTextStyles.heading.copyWith(
                            color: TrackerTheme.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 3rd Place
              Column(
                children: [
                  Text(
                    'C',
                    style: AppTextStyles.heading.copyWith(
                      color: TrackerTheme.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 140,
                    decoration: BoxDecoration(color: TrackerTheme.white),
                    child: Image.asset(
                      "assets/images/3rd.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color: TrackerTheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '1:32:00',
                          style: AppTextStyles.heading.copyWith(
                            color: TrackerTheme.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
