// import 'package:flutter/material.dart';
// import 'package:motivational/providers/subscription_provider.dart';
// import 'package:provider/provider.dart';

// class SS extends StatelessWidget {
//   const SS({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Listen to changes in the provider
//     final provider = Provider.of<SubscriptionProvider>(context);

//     // 1. Handle Initial Loading State
//     if (provider.isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     // 2. Handle Store Not Available State
//     if (!provider.isAvailable) {
//       return const Scaffold(
//         body: Center(child: Text('Store not available')),
//       );
//     }

//     // 3. Main Content
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: () {
//         provider.logs.clear();
//       }),
//       appBar: AppBar(title: const Text('Subscription')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (provider.products.isEmpty)
//               const Text('No products found')
//             else
//               ...provider.products.map((product) {
//                 // 🛑 Use provider.isProcessing to disable the purchase button
//                 final bool isDisabled = provider.isProcessing;

//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   child: ListTile(
//                     title: Text(product.title),
//                     subtitle: Text(product.description),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(product.price),
//                         const SizedBox(width: 8),
//                         // Show a small loader or a disabled indicator next to the price
//                       ],
//                     ),
//                     // 🛑 Prevent multiple taps by checking isProcessing
//                     onTap: isDisabled ? null : () => provider.buy(product),
//                   ),
//                 );
//               }),

//             const SizedBox(height: 30),

//             // 🛑 Use provider.isProcessing to disable the Restore button
//             ElevatedButton(
//               onPressed: provider.isProcessing
//                   ? null // Button is disabled if processing
//                   : provider.restorePurchases,
//               child: provider.isProcessing
//                   ? const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(
//                           width: 16,
//                           height: 16,
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                             strokeWidth: 2,
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Text('Processing...'),
//                       ],
//                     )
//                   : const Text('Restore Purchases'),
//             ),

//             const SizedBox(height: 20),
//             if (provider.isSubscribed)
//               const Text(
//                 '✅ You are subscribed!',
//                 style: TextStyle(fontSize: 16, color: Colors.green),
//               ),
//             const SizedBox(height: 20),

//             // 👇 Scrollable log viewer
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: SingleChildScrollView(
//                   child: SelectableText(
//                     provider.logs.isEmpty
//                         ? 'No logs yet.'
//                         : provider.logs.map((e) => e).toString(),
//                     style: const TextStyle(
//                       fontFamily: 'monospace',
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
