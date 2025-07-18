# Reto Manantial

Una aplicación Flutter completa para gestión de usuarios con funcionalidades avanzadas de geolocalización, notificaciones y autenticación.

## 🚀 Características

- **Autenticación completa**: Login con email/contraseña y Google Sign-In
- **Gestión de usuarios**: Lista completa con operaciones CRUD
- **Geolocalización**: Integración con mapas y ubicación actual
- **Notificaciones locales**: Alertas automáticas para usuarios específicos
- **Funcionalidad offline**: Almacenamiento local y sincronización
- **Llamadas telefónicas**: Integración directa con el sistema de llamadas
- **UI moderna**: Diseño intuitivo con animaciones fluidas

## 🛠️ Tecnologías Utilizadas

### **Arquitectura**
- **Clean Architecture**: Separación clara de responsabilidades
- **BLoC Pattern**: Gestión de estado reactiva y predecible
- **Dependency Injection**: Injectable con GetIt para IoC

### **Autenticación**
- **Firebase Auth**: Autenticación segura
- **Google Sign-In**: Login social integrado

### **Almacenamiento**
- **SharedPreferences**: Persistencia local
- **API REST**: Integración con servicios externos

### **Mapas y Localización**
- **Flutter Map**: Visualización de mapas interactivos
- **Geolocator**: Obtención de ubicación actual
- **LatLng**: Manejo de coordenadas geográficas

### **Notificaciones**
- **Flutter Local Notifications**: Notificaciones push locales
- **Permisos automáticos**: Gestión transparente de permisos

### **UI/UX**
- **Material Design**: Componentes nativos de Flutter
- **Lottie**: Animaciones vectoriales fluidas
- **Shimmer**: Efectos de carga elegantes
- **Slidable**: Acciones deslizables en listas
- **Custom Transitions**: Animaciones personalizadas entre pantallas

### **Validaciones**
- **Formz**: Validación robusta de formularios
- **RegExp**: Validaciones de formato personalizadas

### **Networking**
- **Dio**: Cliente HTTP avanzado
- **Connectivity Plus**: Detección de estado de conexión

### **Utilidades**
- **URL Launcher**: Launcher para llamadas telefónicas
- **Intl**: Internacionalización y formateo de fechas

## 📱 Funcionalidades Principales

### **Autenticación**
- Login con email y contraseña
- Integración con Google Sign-In
- Gestión automática de sesiones
- Logout con limpieza de datos locales

### **Gestión de Usuarios**
- Lista completa de usuarios con paginación
- Operaciones CRUD (Crear, Leer, Actualizar, Eliminar)
- Usuarios locales y remotos
- Filtros por favoritos y alertas
- Búsqueda y ordenamiento

### **Geolocalización**
- Mapa interactivo con marcadores de usuarios
- Obtención de ubicación actual
- Visualización de coordenadas
- Toggle de visibilidad de usuarios en mapa

### **Notificaciones**
- Notificaciones automáticas para usuarios con alertas habilitadas
- Gestión inteligente de notificaciones (sin duplicados)
- Permisos automáticos multiplataforma

### **Offline First**
- Funcionamiento sin conexión
- Sincronización automática al reconectar
- Almacenamiento local de usuarios
- Indicadores de estado de conexión

### **Interfaz Moderna**
- Diseño Material Design 3
- Animaciones fluidas entre pantallas
- Skeleton loading para mejor UX
- Cards rediseñadas con información organizada
- Iconos coloridos y estados visuales claros

## 🏗️ Arquitectura del Proyecto

```
lib/
├── core/
│   ├── di/                     # Dependency Injection
│   ├── services/               # Servicios core
│   └── utils/                  # Utilidades y helpers
├── features/
│   ├── auth/                   # Autenticación
│   │   ├── data/              # Implementaciones
│   │   ├── domain/            # Entidades y casos de uso
│   │   └── presentation/       # UI y BLoC
│   └── users/                  # Gestión de usuarios
│       ├── data/              # Repositories y datasources
│       ├── domain/            # Lógica de negocio
│       └── presentation/       # Páginas y widgets
└── main.dart                   # Punto de entrada
```

## 🚀 Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/DarkCodex29/Reto-Manantial.git
cd reto_manantial
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Generar código**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Configurar Firebase**
- Crear proyecto en Firebase Console
- Descargar `google-services.json` (Android)
- Descargar `GoogleService-Info.plist` (iOS)
- Configurar autenticación con Google

5. **Ejecutar la aplicación**
```bash
flutter run
```

## 📋 Configuración Adicional

### **Firebase**
- Habilitar Authentication con Email/Password
- Habilitar Google Sign-In
- Configurar SHA-1 para Android

### **Permisos**
- Ubicación: Para geolocalización
- Notificaciones: Para alertas locales
- Internet: Para sincronización

## 🧪 Testing

```bash
# Análisis de código
flutter analyze

# Formateo
flutter format .

# Tests unitarios
flutter test
```

## 📦 Build

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 🔧 Requisitos del Sistema

- Flutter SDK >= 3.8.0
- Dart SDK >= 3.8.0
- Android SDK >= 21
- iOS >= 12.0

## 👨‍💻 Autor

**Gianpierre Mio**
- GitHub: [@DarkCodex29](https://github.com/DarkCodex29)
- Repositorio: [Reto-Manantial](https://github.com/DarkCodex29/Reto-Manantial)

## 📞 Soporte

Para preguntas y soporte técnico, contactar al autor del proyecto.

---

Desarrollado con ❤️ usando Flutter