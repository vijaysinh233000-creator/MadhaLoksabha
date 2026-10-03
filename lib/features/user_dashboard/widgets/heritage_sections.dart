import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'heritage_motion.dart';

class HeritageStorySection extends StatelessWidget {
  const HeritageStorySection({super.key});
  @override
  Widget build(BuildContext context) => _Section(
      eyebrow: 'मोहिते-पाटील कार्यपरंपरा',
    title: 'सहकारातून लोकसेवेपर्यंत',
    subtitle:
        'विविध पिढ्यांमधून पुढे आलेल्या सार्वजनिक आणि संस्थात्मक कार्याचा प्रवास.',
    child: const Column(
      children: [
        _ImpactAtlas(),
        SizedBox(height: 18),
        _LivingChapters(),
        SizedBox(height: 18),
        _SugarInstitutionNames(),
        SizedBox(height: 18),
        _FamilyTree(),
      ],
    ),
  );
}

/// Cinematic, full-bleed documentary panel — a single real photograph with
/// an editorial headline and a caption strip. No illustrated diagrams.
class _ImpactAtlas extends StatelessWidget {
  const _ImpactAtlas();

  static const _domains = <({IconData icon, String label})>[
    (icon: Icons.water_drop_rounded, label: 'कृष्णा–भीमा'),
    (icon: Icons.agriculture_rounded, label: 'शेतमाती'),
    (icon: Icons.school_rounded, label: 'ज्ञानग्राम'),
    (icon: Icons.alt_route_rounded, label: 'जोडणारे रस्ते'),
    (icon: Icons.sports_martial_arts_rounded, label: 'मातीचा खेळ'),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 650;
    return HeritageMotion(
      enableTilt: false,
      child: Container(
        width: double.infinity,
        height: compact ? 420 : 460,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(color: Color(0x44051A14), blurRadius: 30, offset: Offset(0, 16)),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Semantics(
              label: 'उजनी धरण आणि कृष्णा-भीमा खोऱ्याचे दृश्य',
              image: true,
              child: Image.asset(
                'assets/images/heritage_floating_landscape.png',
                fit: BoxFit.cover,
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x99060D0B), Color(0x22060D0B), Color(0xE6060D0B)],
                  stops: [0, 0.4, 1],
                ),
              ),
            ),
            Positioned(
              left: compact ? 18 : 28,
              right: compact ? 18 : 28,
              top: compact ? 20 : 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(width: 22, height: 2, color: AppColors.gold),
                    const SizedBox(width: 8),
                    const Text(
                      'एक जिवंत भूप्रदेश',
                      style: TextStyle(color: AppColors.goldSoft, fontSize: 10.5, fontWeight: FontWeight.w900, letterSpacing: 2),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Text(
                    'पाण्यापासून प्रगतीपर्यंत',
                    style: TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      color: Colors.white,
                      fontSize: compact ? 24 : 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const SizedBox(
                    width: 360,
                    child: Text(
                      'कृष्णा–भीमा खोरे, उजनी सिंचन आणि त्यातून फुललेली शेतमाती — माढ्याच्या विकासाचा पाया.',
                      style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12.5, height: 1.45, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 24, vertical: compact ? 12 : 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x33D4AF37))),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      for (var i = 0; i < _domains.length; i++) ...[
                        if (i > 0) const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('•', style: TextStyle(color: Color(0x66FFFFFF)))),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(_domains[i].icon, color: AppColors.goldSoft, size: 15),
                          const SizedBox(width: 6),
                          Text(_domains[i].label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                        ]),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivingChapters extends StatelessWidget {
  const _LivingChapters();

  static const _chapters = <({String number, String title, String story, String asset, IconData icon, Color accent})>[
    (number: '01', title: 'पाणी', story: 'नदी, धरण आणि शेतापर्यंत पोहोचणारी आशा', asset: 'assets/images/heritage_floating_landscape.png', icon: Icons.water_drop_rounded, accent: Color(0xFF64D9F0)),
    (number: '02', title: 'माती', story: 'ऊस, शेती आणि सहकारातून उभे राहणारे गाव', asset: 'assets/images/heritage_green_landscape.png', icon: Icons.grass_rounded, accent: Color(0xFFB9E77A)),
    (number: '03', title: 'ज्ञान', story: 'शाळेपासून महाविद्यालयापर्यंतची संधी', asset: 'assets/images/heritage_college.png', icon: Icons.school_rounded, accent: Color(0xFFFFD166)),
    (number: '04', title: 'जोडणी', story: 'रस्ते, बाजार आणि गावांना जोडणारा प्रवास', asset: 'assets/images/sector_roads.png', icon: Icons.alt_route_rounded, accent: Color(0xFFFFA06B)),
    (number: '05', title: 'ओळख', story: 'कुस्ती, कला आणि खेळातून जिवंत राहणारी माती', asset: 'assets/images/sector_culture.png', icon: Icons.sports_martial_arts_rounded, accent: Color(0xFFD2A7FF)),
  ];

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(left: 4, bottom: 10),
        child: Row(children: [
          Icon(Icons.auto_awesome_rounded, color: Color(0xFFD19A3B), size: 18),
          SizedBox(width: 7),
          Text('जिवंत माढा', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.navyText)),
          SizedBox(width: 8),
          Text('एक अनुभव • पाच अध्याय', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w700)),
        ]),
      ),
      SizedBox(
        height: 245,
        child: LayoutBuilder(builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _chapters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) => _ChapterCard(chapter: _chapters[index], width: compact ? 220 : 250),
          );
        }),
      ),
    ],
  );
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({required this.chapter, required this.width});
  final ({String number, String title, String story, String asset, IconData icon, Color accent}) chapter;
  final double width;

  @override
  Widget build(BuildContext context) => HeritageMotion(
    child: Semantics(
      label: '${chapter.title}: ${chapter.story}',
      child: Container(
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF102B31),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: chapter.accent.withValues(alpha: .55)),
          boxShadow: [BoxShadow(color: chapter.accent.withValues(alpha: .15), blurRadius: 20, offset: const Offset(0, 9))],
        ),
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(chapter.asset, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()),
          DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, const Color(0xF20A2028)]))),
          Positioned(top: 14, left: 15, child: Text(chapter.number, style: TextStyle(color: chapter.accent, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5))),
          Positioned(top: 12, right: 14, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0x66101F26), shape: BoxShape.circle, border: Border.all(color: chapter.accent.withValues(alpha: .7))), child: Icon(chapter.icon, color: chapter.accent, size: 18))),
          Positioned(left: 15, right: 14, bottom: 15, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(chapter.title, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(chapter.story, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xD9FFFFFF), fontSize: 11.5, height: 1.35, fontWeight: FontWeight.w700))])),
        ]),
      ),
    ),
  );
}



