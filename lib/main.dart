import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // ← AGREGADO

// ============================================================
// PARTE 1: PUNTO DE ENTRADA DE LA APLICACIÓN
// ============================================================
void main() {
  runApp(const MyApp());
}

// ============================================================
// PARTE 2: CONFIGURACIÓN PRINCIPAL DE LA APP
// ============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biomasa Camarón',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FC3F7),
          primary: const Color(0xFF4FC3F7),
          secondary: const Color(0xFF81D4FA),
          surface: Colors.white,
          background: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const DataScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ============================================================
// PARTE 3: PANTALLA DE DATOS DE BIOMASA
// ============================================================
class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

// ============================================================
// PARTE 3.1: ESTADO DE LA PANTALLA DE DATOS
// ============================================================
class _DataScreenState extends State<DataScreen> {
  // --- CONTROLADORES DE TEXTO ---
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _lancesController = TextEditingController();
  final TextEditingController _atarrayaController = TextEditingController();
  final TextEditingController _hectareaController = TextEditingController();
  final TextEditingController _gramajeController = TextEditingController();

  // --- COLORES PERSONALIZADOS ---
  final Color softBlue = const Color(0xFF4FC3F7);
  final Color softBlueLight = const Color(0xFF81D4FA);
  final Color softBlueBg = const Color(0xFFE1F5FE);
  
  // --- VARIABLES DE RESULTADOS ---
  double _resultadoDivision = 0;
  double _hectareasConvertidas = 0;
  double _biomasaTotal = 0;
  double _gramajeTotal = 0;
  bool _mostrarResultados = false;
  
  double _resultadoAtarraya = 0;
  double _totalCamarones = 0;
  double _totalLibras = 0;
  double _totalKilos = 0;
  double _totalQuintales = 0;

  // --- COLOR ADICIONAL ---
  final Color softOrange = const Color(0xFFFFB74D);

  // ============================================================
  // PARTE 3.2: FUNCIÓN PARA CALCULAR
  // ============================================================
  void _calcular() {
    double cantidad = double.tryParse(_cantidadController.text) ?? 0;
    double lances = double.tryParse(_lancesController.text) ?? 0;
    double atarraya = double.tryParse(_atarrayaController.text) ?? 0;
    double hectareas = double.tryParse(_hectareaController.text) ?? 0;
    double gramaje = double.tryParse(_gramajeController.text) ?? 0;

    if (cantidad > 0 && lances > 0 && atarraya > 0 && hectareas > 0 && gramaje > 0) {
      _resultadoDivision = cantidad / lances;
      _resultadoAtarraya = _resultadoDivision / atarraya;
      _hectareasConvertidas = hectareas * 10000;
      _totalCamarones = _resultadoAtarraya * _hectareasConvertidas;
      _gramajeTotal = _totalCamarones * gramaje;
      _totalLibras = _gramajeTotal / 454;
      _totalKilos = _totalLibras / 2.20462;
      _totalQuintales = _totalKilos / 45.3592;

      setState(() {
        _mostrarResultados = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Todos los campos deben ser mayores a 0'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() {
        _mostrarResultados = false;
      });
    }
  }

  // ============================================================
  // PARTE 3.3: FUNCIÓN PARA LIMPIAR CAMPOS
  // ============================================================
  void _limpiarCampos() {
    setState(() {
      _cantidadController.clear();
      _lancesController.clear();
      _atarrayaController.clear();
      _hectareaController.clear();
      _gramajeController.clear();
      _mostrarResultados = false;
      _resultadoDivision = 0;
      _resultadoAtarraya = 0;
      _hectareasConvertidas = 0;
      _gramajeTotal = 0;
      _totalCamarones = 0;
      _totalLibras = 0;
      _totalKilos = 0;
      _totalQuintales = 0;
    });
  }

