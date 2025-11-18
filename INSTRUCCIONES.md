# MATETRÓN - Instrucciones de Instalación y Uso

## Sistema Digital de Optimización Matemática para Entrenamientos Deportivos

**Proyecto de Funciones y Matrices - INACAP**
**Autores:** Sebastián Reyes y Dante Agüero
**Profesora:** Rosalba Margot Barros Rojas

---

## Requisitos Previos

1. **Flutter SDK** instalado (versión 3.10 o superior)
2. **Android Studio** o **Visual Studio Code** con extensiones de Flutter
3. **Dispositivo Android** o **Emulador Android**
4. **Git** para clonar el repositorio

---

## Instalación

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/Roadixito23/matetron.git
cd matetron
```

### Paso 2: Instalar Dependencias

```bash
flutter pub get
```

Este comando instalará todas las dependencias necesarias:
- `fl_chart` - Para gráficos interactivos
- `sqflite` - Base de datos local
- `provider` - Gestión de estado
- `path_provider` - Acceso a rutas del sistema
- `intl` - Formateo de números y fechas

### Paso 3: Verificar Configuración de Flutter

```bash
flutter doctor
```

Asegúrate de que todos los componentes estén correctamente instalados.

### Paso 4: Ejecutar la Aplicación

**En un dispositivo físico:**
```bash
flutter run
```

**En un emulador específico:**
```bash
flutter devices  # Ver dispositivos disponibles
flutter run -d <device-id>
```

**Para compilar APK:**
```bash
flutter build apk --release
```
El APK estará en `build/app/outputs/flutter-apk/app-release.apk`

---

## Estructura del Proyecto

```
lib/
├── main.dart                          # Punto de entrada, tema y configuración
├── models/                            # Modelos de datos
│   ├── ejercicio.dart                 # Modelo de ejercicio individual
│   ├── rutina.dart                    # Modelo de rutina semanal (matriz 4×7)
│   └── progresion.dart                # Modelo de progresión del atleta
├── screens/                           # Pantallas de la aplicación
│   ├── home_screen.dart               # Pantalla principal con navegación
│   ├── matriz_rutinas_screen.dart     # Matriz 4×7 editable
│   ├── progresion_lineal_screen.dart  # f(t) = P₀ + r·t
│   ├── progresion_cuadratica_screen.dart  # f(t) = at² + bt + c
│   ├── recuperacion_exponencial_screen.dart  # f(t) = P₀·e^(-kt)
│   ├── rendimientos_logaritmicos_screen.dart  # f(t) = a·ln(t) + b
│   ├── periodizacion_trigonometrica_screen.dart  # f(t) = A·sen(ωt + φ) + k
│   └── gasto_calorico_screen.dart     # Multiplicación matricial R × C = G
├── services/                          # Lógica de negocio
│   ├── matriz_service.dart            # Operaciones matriciales
│   └── funciones_service.dart         # Análisis de funciones matemáticas
└── utils/                             # Utilidades
    └── calculos_matematicos.dart      # Implementación de todas las funciones
