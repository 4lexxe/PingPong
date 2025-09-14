// Clase base abstracta para todos los objetos del juego
abstract class GameObject {
  // Atributos privados (encapsulación)
  private float x, y;
  private float ancho, alto;
  private color colorObjeto;
  
  // Constructor
  public GameObject(float x, float y, float ancho, float alto, color colorObjeto) {
    this.x = x;
    this.y = y;
    this.ancho = ancho;
    this.alto = alto;
    this.colorObjeto = colorObjeto;
  }
  
  // Métodos getter (acceso controlado a atributos privados)
  public float getX() { return x; }
  public float getY() { return y; }
  public float getAncho() { return ancho; }
  public float getAlto() { return alto; }
  public color getColor() { return colorObjeto; }
  
  // Métodos setter (modificación controlada de atributos privados)
  protected void setX(float x) { this.x = x; }
  protected void setY(float y) { this.y = y; }
  protected void setAncho(float ancho) { this.ancho = ancho; }
  protected void setAlto(float alto) { this.alto = alto; }
  protected void setColor(color colorObjeto) { this.colorObjeto = colorObjeto; }
  
  // Método abstracto que debe ser implementado por las clases hijas (polimorfismo)
  public abstract void actualizar();
  
  // Método común para dibujar (puede ser sobrescrito)
  public void dibujar() {
    fill(colorObjeto);
    rect(x, y, ancho, alto);
  }
  
  // Método para detectar colisiones
  public boolean colisionaCon(GameObject otro) {
    return (x < otro.x + otro.ancho &&
            x + ancho > otro.x &&
            y < otro.y + otro.alto &&
            y + alto > otro.y);
  }
}
