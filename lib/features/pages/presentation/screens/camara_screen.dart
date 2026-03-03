import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CamaraScreen extends StatelessWidget {
  static String name = 'camara';
  const CamaraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CamaraBody();
  }
}

class _CamaraBody extends StatefulWidget {
  const _CamaraBody();

  @override
  State<_CamaraBody> createState() => _CamaraBodyState();
}

class _CamaraBodyState extends State<_CamaraBody> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowInstructions();
    });
  }

  Future<void> _checkAndShowInstructions({bool forceShow = false}) async {
    final prefs = await SharedPreferences.getInstance();
    // Revisa si ya vio las instrucciones (si es null, es la primera vez)
    final hasSeenInstructions = prefs.getBool('hasSeenCameraInstructions') ?? false;

    // Si ya las vio y no estamos forzando a mostrarlas, salimos
    if (hasSeenInstructions && !forceShow) return;

    if (!mounted) return;

    // Mostramos el diálogo bonito
    await showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.document_scanner_rounded, color: Color(0xFF10B981), size: 48),
              const SizedBox(height: 16),
              Text(
                '¿Cómo escanear correctamente?',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B5E20),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                '• Coloca un solo residuo a la vez dentro del marco.\n\n'
                '• Asegúrate de que el objeto se vea por completo.\n\n'
                '• Busca buena iluminación para que la IA lo reconozca mejor.\n\n'
                '• Presiona el botón verde para capturar y analizar.',
                style: TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('¡Entendido!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Guardamos en memoria que ya las vio para que no vuelva a salir
    await prefs.setBool('hasSeenCameraInstructions', true);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final camera = controller;

    if (camera == null || !camera.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF10B981)),
      );
    }

    return Scaffold(
       extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white, size: 32),
      actions: [
        Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.help_outline_rounded, 
                  color: Colors.white, 
                  size: 26,
                ),
                onPressed: () => _checkAndShowInstructions(forceShow: true),
              ),
            ),
          ),
      ],
      ),
      body: Stack(
        children: [
          // 2. Cámara ocupando todo el fondo
          Positioned.fill(child: CameraPreview(camera)),
      
          // 3. Marco de escaneo estilo Inteligencia Artificial
          Positioned.fill(
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 140.0, // Espacio para librar el AppBar
                  bottom:
                      180.0, // Espacio extra para librar tus controles flotantes
                  left: 40.0,
                  right: 40.0,
                ),
                child: CustomPaint(painter: _ScannerOverlayPainter()),
              ),
            ),
          ),
      
          // 4. Panel de controles flotante en la parte inferior
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _BottomControls(controller: camera),
          ),
        ],
      ),
    );
  }
}

// Widget separado para los controles inferiores
class _BottomControls extends StatefulWidget {
  final CameraController controller;
  const _BottomControls({required this.controller});

  @override
  State<_BottomControls> createState() => _BottomControlsState();
}

class _BottomControlsState extends State<_BottomControls> {
  bool isPressed = false;
  bool flash = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco limpio
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.15,
            ), // Sombra un poco más marcada por flotar sobre la cámara
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Botón central de captura
          GestureDetector(
            onTapDown: (_) => setState(() => isPressed = true),
            onTapUp: (_) => setState(() => isPressed = false),
            onTapCancel: () => setState(() => isPressed = false),
            onTap: () async {
              if (!widget.controller.value.isInitialized) return;
              final XFile file = await widget.controller.takePicture();
              if (!context.mounted) return;
              context.push('/analisis', extra: file.path);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: isPressed ? 70 : 76,
              height: isPressed ? 70 : 76,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981), // Verde Esmeralda
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.4),
                    blurRadius: isPressed ? 5 : 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.recycling_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),

          // Botón de Flash alineado a la derecha
          Positioned(
            right: 20,
            child: IconButton(
              onPressed: () async {
                setState(() => flash = !flash);
                await widget.controller.setFlashMode(
                  flash ? FlashMode.torch : FlashMode.off,
                );
              },
              icon: Icon(
                flash ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                size: 32,
                color: flash ? const Color(0xFFFF9800) : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter personalizado para dibujar las esquinas del escáner
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 40.0;

    // Arriba Izquierda
    canvas.drawLine(const Offset(0, cornerLength), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);

    // Arriba Derecha
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    // Abajo Izquierda
    canvas.drawLine(
      Offset(0, size.height - cornerLength),
      Offset(0, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );

    // Abajo Derecha
    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - cornerLength, size.height),
      Offset(size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
