// Clase Ball que hereda de GameObject
class Ball extends GameObject {
  // Atributos privados específicos de la pelota
  private float velocidadX, velocidadY;
  private float velocidadMaxima;
  private int rebotes;
  private boolean enJuego;
  
  // Constructor
  public Ball(float x, float y, float tamaño, color colorPelota, float velocidadInicial) {
    super(x, y, tamaño, tamaño, colorPelota);
    this.velocidadMaxima = velocidadInicial;
    this.rebotes = 0;
    this.enJuego = false;
    reiniciarPelota();
  }
  
  // Implementación del método abstracto (polimorfismo)
  @Override
  public void actualizar() {
    if (!enJuego) return;
    
    // Actualizar posición
    setX(getX() + velocidadX);
    setY(getY() + velocidadY);
    
    // Verificar colisiones con bordes superior e inferior
    verificarColisionesBordes();
    
    // Verificar colisiones con paddles
    verificarColisionesPaddles();
    
    // Verificar si la pelota sale de los límites laterales
    verificarGoles();
  }
  
  // Método privado para verificar colisiones con bordes
  private void verificarColisionesBordes() {
    if (getY() <= 0 || getY() + getAlto() >= height) {
      velocidadY = -velocidadY;
      setY(constrain(getY(), 0, height - getAlto()));
      reproducirSonidoRebote();
    }
  }
  
  // Método privado para verificar colisiones con paddles
  private void verificarColisionesPaddles() {
    if (jugador != null && colisionaCon(jugador)) {
      manejarColisionPaddle(jugador);
    }
    
    if (ia1 != null && colisionaCon(ia1)) {
      manejarColisionPaddle(ia1);
    }
    
    if (ia2 != null && colisionaCon(ia2)) {
      manejarColisionPaddle(ia2);
    }
  }
  
  // Método privado para manejar colisión con paddle
  private void manejarColisionPaddle(Paddle paddle) {
    // Calcular el punto de impacto relativo
    float puntoImpacto = ((getY() + getAlto()/2) - (paddle.getY() + paddle.getAlto()/2)) / (paddle.getAlto()/2);
    
    // Invertir velocidad X y ajustar ángulo según el punto de impacto
    velocidadX = -velocidadX;
    velocidadY = puntoImpacto * velocidadMaxima * 0.5;
    
    // Incrementar velocidad ligeramente con cada rebote
    aumentarVelocidad();
    
    // Asegurar que la pelota no se quede atrapada
    if (velocidadX > 0) {
      setX(paddle.getX() + paddle.getAncho() + 1);
    } else {
      setX(paddle.getX() - getAncho() - 1);
    }
    
    rebotes++;
    reproducirSonidoRebote();
  }
  
  // Método privado para aumentar velocidad gradualmente
  private void aumentarVelocidad() {
    float factor = 1.05; // Incremento del 5%
    velocidadX *= factor;
    velocidadY *= factor;
    
    // Limitar velocidad máxima
    velocidadX = constrain(velocidadX, -velocidadMaxima * 2, velocidadMaxima * 2);
    velocidadY = constrain(velocidadY, -velocidadMaxima * 1.5, velocidadMaxima * 1.5);
  }
  
  // Método privado para verificar goles
  private void verificarGoles() {
    if (getX() + getAncho() < 0) {
      // Gol para las IAs - determinar cuál IA está más cerca de la pelota
      float distanciaIA1 = abs((ia1.getY() + ia1.getAlto()/2) - (getY() + getAlto()/2));
      float distanciaIA2 = abs((ia2.getY() + ia2.getAlto()/2) - (getY() + getAlto()/2));
      
      if (distanciaIA1 < distanciaIA2) {
        puntajeIA1++;
      } else {
        puntajeIA2++;
      }
      reiniciarDespuesGol(false);
    } else if (getX() > width) {
      // Gol para el jugador
      puntajeJugador++;
      reiniciarDespuesGol(true);
    }
  }
  
  // Método privado para reiniciar después de un gol
  private void reiniciarDespuesGol(boolean golJugador) {
    enJuego = false;
    rebotes = 0;
    
    // Centrar pelota
    setX(width/2 - getAncho()/2);
    setY(height/2 - getAlto()/2);
    
    // Dirección inicial hacia quien no anotó
    velocidadX = golJugador ? velocidadMaxima : -velocidadMaxima;
    velocidadY = random(-velocidadMaxima/2, velocidadMaxima/2);
    
    // Pausa antes de continuar
    tiempoEspera = millis() + 1500;
  }
  
  // Método público para reiniciar la pelota
  public void reiniciarPelota() {
    setX(width/2 - getAncho()/2);
    setY(height/2 - getAlto()/2);
    
    // Dirección inicial aleatoria
    velocidadX = random(0, 1) > 0.5 ? velocidadMaxima : -velocidadMaxima;
    velocidadY = random(-velocidadMaxima/2, velocidadMaxima/2);
    
    rebotes = 0;
    enJuego = true;
  }
  
  // Método privado para simular sonido de rebote
  private void reproducirSonidoRebote() {
    // Crear partículas en el punto de rebote
    crearParticulasRebote(getX() + getAncho()/2, getY() + getAlto()/2, getColor());
  }
  
  // Sobrescribir el método dibujar para efectos visuales
  @Override
  public void dibujar() {
    pushMatrix();
    translate(getX() + getAncho()/2, getY() + getAlto()/2);
    
    // Efecto de rotación basado en velocidad
    rotate(frameCount * 0.1);
    
    // Dibujar sombra
    fill(0, 30);
    ellipse(2, 2, getAncho(), getAlto());
    
    // Dibujar pelota principal
    fill(getColor());
    ellipse(0, 0, getAncho(), getAlto());
    
    // Añadir brillo
    fill(255, 150);
    ellipse(-getAncho()/4, -getAlto()/4, getAncho()/3, getAlto()/3);
    
    popMatrix();
  }
  
  // Getters
  public float getVelocidadX() { return velocidadX; }
  public float getVelocidadY() { return velocidadY; }
  public int getRebotes() { return rebotes; }
  public boolean isEnJuego() { return enJuego; }
  
  // Setters
  public void setEnJuego(boolean enJuego) { this.enJuego = enJuego; }
  public void setVelocidad(float vx, float vy) {
    this.velocidadX = vx;
    this.velocidadY = vy;
  }
}