```

---

## Módulos Implementados

### 1. Operaciones Matriciales

#### Matriz de Rutinas (matriz_rutinas_screen.dart)
- **Concepto:** Matriz 4×7 (4 ejercicios × 7 días)
- **Fórmula:** `V_total = Σᵢ Σⱼ rᵢⱼ`
- **Funcionalidad:**
  - Tabla editable para ingresar series y repeticiones
  - Cálculo automático del volumen total semanal
  - Validación de volumen (bajo, óptimo, alto, excesivo)
  - Visualización de distribución por día

#### Gasto Calórico (gasto_calorico_screen.dart)
- **Concepto:** Multiplicación matricial `R × C = G`
- **Fórmula:**
  - R: Matriz de rutinas (repeticiones)
  - C: Vector de calorías por ejercicio
  - G: Vector de gasto calórico diario
- **Funcionalidad:**
  - Cálculo automático del gasto calórico por día
  - Gráfico de barras por día y por ejercicio
  - Total semanal

---

### 2. Funciones Matemáticas

#### Progresión Lineal (progresion_lineal_screen.dart)
- **Función:** `f(t) = P₀ + r·t`
- **Módulo Curricular:** Funciones Polinómicas de Grado 1
- **Conexión ARPA:** "Consumo de energía", "Servicio eléctrico"
- **Parámetros:**
  - P₀: Valor inicial (peso/rendimiento base)
  - r: Tasa de mejora semanal (kg/semana)
  - t: Tiempo en semanas
- **Funcionalidad:**
  - Proyección de progreso lineal
  - Cálculo de porcentaje de mejora
  - Validación de tasa de mejora (2-5% recomendado)
  - Gráfico de línea

#### Progresión Cuadrática (progresion_cuadratica_screen.dart)
- **Función:** `f(t) = at² + bt + c`
- **Módulo Curricular:** Funciones Polinómicas de Grado 2
- **Conexión ARPA:** "Lanzamiento de una piedra", "Peak Performance"
- **Parámetros:**
  - a: Coeficiente cuadrático
  - b: Coeficiente lineal
  - c: Intercepto
- **Funcionalidad:**
  - Cálculo del vértice (semana de máximo rendimiento)
  - Determinación de punto óptimo antes del sobreentrenamiento
  - Gráfico parabólico con línea vertical en el vértice

#### Recuperación Exponencial (recuperacion_exponencial_screen.dart)
- **Función:** `f(t) = P₀ · e^(-kt)`
- **Módulo Curricular:** Funciones Exponenciales
- **Conexión ARPA:** "Eliminación de fármacos"
- **Parámetros:**
  - P₀: Fatiga inicial (%)
  - k: Constante de decaimiento
  - t: Tiempo en horas
- **Funcionalidad:**
  - Cálculo de vida media de la fatiga
  - Tiempo para recuperación al 90% y 95%
  - Curva exponencial de recuperación

#### Rendimientos Logarítmicos (rendimientos_logaritmicos_screen.dart)
- **Función:** `f(t) = a · ln(t) + b`
- **Módulo Curricular:** Funciones Logarítmicas
- **Conexión ARPA:** "Escala Richter", "Seguidores de Instagram"
- **Parámetros:**
  - a: Factor de escala
  - b: Nivel base
  - t: Semanas
- **Funcionalidad:**
  - Modelado de rendimientos decrecientes
  - Comparación de mejora inicial vs final
  - Adecuado para atletas intermedios/avanzados

#### Periodización Trigonométrica (periodizacion_trigonometrica_screen.dart)
- **Función:** `f(t) = A · sen(ωt + φ) + k`
- **Módulo Curricular:** Funciones Trigonométricas
- **Conexión ARPA:** "Análisis de ondas sonoras"
- **Parámetros:**
  - A: Amplitud (variación de intensidad)
  - ω: Frecuencia angular (calculada desde período)
  - φ: Fase (desplazamiento)
  - k: Intensidad media
- **Funcionalidad:**
  - Modelado de ciclos de carga/descarga
  - Cálculo de intensidades máximas y mínimas
  - Onda sinusoidal con líneas de referencia

---

## Justificación Curricular

### Unidad 1: Funciones Polinómicas, Exponencial y Logarítmica

| Módulo | Función | Aplicación en MATETRÓN |
|--------|---------|------------------------|
| 1-2 | Lineal (grado 1) | Progresión constante de rendimiento |
| 2 | Cuadrática (grado 2) | Peak performance y sobreentrenamiento |
| 4 | Exponencial | Recuperación muscular y decaimiento de fatiga |
| 5 | Logarítmica | Rendimientos decrecientes en atletas avanzados |

### Unidad 2: Trigonometría

| Módulo | Concepto | Aplicación en MATETRÓN |
|--------|----------|------------------------|
| 3 | Funciones trigonométricas | Periodización de entrenamiento (ciclos) |

### Operaciones Matriciales

- **Matrices 4×7:** Organización de rutinas de ejercicios
- **Sumatorias:** Cálculo de volumen total de entrenamiento
- **Multiplicación matricial:** Cálculo de gasto calórico

---

## Ejemplos de Uso

### Ejemplo 1: Calcular Progresión Lineal
1. Ir a "Progresión Lineal"
2. Ingresar:
   - Valor inicial: 50 kg
   - Tasa de mejora: 1.25 kg/semana
   - Semanas: 12
3. Ver proyección: 65 kg (30% de mejora)

### Ejemplo 2: Crear Rutina y Calcular Gasto Calórico
1. Ir a "Matriz de Rutinas"
2. Tocar celdas para editar ejercicios
3. Ingresar series y repeticiones
4. Ver volumen total calculado automáticamente
5. Ir a "Gasto Calórico" para ver calorías quemadas

### Ejemplo 3: Planificar Periodización
1. Ir a "Periodización Trigonométrica"
2. Configurar:
   - Amplitud: 20% (variación de intensidad)
   - Período: 4 semanas (ciclo típico)
   - Intensidad media: 70%
3. Ver onda con ciclos de carga y descarga

---

## Paleta de Colores

- **Primario:** #c41e3a (Rojo)
- **Secundario:** #f39c12 (Naranja/Amarillo)
- **Acento:** #8e44ad (Morado)
- **Fondo:** #f5f5f5 (Gris claro)

---

## Dependencias Principales

```yaml
dependencies:
  fl_chart: ^0.66.0          # Gráficos interactivos
  sqflite: ^2.3.0             # Base de datos local
  path_provider: ^2.1.1       # Rutas de almacenamiento
  provider: ^6.1.1            # Gestión de estado
  intl: ^0.18.1               # Formateo de números
```

---

## Solución de Problemas

### Error: "flutter: command not found"
**Solución:** Instalar Flutter SDK desde https://flutter.dev/docs/get-started/install

### Error al ejecutar "flutter pub get"
**Solución:** Verificar conexión a internet y ejecutar:
```bash
flutter pub cache repair
flutter pub get
```

### La app no compila
**Solución:**
```bash
flutter clean
flutter pub get
flutter run
```

### Errores de dependencias
**Solución:**
```bash
flutter pub upgrade
```

---

## Próximas Mejoras (Opcionales)

1. **Base de datos local con SQLite:**
   - Guardar rutinas creadas
   - Historial de entrenamientos
   - Comparar progresión real vs proyectada

2. **Gráficos comparativos:**
   - Comparar modelos lineal, logarítmico y cuadrático
   - Overlay de múltiples progresiones

3. **Exportar datos:**
   - Exportar rutinas a PDF
   - Compartir gráficos

4. **Notificaciones:**
   - Recordatorios de entrenamiento
   - Alertas de sobreentrenamiento

---

## Contacto y Soporte

- **Autores:** Sebastián Reyes y Dante Agüero
- **Institución:** INACAP
- **Asignatura:** Funciones y Matrices
- **Profesora:** Rosalba Margot Barros Rojas

---

## Licencia

Este proyecto es desarrollado con fines educativos para la asignatura de Funciones y Matrices de INACAP.

---

**Desarrollado con Flutter** 💙
**Matemáticas aplicadas al deporte** 🏋️‍♂️📊