class _FamilyTree extends StatelessWidget {
  const _FamilyTree();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(4, 10, 4, 8),
    decoration: BoxDecoration(
      color: const Color(0xFFF8FCF9),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0x1A176B3A)),
    ),
    child: Column(
      children: [
            const _GenerationLabel('पहिली पिढी'),
            const SizedBox(height: 4),
            const FractionallySizedBox(
              widthFactor: .74,
              child: _Person(
                slug: 'shankarrao',
                name: 'सहकार महर्षी शंकरराव मोहिते-पाटील',
                role: 'सहकार आणि लोकसेवेच्या वारशाचे शिल्पकार',
                institutions: [
                  'सहकार महर्षी साखर कारखाना',
                  'शिक्षण प्रसारक मंडळ',
                ],
                image: 'assets/images/shankarrao_mohite_patil.jpg',
                imageAlignment: Alignment(-.55, -.15),
                featured: true,
              ),
            ),
            const SizedBox(height: 22),
            const _GenerationLabel('दुसरी पिढी'),
            const SizedBox(height: 4),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Person(
                    slug: 'vijaysinh',
                    name: 'विजयसिंह मोहिते-पाटील',
                    role: 'राज्य व प्रादेशिक सार्वजनिक जीवन',
                    institutions: ['सिंचन', 'शिक्षण', 'सहकार'],
                    image: 'assets/images/vijaysinh_mohite_patil.jpg',
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _Person(
                    slug: 'jaysinh',
                    name: 'जयसिंह (बालदादा) मोहिते-पाटील',
                    role: 'शिक्षण, सहकार आणि महालेझीम चळवळ',
                    image: 'assets/images/jaysinh_mohite_patil.jpg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const _GenerationLabel('तिसरी पिढी'),
            const SizedBox(height: 4),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Person(
                    slug: 'ranjitsinh',
                    name: 'रणजितसिंह मोहिते-पाटील',
                    role: 'युवा नेतृत्व आणि सहकार',
                    institutions: ['DCC बँक', 'युवा संघटन'],
                    image: 'assets/images/ranjitsinh_mohite_patil.jpg',
                    featured: true,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _Person(
                    slug: 'dhairyasheel',
                    name: 'खासदार धैर्यशील राजसिंह मोहिते-पाटील',
                    role: 'माढा लोकसभा मतदारसंघाचे प्रतिनिधित्व',
                    institutions: ['शिवमृत दूध संघ', 'शिवरत्न शिक्षण संस्था'],
                    image: 'assets/images/dhairyashil_mohite_patil.jpg',
                    featured: true,
                  ),
                ),
              ],
            ),
      ],
    ),
  );
}

