// JUEGO PING PONG - MAIN
// Demuestra polimorfismo y encapsulación con clases GameObject, Paddle y Ball

// Variables globales del juego
Paddle jugador, ia1, ia2;
Ball pelota;
int puntajeJugador = 0;
int puntajeIA1 = 0;
int puntajeIA2 = 0;
int tiempoEspera = 0;
boolean juegoIniciado = false;

// Configuración inicial del juego
void setup() {
  size(800, 600);
  inicializarJuego();
}

// Bucle principal del juego
void draw() {
  dibujarFondo();
  
  if (!juegoIniciado) {
    mostrarPantallaInicio();
    return;
  }
  
  // Actualizar objetos del juego (polimorfismo en acción)
  actualizarJuego();
  
  // Dibujar objetos del juego
  dibujarJuego();
  
  // Mostrar interfaz de usuario
  mostrarUI();
  
  // Verificar condición de victoria
  verificarVictoria();
}

// Método privado para inicializar el juego
void inicializarJuego() {
  // Crear paddle del jugador (izquierda)
  jugador = new Paddle(30, height/2 - 60, 15, 120, color(100, 150, 255), 8, true);
  
  // Crear primer enemigo IA (derecha superior)
  ia1 = new Paddle(width - 45, height/4 - 60, 15, 120, color(255, 100, 100), 6, false);
  
  // Crear segundo enemigo IA (derecha inferior)
  ia2 = new Paddle(width - 45, 3*height/4 - 60, 15, 120, color(255, 150, 100), 5, false);
  
  // Crear pelota
  pelota = new Ball(width/2, height/2, 20, color(255, 255, 100), 5);
}

// Método para actualizar todos los objetos del juego
void actualizarJuego() {
  // Verificar si hay tiempo de espera después de un gol
  if (millis() < tiempoEspera) {
    return;
  }
  
  if (!pelota.isEnJuego() && millis() >= tiempoEspera) {
    pelota.setEnJuego(true);
  }
  
  // Actualizar objetos usando polimorfismo
  // Cada objeto implementa su propio método actualizar()
  jugador.actualizar();
  ia1.actualizar();
  ia2.actualizar();
  pelota.actualizar();
}

// Método para dibujar todos los objetos del juego
void dibujarJuego() {
  // Dibujar objetos usando polimorfismo
  // Cada objeto puede tener su propia implementación de dibujar()
  jugador.dibujar();
  ia1.dibujar();
  ia2.dibujar();
  pelota.dibujar();
  
  // Dibujar línea central
  dibujarLineaCentral();
}

// Método privado para dibujar el fondo
void dibujarFondo() {
  // Fondo degradado
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(color(10, 20, 40), color(20, 40, 80), inter);
    stroke(c);
    line(0, i, width, i);
  }
}

// Método privado para dibujar la línea central
void dibujarLineaCentral() {
  stroke(255, 100);
  strokeWeight(3);
  
  // Línea punteada
  for (int y = 0; y < height; y += 20) {
    line(width/2, y, width/2, y + 10);
  }
  
  noStroke();
}

// Método para mostrar la interfaz de usuario
void mostrarUI() {
  // Configurar texto
  textAlign(CENTER);
  textSize(48);
  fill(255, 200);
  
  // Mostrar puntajes
  text(puntajeJugador, width/4, 80);
  text(puntajeIA1, 3*width/4, 60);
  text(puntajeIA2, 3*width/4, 100);
  
  // Mostrar controles
  textSize(16);
  textAlign(LEFT);
  fill(255, 150);
  text("Controles:", 20, height - 60);
  text("W - Arriba", 20, height - 40);
  text("S - Abajo", 20, height - 20);
  
  // Mostrar información de la pelota
  textAlign(RIGHT);
  text("Rebotes: " + pelota.getRebotes(), width - 20, height - 40);
  text("Velocidad: " + nf(abs(pelota.getVelocidadX()) + abs(pelota.getVelocidadY()), 1, 1), width - 20, height - 20);
}

// Método para mostrar la pantalla de inicio
void mostrarPantallaInicio() {
  textAlign(CENTER);
  textSize(64);
  fill(255, 200);
  text("PING PONG", width/2, height/2 - 50);
  
  textSize(24);
  fill(255, 150);
  text("Presiona ESPACIO para comenzar", width/2, height/2 + 20);
  
  textSize(16);
  text("Usa W y S para mover tu paddle", width/2, height/2 + 60);
}

// Método para verificar condición de victoria
void verificarVictoria() {
  int puntajeMaximo = 15; // Aumentamos el puntaje máximo por la dificultad
  
  if (puntajeJugador >= puntajeMaximo || puntajeIA1 >= puntajeMaximo || puntajeIA2 >= puntajeMaximo) {
    textAlign(CENTER);
    textSize(48);
    fill(255, 255, 0);
    
    String ganador;
    if (puntajeJugador >= puntajeMaximo) {
      ganador = "¡JUGADOR GANA!";
    } else if (puntajeIA1 >= puntajeMaximo) {
      ganador = "¡IA1 GANA!";
    } else {
      ganador = "¡IA2 GANA!";
    }
    
    text(ganador, width/2, height/2);
    
    textSize(20);
    fill(255, 150);
    text("Presiona R para reiniciar", width/2, height/2 + 40);
  }
}

// Manejo de eventos de teclado
void keyPressed() {
  if (!juegoIniciado && key == ' ') {
    juegoIniciado = true;
    pelota.reiniciarPelota();
  }
  
  if (key == 'r' || key == 'R') {
    reiniciarJuego();
  }
}

// Método para reiniciar el juego
void reiniciarJuego() {
  puntajeJugador = 0;
  puntajeIA1 = 0;
  puntajeIA2 = 0;
  juegoIniciado = true;
  pelota.reiniciarPelota();
  tiempoEspera = 0;
}
