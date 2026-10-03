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
              border: Border.symmetric(
                horizontal: BorderSide(color: Color(0x1A000000)),
              ),
            ),
            child: AspectRatio(
              aspectRatio: 2048 / 931,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/madha_loksabha_banner.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC062D28)],
                        stops: [0.48, 1],
                      ),
                    ),
                  ),
                  Positioned(
                    left: mobile ? 14 : 34,
                    right: mobile ? 14 : 34,
                    bottom: mobile ? 12 : 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'माढ्याच्या विकासाचा पुढचा अध्याय',
                                style: TextStyle(
                                  color: const Color(0xFFFFD77A),
                                  fontSize: mobile ? 10 : 14,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .3,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'पाणी • शेती • शिक्षण • रोजगार',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: mobile ? 15 : 24,
                                  fontWeight: FontWeight.w900,
                                  height: 1.05,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!mobile)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                            decoration: BoxDecoration(
                              color: const Color(0xDDFFFFFF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Text(
                              'लोकसेवा प्रथम',
                              style: TextStyle(
                                color: AppColors.greenDark,
                                fontWeight: FontWeight.w900,
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
        ],
      ),
    );
  }
}