class _SugarInstitutionNames extends StatelessWidget {
  const _SugarInstitutionNames();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
    decoration: BoxDecoration(
      color: const Color(0xF7FFFDF7),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0x99C99A3D)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x16000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: const Column(
      children: [
        Text(
          'संस्थांचे कार्यविश्व',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'NotoSansDevanagari',
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.heritageBrown,
          ),
        ),
        SizedBox(height: 8),
        _InstitutionName(
          text:
              'सहकार महर्षी शंकरराव मोहिते-पाटील सहकारी साखर कारखाना लि., शंकरनगर-अकलूज',
        ),
        _InstitutionName(text: 'श्री शंकर सहकारी साखर कारखाना लि., सदाशिवनगर'),
        _InstitutionName(text: 'शिवमृत दूध उत्पादक सहकारी संघ, अकलूज'),
        _InstitutionName(text: 'शिक्षण प्रसारक मंडळ, अकलूज'),
        _InstitutionName(text: 'शिवरत्न शिक्षण संस्था, अकलूज'),
        _InstitutionName(text: 'शंकरराव मोहिते महाविद्यालय, अकलूज'),
        _InstitutionName(
          text:
              'सहकार महर्षी शंकरराव मोहिते-पाटील इन्स्टिट्यूट ऑफ टेक्नॉलॉजी अँड रिसर्च',
        ),
        _InstitutionName(text: 'शिक्षण प्रसारक मंडळ कॉलेज ऑफ फार्मसी, अकलूज'),
        _InstitutionName(
          text: 'सोलापूर जिल्हा मध्यवर्ती सहकारी बँक — नेतृत्वातील योगदान',
        ),
      ],
    ),
  );
}

class _InstitutionName extends StatelessWidget {
  const _InstitutionName({required this.text}) : last = false;
  final String text;
  final bool last;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: last ? 0 : 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(
            Icons.factory_rounded,
            size: 15,
            color: AppColors.greenDark,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'NotoSansDevanagari',
              fontSize: 11,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: AppColors.navyText,
            ),
          ),
        ),
      ],
    ),
  );
}

class _GenerationLabel extends StatelessWidget {
  const _GenerationLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFF176B3A),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: const Color(0xFFE5BD64), width: 1),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontFamily: 'NotoSansDevanagari',
        fontSize: 15,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    ),
  );
}

