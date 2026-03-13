import 'package:flutter/material.dart';
import 'payment_service.dart';
import 'package:google_fonts/google_fonts.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({super.key});
  @override
  State<Subscribe> createState() => SubscribeState();
}

class SubscribeState extends State<Subscribe> {
  PaymentService servizioPagamenti = PaymentService();
  @override
  void initState() {
    super.initState();
    inizializzaPagamenti();
    setState(() {});
  }

  Future<void> inizializzaPagamenti() async {
    await servizioPagamenti.inizializza();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (servizioPagamenti.disponibile) {
      return Scaffold(
        appBar: AppBar(title: const Text("Abbonati")),
        body: Center(
          child: servizioPagamenti.prodotti.isEmpty
              ? const CircularProgressIndicator()
              : Padding(
                  padding: EdgeInsets.all(30),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF667eea), // Viola
                          Color(0xFF64B5F6), // Blu
                          Color(0xFF4DD0E1), // Ciano
                          Color(0xFFBA68C8), // Rosa-viola
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E), // Grigio scuro elegante
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 25, top: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                        "assets/icon/logo.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "River Notes",
                                      style: GoogleFonts.merriweather(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25),
                            child: Transform.translate(
                              offset: Offset(0, -10),
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Color(0xFF667eea), // Viola
                                    Color(0xFF64B5F6), // Blu
                                    Color(0xFF4DD0E1), // Ciano
                                    Color(0xFFBA68C8), // Arancione
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Text(
                                  "Standard",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        offset: Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25, right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Trasforma le tue idee in appunti perfetti",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.95),
                                    height: 1.3,
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Feature 1
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.mic_rounded,
                                      color: Color(0xFF4DD0E1),
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "180 minuti al mese",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Registra lezioni, meeting e idee senza limiti",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white.withValues(
                                                alpha: 0.65,
                                              ),
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12),

                                // Feature 2
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      color: Color(0xFFBA68C8),
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Whisper + GPT-4o mini",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Trascrizione accurata ed elaborazione intelligente",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white.withValues(
                                                alpha: 0.65,
                                              ),
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12),

                                // Feature 3
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.headphones,
                                      color: Color(0xFF64B5F6),
                                      size: 20,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Audio sempre disponibile",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Riascolta quando vuoi, i tuoi file restano con te",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white.withValues(
                                                alpha: 0.65,
                                              ),
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                              bottom: 25,
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF667eea),
                                    Color(0xFF64B5F6),
                                    Color(0xFF4DD0E1),
                                    Color(0xFFBA68C8),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      0xFF667eea,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () async {
                                    await servizioPagamenti.compra(
                                      servizioPagamenti.prodotti.first,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.rocket_launch_rounded,
                                          color: Colors.white,
                                          size: 24,
                                        ),

                                        SizedBox(width: 12),
                                        Text(
                                          "Inizia Ora",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      );
    } else {
      return Scaffold();
    }
  }
}
