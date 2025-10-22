# 🏓 Pong - Implementación en VHDL

## 📋 Descripción
Implementación completa del clásico juego Pong en VHDL para FPGA. Este proyecto incluye todos los módulos necesarios para un funcionamiento completo con gráficos, física de colisiones y sistema de puntuación.

## 🎯 Características Principales
- **Tablero de 99x96 unidades** con movimiento preciso
- **2 jugadores** con control individual
- **Sistema de colisiones** realistas con ángulos de rebote
- **Marcador digital** en displays 7 segmentos
- **Temporizador de 2 minutos** con fin de juego automático
- **Máquina de estados finitos** para control del juego
- **Interfaz visual** con coordenadas en tiempo real

## 🕹️ Controles
- **Jugador Izquierdo**: Botones YL + switch de dirección
- **Jugador Derecho**: Botones YR + switch de dirección  
- **Enter**: Iniciar/Reiniciar juego
- **Pause**: Pausar el juego
- **Reset**: Reinicio completo

## 🛠️ Módulos Implementados
- `Ball Movement` - Control y física de la pelota
- `Player Controller` - Movimiento de jugadores
- `Collision Detector` - Detección de colisiones
- `Score Manager` - Sistema de puntuación
- `Display Controller` - Control de displays 7-segmentos
- `Game Timer` - Temporizador de 2 minutos
- `Clock Divider` - Gestión de relojes

## 📊 Displays
- **4 displays**: Posición X,Y de la pelota (decimal)
- **2 displays**: Puntuación jugadores (hexadecimal)  
- **2 displays**: Posición Y jugador derecho (decimal)
- **Indicador "F"**: Fin del juego

## 🎮 Estados del Juego
1. **Inicial**: Esperando inicio
2. **Jugando**: Partida en curso
3. **Pausado**: Juego en pausa
4. **Game Over**: Fin del tiempo
5. **Reinicio**: Volver al estado inicial

## 🔧 Tecnologías
- **Lenguaje**: VHDL
- **Plataforma**: FPGA (Nexys 4 / A7)
- **Herramientas**: Xilinx Vivado
- **Simulación**: Testbenches completos

---

*Proyecto académico de Diseño Digital - Implementación completa de Pong en hardware*