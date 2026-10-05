import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});

  static final Uri _whatsAppShare = Uri.https('wa.me', '/', {
    'text':
        'धैर्यशील मोहिते-पाटील | माढा लोकसभा मतदारसंघ\n'
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
      color: AppColors.navy,
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
                    Container(
                      width: mobile ? 40 : 48,
                      height: mobile ? 40 : 48,
                      margin: const EdgeInsets.only(right: 11),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: AppColors.heritageGold,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/dhairyashil_mohite_patil.jpg',
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
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
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'माढा लोकसभा',
                            style: TextStyle(
                              fontFamily: 'NotoSansDevanagari',
                              fontSize: mobile ? 10.5 : 12.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heritageGold,
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
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    Tooltip(
                      message: 'WhatsApp वर शेअर करा',
                      child: IconButton.filledTonal(
                        onPressed: () => _shareOnWhatsApp(context),
                        icon: const Icon(Icons.share_rounded),
                        color: Colors.white,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.saffron,
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
                horizontal: BorderSide(color: AppColors.heritageGold),
              ),
            ),
            child: AspectRatio(
              aspectRatio: 1855 / 848,
              child: Image.asset(
                'assets/images/madha_loksabha_banner_fresh.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
