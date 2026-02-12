// import 'package:flutter/material.dart';
// import 'package:motivational/utils/images.dart';

// class IconWrapperBody extends StatelessWidget {
//   final Widget body;
//   const IconWrapperBody({super.key, required this.body});

//   @override
//   Widget build(BuildContext context) {
//     final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
//     return Stack(
//       children: [
//         /// main screen body
//         body,

//         /// fixed bottom-left icon
//         if (!isKeyboardVisible)
//           Positioned(
//             bottom: 10,
//             left: 20,
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 200),
//               opacity: isKeyboardVisible ? 0.0 : 1.0,
//               child: SafeArea(
//                   child: Image.asset(
//                 Images.icon,
//                 color: const Color(0XFF041020),
//                 width: 40,
//                 height: 50,
//                 fit: BoxFit.cover,
//               )),
//             ),
//           ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:motivational/utils/images.dart';

class IconWrapperBody extends StatefulWidget {
  final Widget body;
  const IconWrapperBody({super.key, required this.body});

  @override
  State<IconWrapperBody> createState() => _IconWrapperBodyState();
}

class _IconWrapperBodyState extends State<IconWrapperBody>
    with WidgetsBindingObserver {
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize current keyboard state
    _keyboardVisible = WidgetsBinding.instance.window.viewInsets.bottom > 0;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisible = bottomInset > 0;
    if (isVisible != _keyboardVisible) {
      setState(() {
        _keyboardVisible = isVisible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.body,
        Positioned(
          bottom: 10,
          left: 20,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _keyboardVisible ? 0 : 1,
            child: SafeArea(
              child: Image.asset(
                Images.icon,
                color: const Color(0XFF041020),
                width: 40,
                height: 50,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
