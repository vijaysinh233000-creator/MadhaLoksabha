import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});

  static final Uri _whatsAppShare = Uri.https('wa.me', '/', {
    'text':
        'धैर्यशील मोहिते-पाटील | माढा लोकसभा\n'
        'माझे नाव मतदार यादीत शोधा:\n'
        'https://independent-voter.madhaloksabha.workers.dev/',
  });

  Future<void> _shareOnWhatsApp(BuildContext context) async {
    final opened = await launchUrl(
      _whatsAppShare,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('WhatsApp उघडता आले नाही.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 700;
    return ColoredBox(
      color: const Color(0xFFFFFCF5),
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mobile ? 14 : 24,
                  vertical: mobile ? 10 : 13,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'धैर्यशील मोहिते-पाटील',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'NotoSansDevanagari',
                              fontSize: mobile ? 19 : 25,
                              fontWeight: FontWeight.w900,
                              color: AppColors.navyText,
                            ),
                          ),
                          Text(
                            'माढा लोकसभा',
                            style: TextStyle(
                              fontFamily: 'NotoSansDevanagari',
                              fontSize: mobile ? 10.5 : 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.greenDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!mobile)
                      const Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Text(
                          'मतदार शोध  •  लोकसेवा  •  सार्वजनिक कार्य',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    Tooltip(
                      message: 'WhatsApp वर शेअर करा',
                      child: IconButton.filledTonal(
                        onPressed: () => _shareOnWhatsApp(context),
                        icon: const Icon(Icons.share_rounded),
                        color: AppColors.greenDark,
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFE4F5E9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 1440),
            decoration: const BoxDecoration(
              border: Border.symmetric(horizontal: BorderSide(color: Color(0x22000000))),
            ),
            child: AspectRatio(
              aspectRatio: 2048 / 931,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Semantics(
                    label: 'धैर्यशील मोहिते-पाटील आणि माढा मतदारसंघाचे चित्र',
                    image: true,
                    child: Image.asset('assets/images/madha_loksabha_banner.jpg', fit: BoxFit.cover, alignment: Alignment.center),
                  ),
                  const ExcludeSemantics(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0x22052E2A), Color(0x00000000), Color(0xE6052725)], stops: [0, .44, 1])))),
                  Positioned.fill(child: ExcludeSemantics(child: IgnorePointer(child: CustomPaint(painter: _HeroContourPainter())))),
                  Positioned(
                    left: mobile ? 14 : 34,
                    right: mobile ? 14 : 34,
                    top: mobile ? 14 : 24,
                    child: Row(children: [
                      _HeroTag(icon: Icons.water_drop_rounded, label: 'कृष्णा–भीमा'),
                      const SizedBox(width: 7),
                      _HeroTag(icon: Icons.explore_rounded, label: 'माढा 360°'),
                      const Spacer(),
                      if (!mobile) const Text('एक मतदारसंघ • अनेक कथा', style: TextStyle(color: Color(0xE6FFFFFF), fontWeight: FontWeight.w800, fontSize: 12)),
                    ]),
                  ),
                  Positioned(
                    left: mobile ? 14 : 34,
                    right: mobile ? 14 : 34,
                    bottom: mobile ? 12 : 24,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('माढ्याच्या विकासाचा पुढचा अध्याय', style: TextStyle(color: const Color(0xFFFFD77A), fontSize: mobile ? 10 : 14, fontWeight: FontWeight.w800, letterSpacing: .3)),
                        const SizedBox(height: 3),
                        Text('पाणी • शेती • शिक्षण • रोजगार', style: TextStyle(color: Colors.white, fontSize: mobile ? 15 : 26, fontWeight: FontWeight.w900, height: 1.05)),
                      ])),
                      if (!mobile) Container(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10), decoration: BoxDecoration(color: const Color(0xDDFCF7E9), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0x99FFD77A))), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.verified_rounded, color: AppColors.greenDark, size: 17), SizedBox(width: 6), Text('लोकसेवा प्रथम', style: TextStyle(color: AppColors.greenDark, fontWeight: FontWeight.w900))])),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0x99112625),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0x66D7F1D3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: const Color(0xFFFFD77A)),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
    ]),
  );
}

class _HeroContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1..color = const Color(0x55D7F1D3);
    for (var i = 0; i < 5; i++) {
      final path = Path()..moveTo(-20, size.height * (.54 + i * .08));
      for (var x = 0.0; x <= size.width + 40; x += 24) {
        path.lineTo(x, size.height * (.54 + i * .08) + 10 * math.sin(x / 70 + i));
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
