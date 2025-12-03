# Bitácora de Campo (Field Explorer Log)

Una aplicación móvil desarrollada en Flutter para gestionar registros de exploradores y lecturas de sensores ambientales (Magnetómetro y Barómetro) en expediciones de campo.

## 📱 Características Principales

*   **Registro de Exploradores**: Formulario completo para registrar nuevos exploradores con validación de datos y selector de fecha.
*   **Base de Datos Local**: Almacenamiento persistente utilizando SQLite (`sqflite`) para guardar exploradores y logs de sensores.
*   **Sensores en Tiempo Real**:
    *   **Magnetómetro**: Visualización de coordenadas X, Y, Z con interfaz gráfica.
    *   **Barómetro**: Lectura de presión atmosférica con indicador visual.
*   **Historial de Sensores**: Visualización de registros guardados.
    *   **Soporte de Orientación**: Diseño adaptativo que muestra listas en columna (Vertical) o fila (Horizontal) según la orientación del dispositivo.
*   **Diseño Premium**: Interfaz de usuario moderna con tema verde "Field-Ready", gradientes, tarjetas y animaciones de carga.

## 🛠 Tecnologías Utilizadas

*   **Framework**: [Flutter](https://flutter.dev/) & Dart
*   **Base de Datos**: [sqflite](https://pub.dev/packages/sqflite) (Android/iOS) & [sqflite_common_ffi_web](https://pub.dev/packages/sqflite_common_ffi_web) (Web)
*   **Sensores**: [sensors_plus](https://pub.dev/packages/sensors_plus)
*   **Fechas**: [intl](https://pub.dev/packages/intl)
*   **Gestión de Rutas**: Named Routes

## 📸 Capturas de Pantalla

| Home | Registro | Magnetómetro | Historial |
|------|----------|--------------|-----------|
| *Menú Principal* | *Formulario* | *Lectura de Sensor* | *Logs Guardados* |

## 🚀 Instalación y Ejecución

1.  **Clonar el repositorio**:
    ```bash
    git clone https://github.com/danielcucuma/app_movil_exploradores.git
    cd app_movil_exploradores
    ```

2.  **Instalar dependencias**:
    ```bash
    flutter pub get
    ```

3.  **Ejecutar la aplicación**:
    *   Para Android/iOS:
        ```bash
        flutter run
        ```
    *   Para Web (requiere servidor):
        ```bash
        flutter run -d web-server --web-hostname localhost --web-port 8080
        ```

## 📂 Estructura del Proyecto

*   `lib/database/`: Lógica de base de datos (Singleton DatabaseHelper).
*   `lib/models/`: Modelos de datos (Explorer, SensorLog).
*   `lib/screens/`: Pantallas de la interfaz de usuario.
*   `lib/main.dart`: Punto de entrada y configuración de tema/rutas.

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.
