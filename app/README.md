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
flutter run
```

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

## Referencias del proyecto

- Especificacion funcional: `../SPEC.md`
- Backlog por fases: `../BACKLOG.md`
- Distribucion local comunitaria: `../LOCAL_DISTRIBUTION.md`
