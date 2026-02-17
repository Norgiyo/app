# 1Cup Local Distribution Playbook

Fecha: 2026-02-17  
Alcance: despliegue local comunitario (sin Google Play / App Store)

## 1. Objetivo

Definir un proceso simple y repetible para:
- generar builds
- distribuir a usuarios de la comunidad
- actualizar versiones
- responder ante fallos

## 2. Canales de entrega recomendados

- Android: APK firmado compartido por canal comunitario (WhatsApp/Telegram/Drive local).
- iOS: distribucion privada solo si existe infraestructura Apple (ad hoc/TestFlight); si no, enfocar Android inicialmente.

## 3. Flujo de release (Android)

1. Preparar version:
- actualizar version en `app/pubspec.yaml`.
- registrar cambios en un changelog corto interno.

2. Validar calidad minima:
- `cd app`
- `flutter analyze`
- `flutter test`

3. Generar build:
- `flutter build apk --release`

4. Verificar artefacto:
- archivo esperado: `app/build/app/outputs/flutter-apk/app-release.apk`.
- instalar en al menos 2 dispositivos reales antes de distribuir.

5. Publicar en comunidad:
- compartir APK + mensaje con:
- version
- fecha
- cambios principales
- instrucciones de instalacion

## 4. Proceso de actualizacion

- mantener una sola version activa recomendada.
- comunicar si la actualizacion es obligatoria o sugerida.
- conservar como minimo la version anterior para rollback rapido.

## 5. Soporte operativo minimo

- canal unico de soporte para reportes (ej. grupo Telegram/WhatsApp).
- formato minimo de reporte:
- version instalada
- dispositivo
- pasos para reproducir
- captura o log si aplica

## 6. Rollback local

Condiciones de rollback:
- bug critico de login
- bug critico de saldo/picks
- crash recurrente

Pasos:
1. pausar distribucion de la version defectuosa.
2. reenviar APK de version estable anterior.
3. avisar claramente en el canal comunitario.
4. abrir ticket de causa raiz y correccion.

## 7. Checklist por release

- [ ] Version actualizada en `app/pubspec.yaml`
- [ ] `flutter analyze` sin errores bloqueantes
- [ ] `flutter test` ejecutado
- [ ] APK release generado
- [ ] Smoke test en dispositivos reales
- [ ] Mensaje de publicacion preparado
- [ ] Plan de rollback listo

## 8. Convenciones sugeridas

- nombrar APK con version y fecha (si se renombra manualmente).
- ejemplo: `1cup-v0.3.0-2026-02-17.apk`
- guardar historico de ultimas 3 versiones publicadas.
