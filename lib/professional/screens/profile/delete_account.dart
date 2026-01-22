import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sheqlee/professional/widget/login/action_dialog.dart';
import 'package:sheqlee/professional/widget/login/app_primary_button.dart';
//import 'package:sheqlee/providers/jobs/tags_notifier.dart';
import 'package:sheqlee/professional/widget/login/backbutton.dart';
import 'package:sheqlee/professional/widget/profile/editable_text_form.dart';

class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  bool _isButtonEnabled = false;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // We use a listener to watch the controller
    _reasonController.addListener(_handleTextChange);
  }

  // Separate function to handle the logic
  void _handleTextChange() {
    setState(() {
      // This line re-evaluates the boolean and tells Flutter to redraw the button
      _isButtonEnabled = _reasonController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,

        body: SafeArea(
          child: Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  // Custom Header: Aligned vertically with the body fields
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, top: 30.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Back Button aligned 25px from left
                          const AppBackButton(),
                          const SizedBox(width: 50),
                          const Text(
                            "Delete Account",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: SingleChildScrollView(
                  // Changed to ScrollView to prevent overflow
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align fields to the left
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        'Your account will be available for recovery for a period of one month. After that, it will be permanently deleted.',
                        textAlign: TextAlign
                            .start, // Changed to start to match the left alignment
                        style: TextStyle(
                          fontFamily: 'pretendard',
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomProfileField(
                        label: "Deletion reason",
                        controller: _reasonController,
                        hint: "Tell us why you’re deleting your account",
                        maxLines: 4,
                        maxLength: 256,
                        onChanged: (value) {
                          setState(() {
                            _isButtonEnabled = value.trim().isNotEmpty;
                          });
                        },
                      ),
                      // Add extra padding at bottom so button doesn't cover text
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Bottom Button (remains exactly as your design)
              Positioned(
                left: 25,
                right: 25,
                bottom: 20,
                child: AppPrimaryButton(
                  text: "Delete Account",
                  enabled: _isButtonEnabled,
                  backgroundColor: const Color(0xffEA4335),
                  loading: false,
                  onPressed: () => _showDeleteConfirmation(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showAppDialog(
      context: context,
      title: "Delete Account",
      // THE CENTERED TEXT LOGIC
      message: "Are you sure you want to \ndelete your account?",
      actionText: "Delete",
      actionColor: const Color(0xffEA4335),
      onConfirm: () {
        // Handle Backend Call
        print("Deleting: ${_reasonController.text}");
      },
    );
  }
}
