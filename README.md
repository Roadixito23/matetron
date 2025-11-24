# MATETRÓN 💪📊

## Sistema de Optimización Matemática para Entrenamientos Deportivos

MATETRÓN es una aplicación móvil Flutter que aplica matrices, funciones lineales y operaciones matemáticas para optimizar la planificación de entrenamientos deportivos. Permite a deportistas amateur cuantificar su progreso mediante herramientas matemáticas accesibles.

---

## 🎯 Características Principales

### 📐 Módulo 1: Matriz de Rutinas
- Organiza ejercicios × días en formato matricial R(n×7)
- n = número de ejercicios (3-10), 7 = días de la semana
- Cálculo automático de volumen por día, por ejercicio y total semanal
- Interfaz interactiva con DataTable editable
- Almacenamiento local con Hive

**Fórmulas implementadas:**
- Volumen celda: `V = series × repeticiones`
- Volumen total: `V_total = Σᵢ Σⱼ (series × reps)ᵢⱼ`
- Gasto calórico: `G = R × C` (multiplicación matricial)

### 📈 Módulo 2: Calculadora de Progresión
- Proyecta mejoras mediante función lineal: `f(t) = P₀ + r·t`
- Valida tasas de mejora según nivel del deportista
- Genera tabla de proyección semanal
- Identifica semanas de descarga automáticamente
- Alertas de sobreentrenamiento

**Tasas saludables:**
- Principiante: 5-10% semanal
- Intermedio: 3-5% semanal
- Avanzado: 1-3% semanal

### 📊 Módulo 3: Gráfico de Tendencia
- Visualiza progreso histórico con fl_chart
- Calcula regresión lineal: `y = mx + b`
- Muestra coeficiente de determinación R²
- Proyección futura basada en tendencia
- Gestión completa de registros de progreso

### 🎯 Módulo 4: Dashboard de Indicadores
- Métricas clave: volumen semanal, mensual, calorías
- Gráfico de volumen por día de la semana
- Progreso reciente de cada ejercicio
- Sistema de alertas inteligentes

---

## 🚀 Instalación y Ejecución

### Requisitos Previos
- Flutter SDK (3.10.0 o superior)
- Dart SDK
- Android Studio / Xcode (para emuladores)

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone <repository-url>
cd matetron
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**
```bash
flutter run
```

### Compilación para Producción

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

---

## 🔢 Fórmulas Matemáticas Implementadas

### 1. Función Lineal de Progresión
```
f(t) = P₀ + r·t
donde:
  P₀ = rendimiento inicial
  r = tasa de mejora por semana
  t = tiempo en semanas
```

### 2. Regresión Lineal
```
m = (n·Σxy - Σx·Σy) / (n·Σx² - (Σx)²)
b = (Σy - m·Σx) / n
R² = 1 - (SS_res / SS_tot)
```

### 3. Cálculos Matriciales
```
Volumen total: V = Σᵢ Σⱼ Rᵢⱼ
Gasto calórico: G = R × C
```

---

## 📱 Uso de la Aplicación

1. **Primer uso**: La app carga 4 ejercicios de ejemplo
2. **Crear rutina**: Ve a "Matriz de Rutinas" y crea tu primera rutina
3. **Registrar progreso**: Agrega registros en "Gráfico de Tendencia"
4. **Calcular metas**: Usa "Calculadora de Progresión" para proyectar
5. **Monitorear**: Revisa el "Dashboard" regularmente

---

## 🎨 Diseño

### Paleta de Colores
- **Primario**: #FFD700 (Dorado)
- **Secundario**: #4A90E2 (Azul)
- **Fondo**: #2B2B2B (Gris oscuro)
- **Éxito**: #50C878 (Verde)
- **Advertencia**: #FFA500 (Naranja)
- **Peligro**: #E74C3C (Rojo)

---

## 📄 Licencia

MIT License - Código abierto

---

**¡MATETRÓN - Donde las matemáticas impulsan tu rendimiento deportivo!** 💪📐
