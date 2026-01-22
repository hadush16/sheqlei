import 'package:flutter/material.dart';
import 'package:sheqlee/professional/widget/login/backbutton.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  // 1. Shared controller to fix "ScrollController has no ScrollPosition attached"
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        controller: _scrollController, // Attach controller here
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(10),
        child: CustomScrollView(
          controller: _scrollController, // Attach same controller here
          slivers: [
            /// 🔙 Resizing Header (Row with Back Button and FAQ)
            SliverAppBar(
              expandedHeight: 140,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 25, bottom: 20),
                centerTitle: false,
                title: Row(
                  children: [
                    AppBackButton(),
                    const SizedBox(width: 50),
                    const Text(
                      'FAQ',
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

            /// 🔹 FAQ List Items
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildFAQItem(
                    "How do I apply to jobs on Sheqlee?",
                    "To apply for jobs on Sheqlee, simply create an account, browse job listings, and click \"Apply\" on a desired job. Follow the prompts to submit your application.",
                  ),
                  _buildFAQItem(
                    "How does Sheqlee benefit freelancers?",
                    "Sheqlee provides a streamlined platform to find high-quality local and international projects, secure payments, and build a professional portfolio.",
                  ),
                  _buildFAQItem(
                    "I am a junior developer with less than 1 year of experience. Are there jobs for me?",
                    "Yes! Many companies on Sheqlee look for junior talent. Use the 'Entry Level' filter in the categories section to find suitable matches.",
                  ),
                  _buildFAQItem(
                    "How do I update my profile?",
                    "Go to the Profile tab, click on the edit icon, and you can update your skills, bio, and resume.",
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        // This removes the default border/lines that ExpansionTile adds
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.black,
          collapsedIconColor: Colors.black54,
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.3,
            ),
          ),
          children: [
            const Divider(color: Colors.black12, height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff555555),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
