# 1Cup App (Flutter)

Cliente movil de 1Cup.  
Stack principal: Flutter + Firebase Auth + Firestore.

## Requisitos

- Flutter 3.x
- Dart 3.x
- Firebase CLI (para emuladores cuando aplique)

## Setup rapido

```powershell
cd app
flutter pub get
flutter run `
  --dart-define=FIREBASE_ANDROID_API_KEY=TU_API_KEY_ANDROID `
  --dart-define=FIREBASE_IOS_API_KEY=TU_API_KEY_IOS
```

Coloca tus archivos locales de Firebase (no versionados):

- `app/android/app/google-services.json`
- `app/ios/Runner/GoogleService-Info.plist`

## Calidad minima

```powershell
cd app
flutter analyze
flutter test
```

## Magic Link (Auth) - setup y prueba real

### Configuracion Firebase requerida

1. Firebase Console -> Authentication -> Sign-in method:
   - Habilitar `Email link (passwordless sign-in)`.
2. Firebase Console -> Authentication -> Settings -> Authorized domains:
   - Verificar `cach-reward.firebaseapp.com`.
   - Verificar `cach-reward.web.app`.
   - Agregar dominio local si pruebas web local.
3. Firebase Console -> Project Settings -> Your apps:
   - Android `applicationId`: `com.example.app`.
   - iOS `bundleId`: `com.example.app`.

### Deep links ya configurados en el proyecto

- Android intent filters: `app/android/app/src/main/AndroidManifest.xml`
- iOS Associated Domains: `app/ios/Runner/Runner.entitlements`

### Checklist de prueba en dispositivo (Android/iOS)

1. Instalar app en dispositivo real con la build de debug/release.
2. Abrir app, ingresar correo y pulsar `Enviar Magic Link`.
3. Abrir el correo en ese mismo dispositivo y tocar el enlace.
4. Verificar:
   - La app se abre.
   - Se completa sesion.
   - Se muestra `TeamSelectScreen`.
5. Elegir un equipo y cerrar/reabrir app.
6. Verificar que el equipo favorito permanece guardado.

## Respuesta a incidente de clave API

Si recibes alerta de exposicion de API key:

1. En Google Cloud Console -> Credentials, rota la clave comprometida.
2. Aplica restricciones:
   - Application restrictions:
     - Android: package `com.example.app` + SHA-1/SHA-256.
     - iOS: bundle id `com.example.app`.
   - API restrictions: limitar a APIs necesarias de Firebase.
3. Revisa uso y billing del proyecto para detectar abuso.
4. Actualiza valores locales y ejecuta app con nuevos `--dart-define`.
5. Verifica que archivos de credenciales esten fuera de git (`.gitignore`).
## Referencias del proyecto

- Especificacion funcional: `../SPEC.md`
- Backlog por fases: `../BACKLOG.md`
- Distribucion local comunitaria: `../LOCAL_DISTRIBUTION.md`
