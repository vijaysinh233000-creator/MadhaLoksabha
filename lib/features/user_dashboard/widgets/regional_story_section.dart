import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'heritage_motion.dart';

class RegionalStorySection extends StatelessWidget {
  const RegionalStorySection({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppShadows.subtle,
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'NotoSansDevanagari',
            color: AppColors.textPrimary,
            height: 1.5,
            fontSize: 14,
          ),
          child: Column(
            children: [
              _Scene(
                asset: 'assets/images/regional_journey.png',
                title: 'अकलूज → मुंबई → दिल्ली',
                subtitle: 'विकास आणि नेतृत्वाचा प्रवास',
                description:
                    'सहकार आणि स्थानिक नेतृत्वापासून राज्याच्या विधिमंडळापर्यंत, लोकसभा आणि राज्यसभेपर्यंतचा सार्वजनिक प्रवास.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _JourneyStops(),
                    const SizedBox(height: 18),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                      ),
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed('/sector/regional-journey'),
                      child: const Text('सविस्तर वाचा →'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              _Scene(
                asset: 'assets/images/regional_water.png',
                title: 'कृष्णा–भीमा स्थिरीकरण',
                subtitle: 'पाण्याचा प्रत्येक थेंब भविष्याशी जोडलेला',
                description:
                    'कृष्णा खोऱ्यातील अतिरिक्त पाणी दुष्काळी भागाकडे वळवण्याची जलसंकल्पना. पाणी, शेती आणि ग्रामीण भविष्याचा महत्त्वाचा विषय.',
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/sector/water'),
                    child: const Text('पाणी व सिंचनाचा प्रवास वाचा →'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'माढा लोकसभा — सहा विधानसभा क्षेत्रे',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, c) {
                        final columns = c.maxWidth >= 800 ? 6 : 2;
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (final name in [
                              'करमाळा',
                              'माढा',
                              'सांगोला',
                              'माळशिरस',
                              'फलटण',
                              'माण',
                            ])
                              Container(
                                width:
                                    (c.maxWidth - (columns - 1) * 10) / columns,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Scene extends StatelessWidget {
  const _Scene({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.child,
  });
  final String asset, title, subtitle, description;
  final Widget child;

  Widget _copy(bool compact) => Padding(
    padding: EdgeInsets.all(compact ? 20 : 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: compact ? 27 : 34,
            height: 1.25,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: compact ? 18 : 21,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),
        child,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => HeritageMotion(
    enableTilt: false,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 800;
        if (compact) {
          return Column(
            children: [
              _copy(true),
              Image.asset(
                asset,
                width: double.infinity,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 390),
                child: _copy(false),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SizedBox(
                  height: 390,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      asset,
                      fit: BoxFit.cover,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _JourneyStops extends StatelessWidget {
  const _JourneyStops();
  @override
  Widget build(BuildContext context) => const Wrap(
    spacing: 14,
    runSpacing: 10,
    children: [
      _Stop('अकलूज', 'सहकार व लोकसेवा'),
      _Stop('मुंबई', 'विधिमंडळ व मंत्रिपदे'),
      _Stop('दिल्ली', 'लोकसभा व राज्यसभा'),
    ],
  );
}

class _Stop extends StatelessWidget {
  const _Stop(this.name, this.office);
  final String name, office;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        name,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(
        office,
        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
      ),
    ],
  );
}
