// import 'package:flutter/material.dart';
// import 'package:note_tracking_app/Core/Provider/Note%20Provider/note_provider.dart';
// import 'package:provider/provider.dart';

// class StyleColor extends StatefulWidget {
//   final Color color;
//   const StyleColor({super.key, required this.color});

//   @override
//   State<StyleColor> createState() => _StyleColorState();
// }

// class _StyleColorState extends State<StyleColor> {
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<NoteProvider>(context);

//     return GestureDetector(
//       onTap: () {
//         provider.changeColor(widget.color);
//       },
//       child: Container(
//         height: 34,
//         width: 34,
//         decoration: BoxDecoration(
//           color: widget.color,
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
// }