class _Person extends StatelessWidget {
  const _Person({
    required this.slug,
    required this.name,
    required this.role,
    this.institutions = const [],
    this.image,
    this.imageAlignment = Alignment.topCenter,
    this.featured = false,
  }) : icon = Icons.person_rounded;
  final String slug;
  final String name;
  final String role;
  final List<String> institutions;
  final String? image;
  final Alignment imageAlignment;
  final IconData icon;
  final bool featured;
  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 700;
    return SizedBox(
      height: compact ? 340 : 365,
      child: HeritageMotion(
        child: Semantics(
      button: true,
      label: '$name — जीवनप्रवास वाचा',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed('/profile/$slug'),
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            padding: EdgeInsets.fromLTRB(
              compact ? 9 : 14,
              compact ? 14 : 18,
              compact ? 9 : 14,
              compact ? 12 : 15,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: featured
                    ? const Color(0xFFD3A746)
                    : const Color(0x2B176B3A),
                width: featured ? 1.5 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x130A3A22),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Portrait(
                  image: image,
                  icon: icon,
                  alignment: imageAlignment,
                  size: featured ? (compact ? 104 : 132) : (compact ? 82 : 100),
                  borderWidth: featured ? 3 : 2,
                ),
                const SizedBox(height: 11),
                _PersonCopy(
                  name: name,
                  role: role,
                  institutions: institutions,
                  centered: true,
                  compact: compact,
                ),
              ],
            ),
          ),
        ),
      ),
        ),
      ),
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait({
    required this.image,
    required this.icon,
    required this.alignment,
    required this.size,
    required this.borderWidth,
  });
  final String? image;
  final IconData icon;
  final Alignment alignment;
  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: const Color(0xFFEAF5EC),
      border: Border.all(color: const Color(0xFFD3A746), width: borderWidth),
      boxShadow: const [
        BoxShadow(
          color: Color(0x25104B2A),
          blurRadius: 13,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: ClipOval(
      child: image == null
          ? Icon(icon, color: AppColors.heritageBrown, size: size * .42)
          : Image.asset(image!, fit: BoxFit.cover, alignment: alignment),
    ),
  );
}

class _PersonCopy extends StatelessWidget {
  const _PersonCopy({
    required this.name,
    required this.role,
    required this.institutions,
    this.centered = false,
    this.compact = false,
  });
  final String name;
  final String role;
  final List<String> institutions;
  final bool centered;
  final bool compact;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: centered
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start,
    children: [
      Text(
        name,
        textAlign: centered ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: compact ? 14 : 18,
          height: 1.28,
          fontWeight: FontWeight.w900,
          color: AppColors.navyText,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        role,
        textAlign: centered ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontFamily: 'NotoSansDevanagari',
          fontSize: compact ? 11 : 13,
          height: 1.35,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
      if (institutions.isNotEmpty) ...[
        const SizedBox(height: 8),
        Wrap(
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          spacing: 4,
          runSpacing: 4,
          children: institutions
              .map(
                (item) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5EC),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontFamily: 'NotoSansDevanagari',
                      fontSize: compact ? 9 : 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.greenDark,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
      const SizedBox(height: 9),
      Row(
        mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.menu_book_rounded, size: 19, color: AppColors.greenDark),
          SizedBox(width: 4),
          Text(
            'वाचा',
            style: TextStyle(
              fontFamily: 'NotoSansDevanagari',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.greenDark,
            ),
          ),
        ],
      ),
    ],
  );
}

