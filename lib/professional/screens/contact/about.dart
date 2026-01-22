import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sheqlee/professional/widget/login/backbutton.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  // Shared controller to fix the ScrollPosition error
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(10),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            /// 🔹 Resizing Header
            SliverAppBar(
              expandedHeight: 140, // Height when at top
              collapsedHeight: 80, // Height when scrolled down
              pinned: true,
              floating: false,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 25, bottom: 20),
                centerTitle: false,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppBackButton(),
                    const SizedBox(width: 50),
                    const Text(
                      'About',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'pretendard',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 🔹 Static URL List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    "Web view from Sheqlee\n& Medium websites",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Pages:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  _buildUrlItem("About", "https://medium.com/@sheqlee/about"),
                  _buildUrlItem("Blog", "https://medium.com/@sheqlee"),
                  _buildUrlItem("Pricing", "https://sheqlee.com/pricing"),
                  _buildUrlItem("Getting started", "https://sheqlee.com/start"),
                  _buildUrlItem(
                    "Terms of Service",
                    "https://sheqlee.com/terms",
                  ),
                  _buildUrlItem(
                    "Privacy Policy",
                    "https://sheqlee.com/privacy",
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrlItem(String title, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: 'pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
