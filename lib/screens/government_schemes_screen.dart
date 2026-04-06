import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_theme.dart';

class Scheme {
  final String title;
  final String organization;
  final String description;
  final String eligibility;
  final String benefits;

  Scheme({
    required this.title,
    required this.organization,
    required this.description,
    required this.eligibility,
    required this.benefits,
  });
}

class GovernmentSchemesScreen extends StatelessWidget {
  GovernmentSchemesScreen({super.key});

  final List<Scheme> schemes = [
    Scheme(
      title: 'Menstrual Hygiene Scheme (MHS)',
      organization: 'Ministry of Health and Family Welfare (NHM), Govt. of India',
      description: 'The scheme aims to promote menstrual hygiene among adolescent girls in rural areas. It focuses on increasing awareness and improving access to high-quality sanitary napkins.',
      eligibility: 'Adolescent girls (10-19 years) primarily in rural areas.',
      benefits: 'Provision of subsidized sanitary napkin packs (Freedays) at ₹6 for a pack of 6 napkins through ASHAs.',
    ),
    Scheme(
      title: 'Rashtriya Kishor Swasthya Karyakram (RKSK)',
      organization: 'Ministry of Health and Family Welfare, Govt. of India',
      description: 'A comprehensive program for adolescents that includes menstrual health as a core component of Sexual and Reproductive Health (SRH).',
      eligibility: 'Adolescent boys and girls (10-19 years) across the country.',
      benefits: 'Peer education, counseling, and clinical services for SRH issues including menstrual disorders and hygiene.',
    ),
    Scheme(
      title: 'Suvidha Sanitary Napkin Scheme',
      organization: 'Department of Pharmaceuticals, Govt. of India',
      description: 'Making quality sanitary pads affordable for every woman in India through Jan Aushadhi Kendras.',
      eligibility: 'All women across India.',
      benefits: 'Oxo-biodegradable sanitary napkins available at only ₹1 per pad at Pradhan Mantri Bhartiya Janaushadhi Pariyojana (PMBJP) centers.',
    ),
    Scheme(
      title: 'Udaan Scheme (Rajasthan State)',
      organization: 'Department of Women and Child Development, Rajasthan',
      description: 'One of the largest state-level schemes for menstrual health awareness and free pad distribution.',
      eligibility: 'All girls and women in Rajasthan.',
      benefits: 'Free distribution of 12 sanitary pads every month to school-going girls and women in the state.',
    ),
    Scheme(
      title: 'Asmita Yojana (Maharashtra State)',
      organization: 'Govt. of Maharashtra',
      description: 'A scheme to provide low-cost sanitary napkins to rural adolescent girls and women.',
      eligibility: 'School-going girls in Zilla Parishad schools and rural women through Self Help Groups (SHGs).',
      benefits: 'Subsidized pads at ₹5 for school girls and low-cost availability for rural women.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.accentCream,
      appBar: AppBar(
        title: const Text('Government Schemes', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back, color: AppTheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return _buildSchemeCard(context, scheme);
        },
      ),
    );
  }

  Widget _buildSchemeCard(BuildContext context, Scheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.05),
            offset: const Offset(0, 10),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Organization
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppTheme.primary.withValues(alpha: 0.05),
              child: Text(
                scheme.organization.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scheme.title,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    scheme.description,
                    style: TextStyle(
                      color: AppTheme.primary.withValues(alpha: 0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailRow(Symbols.groups, 'Eligibility', scheme.eligibility),
                  const SizedBox(height: 12),
                  _buildDetailRow(Symbols.star, 'Benefits', scheme.benefits),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Placeholder for more details
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Redirecting to scheme website...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('LEARN MORE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primary, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: AppTheme.primary, fontSize: 13, height: 1.4),
              children: [
                TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w900)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