class InstitutionJourneySection extends StatelessWidget {
  const InstitutionJourneySection({super.key});
  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.account_balance_rounded,
        'सहकार',
        'सहकारी संस्था व उद्योग',
        'cooperation',
        'assets/images/heritage_sugar_factory.jpg',
      ),
      (
        Icons.agriculture_rounded,
        'शेती',
        'कृषी व पूरक व्यवसाय',
        'agriculture',
        'assets/images/heritage_floating_landscape.png',
      ),
      (
        Icons.school_rounded,
        'शिक्षण',
        'शैक्षणिक संस्थांचा प्रवास',
        'education',
        'assets/images/heritage_college.png',
      ),
      (
        Icons.health_and_safety_rounded,
        'आरोग्य',
        'वैद्यकीय सेवा व मदतकार्य',
        'health',
        'assets/images/sector_healthcare.png',
      ),
      (
        Icons.water_drop_rounded,
        'पाणी व सिंचन',
        'दुष्काळी भागाचा जलप्रवास',
        'water',
        'assets/images/sector_water.png',
      ),
      (
        Icons.route_rounded,
        'रस्ते व संपर्क',
        'पायाभूत ���ुविधा व वाहतूक',
        'roads',
        'assets/images/sector_roads.png',
      ),
      (
        Icons.theater_comedy_rounded,
        'कला व संस्कृती',
        'लोककला आणि सांस्कृतिक परंपरा',
        'culture',
        'assets/images/sector_culture.png',
      ),
      (
        Icons.volunteer_activism_rounded,
        'लोकसे��ा',
        'नागरिक-केंद्रित उपक्रम',
        'public-service',
        'assets/images/sector_public_service.png',
      ),
    ];
    return _Section(
      eyebrow: 'समाजकारणाचा प्रवास',
      title: 'लोकसेवेचा वसा',
      subtitle:
          'प्रत्येक क्षेत्रातील सविस्तर कार्य आणि संस्थात्मक प्रवास वाचा.',
      child: LayoutBuilder(
        builder: (context, c) {
          final width = (c.maxWidth - 10) / 2;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final x in items)
                SizedBox(
                  width: width,
                  child: _Institution(
                    icon: x.$1,
                    title: x.$2,
                    text: x.$3,
                    slug: x.$4,
                    image: x.$5,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Institution extends StatefulWidget {
  const _Institution({
    required this.icon,
    required this.title,
    required this.text,
    required this.slug,
    required this.image,
  });
  final IconData icon;
  final String title;
  final String text;
  final String slug;
  final String image;

  @override
  State<_Institution> createState() => _InstitutionState();
}

class _InstitutionState extends State<_Institution> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => HeritageMotion(
    enableTilt: false,
    child: MouseRegion(
      onEnter: MediaQuery.disableAnimationsOf(context)
          ? null
          : (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.025 : 1,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                Navigator.of(context).pushNamed('/sector/${widget.slug}'),
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(widget.image),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x290A345E),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x18000000), Color(0xE6001D38)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(widget.icon, color: const Color(0xFFFFC75A), size: 28),
                    const SizedBox(height: 8),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'NotoSansDevanagari',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.text,
                      style: const TextStyle(
                        fontFamily: 'NotoSansDevanagari',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'सविस्तर प्रवास वाचा  →',
                      style: TextStyle(
                        fontFamily: 'NotoSansDevanagari',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFFD67D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class PublicWorkSection extends StatelessWidget {
  const PublicWorkSection({super.key});
  @override
  Widget build(BuildContext context) {
    const works = [
      (Icons.water_drop_rounded, 'पाणी व सिंचन', 'water'),
      (Icons.school_rounded, 'शिक्षण', 'education'),
      (Icons.health_and_safety_rounded, 'आरोग्य सेवा', 'health'),
      (Icons.agriculture_rounded, 'शेती व कृषी-उद्योग', 'agriculture'),
    ];
    return _Section(
      eyebrow: 'पारदर्शक माहिती',
      title: 'सार्वजनिक कार्य',
      subtitle: 'क्षेत्रनिहाय विस्तृत माहिती वाचण्यासाठी विभाग निवडा.',
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth < 720 ? 2 : 4;
              final width = (c.maxWidth - (cols - 1) * 10) / cols;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final x in works)
                    SizedBox(
                      width: width,
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/sector/${x.$3}'),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            children: [
                              Icon(x.$1, color: AppColors.heritageBrown),
                              const SizedBox(height: 7),
                              Text(
                                x.$2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'NotoSansDevanagari',
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.navyText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'सविस्तर वाचा →',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'NotoSansDevanagari',
                                  fontSize: 10,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28),
    child: Column(
      children: [
        HeritageMotion(
          child: Column(
            children: [
              Text(
                eyebrow,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'NotoSansDevanagari',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                  color: AppColors.heritageBrown,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'NotoSansDevanagari',
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navyText,
                ),
              ),
              const SizedBox(height: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoSansDevanagari',
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        child,
      ],
    ),
  );
}

class NewBrandFooter extends StatelessWidget {
  const NewBrandFooter({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    color: AppColors.navy,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            const Text(
              'धैर्यशील मोहिते-पाटील',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'NotoSansDevanagari',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
                'माढा लोकसभा',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'NotoSansDevanagari',
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 14,
                  color: Colors.white60,
                ),
                const Text(
                  'शोधासाठी दिलेली वैयक्तिक माहिती संग्रहित केली जात नाही.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NotoSansDevanagari',
                    color: Colors.white60,
                    fontSize: 10.5,
                  ),
                ),
                Text(
                  '© ${DateTime.now().year}',
                  style: const TextStyle(color: Colors.white60, fontSize: 10.5),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
