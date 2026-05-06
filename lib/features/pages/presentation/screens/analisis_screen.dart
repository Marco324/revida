import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:revida/features/pages/presentation/cubits/image_db_revida/image_db_revida_cubit.dart';
import 'package:revida/features/pages/presentation/cubits/analisis/analisis_cubit.dart';
import 'package:revida/features/pages/presentation/cubits/analisis/analisis_state.dart';

class AnalisisScreen extends StatelessWidget {
  static String name = 'analisis';
  final String imagePath;

  const AnalisisScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnalisisCubit(),
      child: _AnalisisBody(imagePath: imagePath),
    );
  }
}

class _AnalisisBody extends StatefulWidget {
  const _AnalisisBody({required this.imagePath});
  final String imagePath;

  @override
  State<_AnalisisBody> createState() => _AnalisisBodyState();
}

class _AnalisisBodyState extends State<_AnalisisBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalisisCubit>().analizarResiduo(widget.imagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Análisis IA',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AnalisisCubit, AnalisisState>(
        builder: (context, state) {
          if (state is AnalisisLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF10B981)),
                  SizedBox(height: 16),
                  Text(
                    'Analizando residuo...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state is AnalisisSuccess) {
            return _AnalisisSuccessBody(
              imagePath: widget.imagePath,
              state: state,
            );
          }

          if (state is AnalisisError) {
            return Center(
              child: Text(
                state.mensaje,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AnalisisSuccessBody extends StatelessWidget {
  const _AnalisisSuccessBody({required this.imagePath, required this.state});

  final String imagePath;
  final AnalisisSuccess state;

  Color _getColorForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('plástico') || cat.contains('plastico')) {
      return Colors.blue;
    }
    if (cat.contains('papel') ||
        cat.contains('cartón') ||
        cat.contains('carton')) {
      return const Color(0xFF8D6E63);
    }
    if (cat.contains('metal') || cat.contains('aluminio')) {
      return Colors.grey.shade600;
    }
    if (cat.contains('orgánico') || cat.contains('organico')) {
      return Colors.green;
    }
    return const Color(0xFF10B981);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final categoryColor = _getColorForCategory(state.categoriaResiduo);
    final String confianzaStr = (state.confianza * 100).toStringAsFixed(1);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 360,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(File(imagePath), fit: BoxFit.fitHeight),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.categoriaResiduo.toUpperCase(),
                      style: textTheme.headlineMedium!.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Precisión del modelo: $confianzaStr%',
                    style: textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: categoryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: categoryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Recuerda depositar este residuo en su contenedor correspondiente antes de registrarlo.',
                      style: textTheme.bodySmall!.copyWith(
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.read<ImageDbRevidaCubit>().registrarDeteccion(
                    pathImagen: imagePath,
                    categoria: state.categoriaResiduo,
                    confianza: state.confianza,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reciclaje registrado correctamente'),
                      ),
                    );
                  }

                  if(!context.mounted) return;
                  context.push('/');
                },
                icon: const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 28,
                  color: Colors.white,
                ),
                label: Text(
                  '¡Registrar Reciclaje!',
                  style: textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  shadowColor: const Color(0xFF10B981).withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Escanear de nuevo',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
