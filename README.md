
# ego - Sistema de Gestión de Clientes y Membresías

**ego** es una aplicación móvil desarrollada en Flutter con SQLite para la gestión eficiente de clientes y membresías de un gimnasio u organización similar. Ofrece una interfaz moderna, seguimiento de membresías activas y estadísticas clave para la toma de decisiones.

---

## ✨ Características

- 📋 Registro y edición de clientes
- 🪪 Gestión de membresías con tipos: Normal y Personalizado
- 📊 Visualización de estadísticas de clientes y membresías
- 🗃️ Almacenamiento local con SQLite
- 🚫 Eliminación lógica de clientes (sin borrar datos)
- 📅 Fechas formateadas amigablemente gracias a `intl`
- 🎨 Estética premium con colores personalizados (gold, darkGold, etc.)

---

## 📂 Estructura destacada

```
lib/
├── models/               # Modelos de datos (Cliente, Membresía, Stats)
├── repository/           # Repositorios de acceso a datos
├── pages/                # Lógica de navegación y control
├── widgets/              # Componentes visuales reutilizables
├── services/             # Base de datos y lógica de conexión
├── theme/                # Paleta de colores y estilos
├── utils/                # Funciones utilitarias para la interfaz
```

---

## 🚀 Instalación

1. Clona este repositorio:
```
git clone https://github.com/ezerutp/ego.git
```

2. Instala las dependencias:
```
flutter pub get
```

3. Corre la app:
```
flutter run
```

---

## 🧪 Datos de prueba

Puedes usar `test.dart` para insertar datos iniciales:
```dart
Test().initTestData();
Test().insertMembresias();
```

---

## 🧠 Autor

Desarrollado por **Ezer Vidarte**  
Ingeniero de Sistemas | UTP 🇵🇪  
[GitHub](https://github.com/ezerutp) | [LinkedIn](https://www.linkedin.com/in/ezervidarte)

---

## 📌 Notas

- Proyecto enfocado en prácticas de arquitectura limpia y componentes modulares
- Pensado para expandirse con funcionalidades como reportes PDF, pagos, notificaciones y sincronización en la nube
