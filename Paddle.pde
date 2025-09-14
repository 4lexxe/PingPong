// Clase Paddle que hereda de GameObject
class Paddle extends GameObject {
  // Atributos privados específicos del paddle
  private float velocidad;
  private boolean esJugador; // true para jugador, false para IA
  private float limiteArriba, limiteAbajo;
  private int tipoIA; // 1 = IA agresiva hacia arriba, 2 = IA defensiva hacia abajo
  private float tiempoMovimiento; // Para patrones de movimiento
  private float direccionPreferida; // -1 = prefiere arriba, 1 = prefiere abajo
  
  // Constructor
  public Paddle(float x, float y, float ancho, float alto, color colorPaddle, float velocidad, boolean esJugador) {
    super(x, y, ancho, alto, colorPaddle);
    this.velocidad = velocidad;
    this.esJugador = esJugador;
    this.limiteArriba = 0;
    this.limiteAbajo = height - alto;
    this.tiempoMovimiento = 0;
    
    // Configurar tipo de IA basado en posición inicial
    if (!esJugador) {
      if (y < height/2) {
        this.tipoIA = 1; // IA superior - agresiva hacia arriba
        this.direccionPreferida = -1; // Prefiere moverse hacia arriba
      } else {
        this.tipoIA = 2; // IA inferior - defensiva hacia abajo  
        this.direccionPreferida = 1; // Prefiere moverse hacia abajo
      }
    }
  }
  
  // Implementación del método abstracto (polimorfismo)
  @Override
  public void actualizar() {
    if (esJugador) {
      actualizarJugador();


    } else {
      actualizarIA();
    }
    
    // Mantener el paddle dentro de los límites
    constrainPosition();
  }
  
  // Método privado para actualizar movimiento del jugador
  private void actualizarJugador() {
    if (keyPressed) {
      if ((key == 'w' || key == 'W') && getY() > limiteArriba) {

        
        mover(-velocidad);
      }
      if ((key == 's' || key == 'S') && getY() < limiteAbajo) {
        mover(velocidad);
      }
    }
  }
  
  // Método privado para actualizar movimiento de la IA
  private void actualizarIA() {
    tiempoMovimiento += 0.02;
    
    if (pelota != null) {
      float centroPaddle = getY() + getAlto() / 2;
      float centroPelota = pelota.getY() + pelota.getAlto() / 2;
      
      if (tipoIA == 1) {
        // IA1 - Agresiva hacia arriba con movimiento ondulatorio
        actualizarIA1(centroPaddle, centroPelota);
      } else if (tipoIA == 2) {
        // IA2 - Defensiva hacia abajo con patrón zigzag
        actualizarIA2(centroPaddle, centroPelota);
      }
    }
  }
  
  // Método privado para IA1 - Comportamiento agresivo hacia arriba
  private void actualizarIA1(float centroPaddle, float centroPelota) {
    float factorVelocidad = 0.8;
    
    // Movimiento ondulatorio que prefiere la parte superior
    float movimientoOndulatorio = sin(tiempoMovimiento * 3) * 2;
    
    if (pelota.getVelocidadX() > 0) {
      // Seguir la pelota pero con tendencia hacia arriba
      float diferencia = centroPelota - centroPaddle;
      
      if (abs(diferencia) > 20) {
        // Movimiento principal hacia la pelota
        float movimiento = diferencia > 0 ? velocidad : -velocidad;
        // Añadir bias hacia arriba
        movimiento += direccionPreferida * velocidad * 0.3;
        // Añadir movimiento ondulatorio
        movimiento += movimientoOndulatorio;
        
        mover(movimiento * factorVelocidad);
      } else {
        // Movimiento sutil hacia arriba cuando está cerca de la pelota
        mover((direccionPreferida * velocidad * 0.4 + movimientoOndulatorio) * factorVelocidad);
      }
    } else {
      // Movimiento defensivo ondulatorio hacia arriba
      mover((direccionPreferida * velocidad * 0.2 + movimientoOndulatorio) * factorVelocidad);
    }
  }
  
  // Método privado para IA2 - Comportamiento defensivo hacia abajo
  private void actualizarIA2(float centroPaddle, float centroPelota) {
    float factorVelocidad = 0.6;
    
    // Movimiento zigzag que prefiere la parte inferior
    float movimientoZigzag = cos(tiempoMovimiento * 4) * 1.5;
    
    if (pelota.getVelocidadX() > 0) {
      // Seguir la pelota pero con tendencia hacia abajo
      float diferencia = centroPelota - centroPaddle;
      
      if (abs(diferencia) > 25) {
        // Movimiento principal hacia la pelota (más lento y defensivo)
        float movimiento = diferencia > 0 ? velocidad : -velocidad;
        // Añadir bias hacia abajo
        movimiento += direccionPreferida * velocidad * 0.2;
        // Añadir movimiento zigzag
        movimiento += movimientoZigzag;
        
        mover(movimiento * factorVelocidad);
      } else {
        // Movimiento sutil hacia abajo cuando está cerca de la pelota
        mover((direccionPreferida * velocidad * 0.3 + movimientoZigzag) * factorVelocidad);
      }
    } else {
      // Movimiento defensivo zigzag hacia abajo
      mover((direccionPreferida * velocidad * 0.15 + movimientoZigzag) * factorVelocidad);
    }
  }
  
  // Método privado para mover el paddle
  private void mover(float deltaY) {
    setY(getY() + deltaY);
  }
  
  // Método privado para mantener el paddle en los límites
  private void constrainPosition() {
    if (getY() < limiteArriba) {
      setY(limiteArriba);
    }
    if (getY() > limiteAbajo) {
      setY(limiteAbajo);
    }
  }
  
  // Sobrescribir el método dibujar para añadir efectos visuales
  @Override
  public void dibujar() {
    // Dibujar sombra
    fill(0, 50);
    rect(getX() + 2, getY() + 2, getAncho(), getAlto());
    
    // Dibujar paddle principal
    super.dibujar();
    
    // Añadir brillo si es el jugador
    if (esJugador) {
      stroke(255, 100);
      strokeWeight(2);
      noFill();
      rect(getX() - 1, getY() - 1, getAncho() + 2, getAlto() + 2);
      noStroke();
    }
  }
  
  // Getter para velocidad
  public float getVelocidad() {
    return velocidad;
  }
  
  // Setter para velocidad
  public void setVelocidad(float velocidad) {
    this.velocidad = velocidad;
  }
}