  // ============================================================
  // FUNCIÓN PARA FORMATEAR NÚMEROS
  // ============================================================
  String _formatearNumero(double numero) {
    NumberFormat formatter = NumberFormat('#,###');
    return formatter.format(numero);
  }

  // ============================================================
  // FUNCIÓN PARA CONSTRUIR UNIDADES DE RESULTADO
  // ============================================================
  Widget _buildResultadoUnidad(String titulo, String valor, String unidad) {
    return Column(
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$valor $unidad',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PARTE 3.4: CONSTRUCCIÓN DE LA INTERFAZ
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.set_meal, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Biocam',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: softBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SALUDO ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [softBlue, softBlueLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.waving_hand, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Bienvenido!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- TÍTULO DE LA SECCIÓN ---
            const Text(
              '🦐 Calculadora de Biomasa',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Completa los campos para calcular la biomasa',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 25),

            // --- CAMPOS ---
            _buildDataField(
              controller: _cantidadController,
              label: 'Cantidad de camarón',
              hint: 'Ej: 150',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            _buildDataField(
              controller: _lancesController,
              label: 'Lances',
              hint: 'Ej: 5',
              icon: Icons.trending_up,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            _buildDataField(
              controller: _atarrayaController,
              label: 'Tamaño de atarraya (m)',
              hint: 'Ej: 5',
              icon: Icons.straighten,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),

            _buildDataField(
              controller: _hectareaController,
              label: 'Hectárea de camaronera (ha)',
              hint: 'Ej: 7',
              icon: Icons.square_foot,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),

            _buildDataField(
              controller: _gramajeController,
              label: 'Gramaje del camarón (g)',
              hint: 'Ej: 15',
              icon: Icons.monitor_weight,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 25),

            // --- BOTONES ---
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _calcular,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: softBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                        shadowColor: softBlue.withValues(alpha: 0.3),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calculate, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Calcular',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _limpiarCampos,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: softBlue, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        foregroundColor: softBlue,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.clear, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Limpiar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ============================================================
            // CUADRO DE RESULTADOS
            // ============================================================
            if (_mostrarResultados)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [softBlueBg, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: softBlue.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: softBlue.withValues(alpha: 0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: softBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calculate,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '📈 Resultado del Cálculo',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                     
                    //--------------------------------------------------------
                    // PASO 1
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: softOrange.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_cantidadController.text} ÷ ${_lancesController.text}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const Text(
                                'Camarones por lance',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: softOrange.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '= ${_resultadoDivision.round()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFB74D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    //--------------------------------------------------------
                    // PASO 2
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: softBlue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_resultadoDivision.round()} ÷ ${_atarrayaController.text}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const Text(
                                'Camarones por metro cuadrado',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: softBlue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '= ${_resultadoAtarraya.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4FC3F7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    //--------------------------------------------------------
                    // PASO 3
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_resultadoAtarraya.toStringAsFixed(2)} × ${_hectareaController.text}0000',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const Text(
                                'Total de camarones',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '= ${_formatearNumero(_totalCamarones)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    //--------------------------------------------------------
                    // PASO 4: BIOMASA TOTAL
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [softBlue, softBlueLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: softBlue.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.waves,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'BIOMASA TOTAL:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${_formatearNumero(_totalCamarones)} × ${_gramajeController.text}g ÷ 454',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const Divider(color: Colors.white30, height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildResultadoUnidad(
                                'LIBRAS',
                                _totalLibras.toStringAsFixed(2),
                                'lb',
                              ),
                              _buildResultadoUnidad(
                                'KILOS',
                                _totalKilos.toStringAsFixed(2),
                                'kg',
                              ),
                              _buildResultadoUnidad(
                                'QUINTALES',
                                _totalQuintales.toStringAsFixed(2),
                                'qq',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PARTE 3.5: FUNCIÓN PARA CONSTRUIR CAMPOS DE TEXTO
  // ============================================================
  Widget _buildDataField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: softBlueBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: softBlue),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: const TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
      ),
    );
  }
}