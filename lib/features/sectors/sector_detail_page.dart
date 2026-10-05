import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'sector_data.dart';

class SectorDetailPage extends StatelessWidget {
  const SectorDetailPage({super.key, required this.profile});
  final SectorProfile profile;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.surface,
    appBar: AppBar(
      backgroundColor: AppColors.navy,
      foregroundColor: Colors.white,
      title: Text(
        profile.title,
        style: const TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    body: SelectionArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 16 / 8,
                    child: Image.asset(profile.heroAsset, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0A345E), Color(0xFF146B4A)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x280A345E),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        profile.icon,
                        size: 46,
                        color: const Color(0xFFFFC75A),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'NotoSansDevanagari',
                          fontSize: 28,
                          height: 1.3,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.intro,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'NotoSansDevanagari',
                          fontSize: 16,
                          height: 1.65,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width < 600
                        ? 18
                        : 34,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE7D9BB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (
                        var index = 0;
                        index < profile.sections.length;
                        index++
                      ) ...[
                        _ArticleSection(section: profile.sections[index]),
                        if (index != profile.sections.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Divider(color: Color(0xFFE7D9BB)),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({required this.section});
  final SectorSection section;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        section.title,
        style: const TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w900,
          color: AppColors.navyText,
        ),
      ),
      const SizedBox(height: 12),
      for (final point in section.points)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 7),
                child: Icon(Icons.circle, size: 7, color: AppColors.greenDark),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  point,
                  style: const TextStyle(
                    fontFamily: 'NotoSansDevanagari',
                    fontSize: 15.5,
                    height: 1.75,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navyText,
                  ),
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
