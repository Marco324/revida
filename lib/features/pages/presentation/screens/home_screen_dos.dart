import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  static String name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.person, color: Color(0xFF10B981)),
              ),
            ),
          ),
        ],
      ),
      body: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: const [
            _RachaWidget(),
            SizedBox(height: 16),
            _MisResiduosButton(),
            SizedBox(height: 16),
            _TotalRecicYUltRecicl(),
            Spacer(),
            _EscanearButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TotalRecicYUltRecicl extends StatelessWidget {
  const _TotalRecicYUltRecicl();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const verdeOscuro = Color(0xFF1B5E20);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFFE8F5E9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Residuos\nReciclados',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: verdeOscuro,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '100',
                      style: textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: verdeOscuro,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: const Color(0xFFE8F5E9), // Fondo menta suave
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Último\nReciclado',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: verdeOscuro,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Papel',
                          style: textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: verdeOscuro,
                          ),
                        ),
                        Text(
                          '24/02/25',
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RachaWidget extends StatelessWidget {
  const _RachaWidget();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      width: double.infinity,
      height: 130,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Racha Reciclando',
            style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA), // Gris muy claro adentro
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    '0 días',
                    style: textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    size: 40,
                    color: Color(0xFFFF9800), // Naranja vibrante
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EscanearButton extends StatelessWidget {
  const _EscanearButton();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => context.push('/camara'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981), // Verde Esmeralda (Acción Principal)
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFF10B981,
              ).withValues(alpha: 0.3), // Sombra del color del botón
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              'Escanear',
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 40, 
            ),
          ],
        ),
      ),
    );
  }
}

class _MisResiduosButton extends StatelessWidget {
  const _MisResiduosButton();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => print('Mis residuos'),
      child: Container(
        height: 280,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Mis Residuos',
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios_rounded),
                  iconSize: 20,
                  color: Colors.grey,
                  onPressed: () => context.push('/stats'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _Residuo(
                    nomResiduo: 'Plástico',
                    numResiduo: 5,
                    totalMeta: 100,
                    color: Colors.blue,
                  ),
                  _Residuo(
                    nomResiduo: 'Papel/Cartón',
                    numResiduo: 25,
                    totalMeta: 100,
                    color: Color(0xFF8D6E63), // Café más suave
                  ),
                  _Residuo(
                    nomResiduo: 'Metal',
                    numResiduo: 0,
                    totalMeta: 100,
                    color: Colors.grey,
                  ),
                  _Residuo(
                    nomResiduo: 'Orgánico',
                    numResiduo: 60,
                    totalMeta: 100,
                    color: Colors.green,
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

class _Residuo extends StatelessWidget {
  const _Residuo({
    required this.nomResiduo,
    required this.numResiduo,
    required this.totalMeta,
    required this.color,
  });

  final String nomResiduo;
  final Color color;
  final int numResiduo;
  final int totalMeta; // Útil para la barra de progreso

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    double progress = (totalMeta == 0) ? 0 : numResiduo / totalMeta;

    return Row(
      children: [
        Icon(Icons.recycling_rounded, color: color, size: 24),
        const SizedBox(width: 12),
        SizedBox(
          width: 100, // Ancho fijo para alinear las barras
          child: Text(
            nomResiduo,
            style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // Por si el texto es muy largo
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: color.withValues(
                alpha: 0.15,
              ), // Fondo de la barra suave
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 30, // Fijo para que los números queden alineados a la derecha
          child: Text(
            numResiduo.toString(),
            textAlign: TextAlign.right,
            style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
