import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String? imageAsset;
  final void Function()? onTap;
  final String text;

  const MyButton({super.key, this.onTap, required this.text, this.imageAsset});

  @override
  Widget build(BuildContext context) {
    // Lógica para detectar si es el botón principal o el de Google
    final bool isPrimary = imageAsset == null || imageAsset!.isEmpty;
    final Color bgColor = isPrimary ? const Color(0xFF10B981) : Colors.white;
    final Color textColor = isPrimary ? Colors.white : Colors.grey.shade800;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16), // Curva más suave
        // Borde solo si es el botón secundario (blanco)
        border: isPrimary ? null : Border.all(color: Colors.grey.shade300), 
        boxShadow: [
          if (isPrimary)
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.3), // Sombra verde
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05), // Sombra neutra
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isPrimary) ...[
                  Image.asset(imageAsset!, height: 24),
                  const SizedBox(width: 10),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold, // Un poco más de peso visual
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}