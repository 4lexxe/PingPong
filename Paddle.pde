// Clase Paddle que hereda de GameObject
class Paddle extends GameObject {
  // Atributos privados específicos del paddle
  private float velocidad;
  private boolean esJugador; // true para jugador, false para IA
  private float limiteArriba, limiteAbajo;
  
  // Constructor
  public Paddle(float x, float y, float ancho, float alto, color colorPaddle, float velocidad, boolean esJugador) {
    super(x, y, ancho, alto, colorPaddle);
    this.velocidad = velocidad;
    this.esJugador = esJugador;
    this.limiteArriba = 0;
    this.limiteAbajo = height - alto;
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
    // IA que sigue la pelota con diferentes estrategias
    if (pelota != null) {
      float centroPaddle = getY() + getAlto() / 2;
      float centroPelota = pelota.getY() + pelota.getAlto() / 2;
      
      // Determinar qué tan agresiva debe ser la IA según su posición
      float factorVelocidad = (this == ia1) ? 0.7 : 0.6; // IA1 más rápida que IA2
      
      // Solo moverse si la pelota se acerca a este lado
      if (pelota.getVelocidadX() > 0) {
        if (centroPelota < centroPaddle - 15) {
          mover(-velocidad * factorVelocidad);
        } else if (centroPelota > centroPaddle + 15) {
          mover(velocidad * factorVelocidad);
        }
      }
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
