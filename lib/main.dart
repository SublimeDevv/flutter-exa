import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ULTRAMAR AFORO CONTROL APP - sublime',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const AforoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AforoScreen extends StatefulWidget {
  const AforoScreen({super.key});

  @override
  State<AforoScreen> createState() => _AforoScreenState();
}

class _AforoScreenState extends State<AforoScreen> {
  final TextEditingController _capacidadController = TextEditingController();
  final FocusNode _capacidadFocus = FocusNode();
  final PageController _pageController = PageController();
  
  int _capacidadMaxClientes = 50;
  int _aforoValorActual = 0;
  List<String> _historial = [];
  int _paginaActual = 0;

  final List<String> _imagenesCarrusel = ['https://www.civitatis.com/f/mexico/playa-del-carmen/ferry-cozumel-589x392.jpg','https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800','https://static.wixstatic.com/media/82fb61_75a9387813f44b34b5dafd1e12958611~mv2.jpg/v1/fill/w_1200,h_674,al_c/82fb61_75a9387813f44b34b5dafd1e12958611~mv2.jpg',];

  @override
  void dispose() {
    _capacidadController.dispose();
    _capacidadFocus.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _aplicarCapacidad() {
    final valor = int.tryParse(_capacidadController.text);
    if (valor != null && valor > 0) {
      setState(() {
        _capacidadMaxClientes = valor;
        _aforoValorActual = 0;
        _historial.clear();
        _historial.add('Capacidad establecida: $_capacidadMaxClientes');
      });
      _capacidadFocus.unfocus();
      _mostrarMensaje('Capacidad establecida: $_capacidadMaxClientes');
    } else {
      _mostrarMensaje('Ingrese un número válido');
    }
  }

  void _editAforo(int valorNuevo) {
    setState(() {
      int nuevoValorAforo = _aforoValorActual + valorNuevo;

      if ([1, 2, 3, 4].contains(_aforoValorActual) && valorNuevo == -5) {
        _mostrarMensaje('No puedes reducir el aforo por debajo de 0');
        return;
      }      

      if (_aforoValorActual == 1 && valorNuevo == -5) {
        _mostrarMensaje('No puedes reducir el aforo por debajo de 0');
        return;
      }

      if (_aforoValorActual == 3 && valorNuevo == -5) {
        _mostrarMensaje('No puedes reducir el aforo por debajo de 0');
        return;
      }

      if (_aforoValorActual == 4 && valorNuevo == -5) {
        _mostrarMensaje('No puedes reducir el aforo por debajo de 0');
        return;
      }


      if (nuevoValorAforo < 0) {
        nuevoValorAforo = 0;
        _mostrarMensaje('El aforo no puede ser un número menor a 0');
      } else if (nuevoValorAforo > _capacidadMaxClientes) {
        nuevoValorAforo = _capacidadMaxClientes;
        _mostrarMensaje('Capacidad máxima de clientes alcanzada');
      }
      
      if (nuevoValorAforo != _aforoValorActual) {
        String accion = valorNuevo > 0 ? '¡Entraron $valorNuevo nuevos turistas!' : 'Salieron ${valorNuevo.abs()} turistas';
        _aforoValorActual = nuevoValorAforo;
        _historial.insert(0, '$accion → Aforo: $_aforoValorActual/$_capacidadMaxClientes');
      }
    });
  }

  void _reiniciar() {
    setState(() {
      _aforoValorActual = 0;
      _historial.insert(0, 'Valor establecido en 0/$_capacidadMaxClientes');
    });
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _desplegarHistorial() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'HISTORIAL',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        color: Color(0xFF757575),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _historial.isEmpty
                    ? Center(
                        child: Text(
                          'Sin registros en el historial',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      )

                      // LISTA DE COTEJO LIST VIEW HISTORIAL
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        itemCount: _historial.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              _historial[index],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF424242),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _obtenerPorcentajeAforoActual() {
    if (_capacidadMaxClientes == 0) return 0;
    return _aforoValorActual / _capacidadMaxClientes;
  }

  Color _obtColorEstado() {
    double porcentaje = _obtenerPorcentajeAforoActual();
    if (porcentaje < 0.60) return const Color(0xFFFFC107);
    if (porcentaje < 0.90) return const Color(0xFFFF6F00);
    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'SUBLIME FERRY',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: _desplegarHistorial,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9C4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.history,
                        color: Color(0xFFF57F17),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ESTO ES PARA EL CARRSUEL DE IMAGENES PAI
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 180,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) {
                                setState(() {
                                  _paginaActual = index;
                                });
                              },
                              itemCount: _imagenesCarrusel.length,
                              itemBuilder: (context, index) {
                                // LISTA DE COTEJO IMAGE .NETWORK
                                return Image.network(
                                  _imagenesCarrusel[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xFFFFC107),
                                            const Color(0xFFFFB300),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.directions_boat_rounded,
                                          size: 80,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        // PAGINAS CHECKS
                        Positioned(
                          bottom: 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _imagenesCarrusel.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _paginaActual == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _paginaActual == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // PABEL DE CONFIG PARA CAPACIDAD
                    const Text(
                      'Panel de configuración',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: TextField(
                              controller: _capacidadController,
                              focusNode: _capacidadFocus,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Cantidad clientes max',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: _aplicarCapacidad,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF212121),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Establecer max',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 200,
                                child: CircularProgressIndicator(
                                  value: _obtenerPorcentajeAforoActual(),
                                  strokeWidth: 12,
                                  backgroundColor: const Color(0xFFF5F5F5),
                                  valueColor: AlwaysStoppedAnimation<Color>(_obtColorEstado()),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$_aforoValorActual',
                                    style: const TextStyle(
                                      fontSize: 72,
                                      fontWeight: FontWeight.w200,
                                      height: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'de $_capacidadMaxClientes',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF9E9E9E),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: _obtColorEstado().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${(_obtenerPorcentajeAforoActual() * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: _obtColorEstado(),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Controles
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildControlButton('+1', () => _editAforo(1), const Color(0xFFFFC107)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildControlButton('+2', () => _editAforo(2), const Color(0xFFFFC107)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildControlButton('+5', () => _editAforo(5), const Color(0xFFFFC107)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildControlButton('-1', () => _editAforo(-1), const Color(0xFFFF6F00)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildControlButton('-5', () => _editAforo(-5), const Color(0xFFFF6F00)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildControlButton('Reiniciar', _reiniciar, const Color(0xFF757575)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(String label, VoidCallback onTap, Color color) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}