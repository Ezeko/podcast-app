import 'package:flutter/material.dart';

class AvatarSelector extends StatelessWidget {
  final String avatarId;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;
  
  const AvatarSelector({
    super.key,
    required this.avatarId,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFB4E7CE), Color(0xFF9BCDFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: isSelected ? Border.all(
            color: Colors.white,
            width: 4,
          ) : null,
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ] : [],
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 40),
          ),
        ),
      ),
    );
  }
}

