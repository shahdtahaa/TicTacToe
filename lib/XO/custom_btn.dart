import 'package:flutter/material.dart';

class BoardBtn extends StatelessWidget {
  final String label;
  final void Function(int) onClick;
  final int index;

  const BoardBtn({
    super.key,
    required this.label,
    required this.onClick,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onClick(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: label == "X"
                    ? Colors.pink.withOpacity(0.5)
                    : label == "O"
                    ? Colors.deepPurple.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: label == "X"
                    ? Colors.pinkAccent
                    : label == "O"
                    ? Colors.deepPurple
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
