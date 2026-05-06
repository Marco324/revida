## 🔥 Firebase Setup

Este proyecto usa **Firebase Authentication**.

## ⚠️ Importante
Este repositorio no incluye el archivo google-services.json por razones de seguridad.
Para ejectuarlo hay que configurar un proyecto propio en Firebase.

Para poder ejecutarlo correctamente, sigue estos pasos:

### 1️⃣ Crear un proyecto en Firebase
- Ve a https://console.firebase.google.com/
- Crea un nuevo proyecto.

### 2️⃣ Agregar una app Android
- Dentro del proyecto, selecciona **Agregar app → Android**.
- Usa el mismo `applicationId` que aparece en:
  android/app/build.gradle

### 3️⃣ Descargar el archivo `google-services.json`
- Firebase te dará un archivo llamado:
google-services.json

### 4️⃣ Colocarlo en la siguiente ruta del proyecto:
android/app/

### 5️⃣ Instalar dependencias y ejecutar

Desde la raíz del proyecto ejecuta:

```bash
flutter pub get
flutter run
```

