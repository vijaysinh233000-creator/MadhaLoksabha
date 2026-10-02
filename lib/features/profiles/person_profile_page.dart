import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/common_widgets.dart';
import 'profile_data.dart';

class PersonProfilePage extends StatelessWidget {
  const PersonProfilePage({required this.profile, super.key});
  final PersonProfile profile;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF3F8F3),
    appBar: AppBar(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.navyText,
      title: const Text(
        'जीवनप्रवास',
        style: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    body: SingleChildScrollView(
      child: PageContainer(
        maxWidth: 880,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF2E8D2),
                  border: Border.all(color: AppColors.heritageGold, width: 4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 18,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: profile.image.isEmpty
                      ? const Icon(
                          Icons.person_rounded,
                          size: 76,
                          color: AppColors.heritageBrown,
                        )
                      : Image.asset(
                          profile.image,
                          fit: BoxFit.cover,
                          alignment: profile.slug == 'shankarrao'
                              ? const Alignment(-.55, -.15)
                              : Alignment.topCenter,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              profile.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'NotoSansDevanagari',
                fontSize: 28,
                height: 1.25,
                fontWeight: FontWeight.w900,
                color: AppColors.navyText,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              profile.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'NotoSansDevanagari',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.greenDark,
              ),
            ),
            const SizedBox(height: 24),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'जीवन परिचय',
                    style: TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navyText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile.summary,
                    style: const TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      fontSize: 15,
                      height: 1.75,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (profile.chapters.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'सविस्तर जीवनप्रवास',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'NotoSansDevanagari',
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navyText,
                ),
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < profile.chapters.length; i++) ...[
                _StoryChapter(
                  index: i + 1,
                  title: profile.chapters[i].$1,
                  body: profile.chapters[i].$2,
                ),
                const SizedBox(height: 12),
              ],
            ],
            if (profile.timeline.isNotEmpty) ...[
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'महत्त्वाचा कालक्रम',
                      style: TextStyle(
                        fontFamily: 'NotoSansDevanagari',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navyText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    for (var i = 0; i < profile.timeline.length; i++)
                      _TimelineRow(
                        year: profile.timeline[i].$1,
                        text: profile.timeline[i].$2,
                        last: i == profile.timeline.length - 1,
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'पदे आणि महत्त्वाचे टप्पे',
                    style: TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navyText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final fact in profile.facts)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 11),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.green,
                            size: 19,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${fact.$1}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextSpan(text: fact.$2),
                                ],
                              ),
                              style: const TextStyle(
                                fontFamily: 'NotoSansDevanagari',
                                height: 1.45,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'मराठी लेख आणि व्हिडिओ संदर्भ',
                    style: TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navyText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'अधिक वाचन आणि पाहण्यासाठी निवडक मराठी वृत्तलेख व व्हिडिओ संदर्भ.',
                    style: TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final source in profile.sources)
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          source.$2.contains('youtube.com')
                              ? Icons.play_circle_fill_rounded
                              : Icons.article_rounded,
                          color: source.$2.contains('youtube.com')
                              ? const Color(0xFFC62828)
                              : AppColors.green,
                        ),
                        title: Text(
                          source.$1,
                          style: const TextStyle(
                            fontFamily: 'NotoSansDevanagari',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () => launchUrl(
                          Uri.parse(source.$2),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _StoryChapter extends StatelessWidget {
  const _StoryChapter({
    required this.index,
    required this.title,
    required this.body,
  });
  final int index;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    duration: const Duration(milliseconds: 650),
    curve: Curves.easeOutCubic,
    tween: Tween(begin: 0, end: 1),
    builder: (context, value, child) => Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 16 * (1 - value)),
        child: child,
      ),
    ),
    child: AppCard(
      color: index.isOdd ? Colors.white : const Color(0xFFFFFBF0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green,
                ),
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'NotoSansDevanagari',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.navyText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: const TextStyle(
              fontFamily: 'NotoSansDevanagari',
              fontSize: 15,
              height: 1.8,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.year,
    required this.text,
    required this.last,
  });
  final String year;
  final String text;
  final bool last;
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            year,
            style: const TextStyle(
              fontFamily: 'NotoSansDevanagari',
              fontWeight: FontWeight.w900,
              color: AppColors.heritageBrown,
            ),
          ),
        ),
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.heritageGold,
              ),
            ),
            if (!last)
              const Expanded(
                child: SizedBox(
                  width: 2,
                  child: ColoredBox(color: Color(0xFFE4D2AE)),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'NotoSansDevanagari',
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
