import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:sheqlee/screens/authentication/login_form.dart';
import 'package:sheqlee/screens/authentication/agreement_screen.dart';
import 'package:sheqlee/widget/app_primary_button.dart';

class IntroLoginScreen extends StatefulWidget {
  const IntroLoginScreen({super.key});

  @override
  State<IntroLoginScreen> createState() => _IntroLoginScreenState();
}

class _IntroLoginScreenState extends State<IntroLoginScreen> {
  final Color purple = const Color(0xFF9161B9);
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final FocusNode _focusNode = FocusNode();
  Timer? _timer;

  final List<_IntroData> _pagesData = const [
    _IntroData(
      image: 'assets/icons/image.svg',
      header: 'Header text',
      body: 'Body text will be written here, maybe in two lines.',
    ),
    _IntroData(
      image: 'assets/icons/image.svg',
      header: 'Header text',
      body: 'Body text will be written here, maybe in two lines.',
    ),
    _IntroData(
      image: 'assets/icons/image.svg',
      header: 'Header text',
      body: 'Body text will be written here, maybe in two lines.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _pagesData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    final bool active = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 20 : 7,
      height: 7,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: active ? purple : purple.withOpacity(index == 1 ? 0.4 : 0.2),
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  Widget _buildIntroPage(
    BuildContext context,
    _IntroData data,
    double horizontalPadding,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxH = constraints.maxHeight;
        return SingleChildScrollView(
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: maxH * 0.23),
                // Logo Centered
                Center(
                  child: SizedBox(
                    height: 190,
                    width: 190,
                    child: SvgPicture.asset(data.image),
                  ),
                ),
                SizedBox(height: maxH * 0.06),
                // Text and Dots aligned to same vertical line
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.header,
                        style: const TextStyle(
                          fontSize: 50,
                          color: Color(0xff000000),
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.bold,
                          //height:
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        data.body,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xff000000),
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // Distance between body and dots
                      Row(
                        children: List.generate(
                          _pagesData.length,
                          (i) => _buildDot(i),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double sidePadding = size.width * 0.1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top section takes available space
            Flexible(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pagesData.length,
                onPageChanged: (int page) =>
                    setState(() => _currentPage = page),
                itemBuilder: (context, index) =>
                    _buildIntroPage(context, _pagesData[index], sidePadding),
              ),
            ),
            // Bottom Buttons Section
            Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.07,
                right: size.width * 0.07,
                bottom: 35, // Remains 50 from screen bottom
              ),
              child: Column(
                children: [
                  // USE YOUR REUSABLE BUTTON HERE
                  AppPrimaryButton(
                    text: 'Log in',
                    enabled: true, // Set to true to show purple color
                    loading: false, // Set to true when performing login logic
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginFormScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20), // Exactly 30 between buttons

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AgreementScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'New to Sheqlee? Sign up!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff707070),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                      ),
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
}

class _IntroData {
  final String image;
  final String header;
  final String body;
  const _IntroData({
    required this.image,
    required this.header,
    required this.body,
  });
}
