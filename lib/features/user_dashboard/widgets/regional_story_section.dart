import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'heritage_motion.dart';

class RegionalStorySection extends StatelessWidget {
  const RegionalStorySection({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF102C25),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'NotoSansDevanagari',
          color: Color(0xFFE1EAE5),
          fontSize: 14,
          height: 1.65,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Title('अकलूज ते माढा'),
            const Text('संस्था, पाणी आणि लोकप्रतिनिधित्व'),
            const SizedBox(height: 22),
            HeritageMotion(
              enableTilt: false,
              child: Image.asset(
                'assets/images/regional_college_reference.png',
                width: double.infinity,
                fit: BoxFit.contain,
                semanticLabel:
                    'SMSMPITR, शंकरनगर-अकलूजचे अधिकृत प्रवेशद्वार छायाचित्र',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SMSMPITR, शंकरनगर-अकलूज • अधिकृत वेबसाइटवरील मूळ छायाचित्र',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const _Title('अकलूजचे शैक्षणिक कार्यविश्व'),
            const Text(
              'सहकार महर्षी शंकरराव मोहिते-पाटील इन्स्टिट्यूट ऑफ टेक्नॉलॉजी अँड रिसर्च ग्रामीण विद्यार्थ्यांना अभियांत्रिकी शिक्षण उपलब्ध करून देते. संस्था शंकरराव मोहिते-पाटील चॅरिटेबल हॉस्पिटल ट्रस्ट अंतर्गत कार्यरत आहे.',
            ),
            const _Reference(
              'संस्थेची अधिकृत माहिती',
              'https://www.smsmpitr.edu.in/',
            ),
            const Divider(height: 40, color: Colors.white24),
            const _Title('कृष्णा–भीमा स्थिरीकरण'),
            const Text(
              '१८ मार्च २०२१ रोजी लोकसभेत दिलेल्या जलशक्ती मंत्रालयाच्या उत्तरानुसार, महाराष्ट्राने वरच्या कृष्णा उपखोऱ्यातील पूरपाणी गुरुत्वाकर्षणाने विविध जोडमार्गांतून वळवण्याची कृष्णा–भीमा स्थिरीकरण संकल्पना मांडली होती. राष्ट्रीय जलविकास अभिकरणाने पूर्वव्यवहार्यता अहवाल तयार करून २०११ मध्ये राज्य शासनाला पाठवला होता.',
            ),
            const SizedBox(height: 8),
            const Text(
              'ही दिनांकित ऐतिहासिक नोंद आहे; प्रकल्प पूर्ण झाल्याचा किंवा आजच्या मंजुरीस्थितीचा दावा नाही.',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const _Reference(
              'लोकसभेतील अधिकृत उत्तर · १८ मार्च २०२१',
              'https://sansad.in/getFile/loksabhaquestions/annex/175/AU3836.pdf?source=pqals',
            ),
            const Divider(height: 40, color: Colors.white24),
            const _Title('माढा लोकसभा मतदारसंघ'),
            const Text('सोलापूर आणि सातारा जिल्ह्यांतील सहा विधानसभा क्षेत्रे'),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) => Wrap(
                spacing: 8,
                runSpacing: 8,
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
                      width: (constraints.maxWidth - 8) / 2,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white24),
                        ),
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),
            const _Reference(
              'जिल्हा निवडणूक शाखा · मतदारसंघाची माहिती',
              'https://solapur.gov.in/en/election-branch/',
            ),
          ],
        ),
      ),
    ),
  );
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    ),
  );
}

class _Reference extends StatelessWidget {
  const _Reference(this.label, this.url);
  final String label;
  final String url;
  @override
  Widget build(BuildContext context) => TextButton(
    style: TextButton.styleFrom(foregroundColor: const Color(0xFFDFCA91)),
    onPressed: () async {
      try {
        final opened = await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
        if (!opened && context.mounted) _failed(context);
      } catch (_) {
        if (context.mounted) _failed(context);
      }
    },
    child: Text(
      label,
      style: const TextStyle(fontFamily: 'NotoSansDevanagari', fontSize: 12),
    ),
  );
  void _failed(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('संदर्भ उघडता आला नाही. पुन्हा प्रयत्न करा.'),
        ),
      );
}
