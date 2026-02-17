# Auditoria del Proyecto 1Cup

**Fecha de auditoria:** 2026-02-17  
**Version del proyecto:** MVP (fase inicial con avances puntuales)

---

## 1. Resumen Ejecutivo

El proyecto **1Cup** es una app Flutter con Firebase que esta en etapa temprana, pero ya tiene implementaciones iniciales del flujo de acceso y seleccion de equipo.

### Estado general: En desarrollo inicial con funcionalidad parcial

### Alcance de distribucion
- El objetivo operativo actual es **despliegue local en comunidad**.
- No se contempla publicacion en Google Play ni App Store en esta etapa.

---

## 2. Estructura Real del Proyecto

```
1cup/
|- app/                              # Aplicacion Flutter
|  |- lib/
|  |  |- main.dart                   # Entrada de app y boot Firebase
|  |  |- firebase_options.dart       # Configuracion Firebase (Android/iOS)
|  |  |- login_screen.dart           # Login/registro email+password
|  |  `- team_select_screen.dart     # Lista de equipos desde Firestore
|  |- test/
|  |  `- widget_test.dart            # Test por defecto (desalineado)
|  |- android/
|  |- ios/
|  |- web/
|  |- macos/
|  |- windows/
|  |- linux/
|  `- pubspec.yaml
|- functions/                        # Cloud Functions (TypeScript)
|  |- src/
|  |  `- index.ts                    # Solo config global, sin funciones exportadas
|  `- package.json
`- firestore.indexes.json            # Indexes vacios
```

---

## 3. Analisis por Componente

### 3.1 App Flutter (`/app`)

#### Lo implementado
| Aspecto | Estado | Detalle |
|---------|--------|---------|
| Inicializacion Firebase | Completo | `main.dart` inicializa Firebase antes de `runApp` |
| Pantalla de login | Parcial | Login y auto-registro con email/password |
| Seleccion de equipo | Parcial | Lee equipos activos de Firestore y permite seleccion local |
| Navegacion base | Completo | Login -> seleccion de equipo |

#### Lo faltante para MVP esperado
| Funcionalidad | Prioridad | Estado |
|---------------|-----------|--------|
| Login Google | Alta | No implementado |
| Login email link (magic link) | Alta | No implementado |
| Persistir equipo favorito por usuario | Alta | No implementado |
| Home con lista de jugadores | Alta | No implementado |
| Perfil de usuario | Media | No implementado |
| Estructura por features | Media | No implementado |

#### Problemas identificados
1. **Test desalineado**: `widget_test.dart` sigue validando contador y boton `+`, pero la app actual no usa esa UI.
2. **MVP de auth incompleto**: se usa email/password temporal, no Google + email link.
3. **Seleccion de equipo no persistida**: hoy solo muestra `SnackBar`, no guarda en perfil.

---

### 3.2 Cloud Functions (`/functions`)

#### Lo implementado
| Aspecto | Estado | Detalle |
|---------|--------|---------|
| TypeScript configurado | Completo | `tsconfig` presente |
| ESLint configurado | Completo | Reglas Google + TypeScript |
| Control de costos | Completo | `setGlobalOptions({ maxInstances: 10 })` |

#### Lo faltante
| Funcionalidad | Prioridad | Estado |
|---------------|-----------|--------|
| Funciones HTTP/callable de negocio | Alta | No implementadas |
| Capa de dominio/backend | Alta | No implementada |
| Tests de funciones | Media | No implementados |

#### Estado actual
- `functions/src/index.ts` no exporta funciones activas.
- No hay endpoints backend propios del proyecto listos para deploy.

---

### 3.3 Configuracion Firebase

| Aspecto | Estado | Observacion |
|---------|--------|-------------|
| `firebase_options.dart` | Parcial | Configurado solo para Android/iOS |
| Soporte Web/macOS/Windows/Linux | No configurado | Lanza `UnsupportedError` |
| Firestore indexes | Vacio | `indexes: []`, `fieldOverrides: []` |
| Firestore rules | Ausente | No existe `firestore.rules` en raiz |

---

## 4. Dependencias y Versiones

### Flutter (`app/pubspec.yaml`)
- `sdk: ^3.11.0`
- `firebase_core: ^4.4.0`
- `firebase_auth: ^6.1.4`
- `cloud_firestore: ^6.1.2`
- `flutter_lints: ^6.0.0`

### Functions (`functions/package.json`)
- `engines.node: "24"`
- `firebase-admin: ^13.6.0`
- `firebase-functions: ^7.0.0`

### Observaciones
- El proyecto usa versiones recientes de Firebase en app y functions.
- No se ejecuto una auditoria de desactualizacion (`outdated`) en esta revision.
- Conviene validar compatibilidad exacta de Node `24` con el entorno de deploy objetivo.

---

## 5. Cumplimiento MVP (estado actual)

> Nota: En el estado actual del repo si existe `SPEC.md` en raiz (v2.1, fecha 2026-02-17), y debe usarse como referencia principal de alcance.

| Requisito MVP | Estado | % estimado |
|---------------|--------|------------|
| Login (Google + email link) | Parcial (email/password temporal) | 30% |
| Seleccion de equipo favorito | Parcial (sin persistencia) | 40% |
| Home: lista de jugadores | No iniciado | 0% |
| Perfil: equipo y balance | No iniciado | 0% |
| Estructura limpia por features | No iniciado | 0% |

---

## 6. Calidad de Codigo

### Flutter
| Metrica | Estado | Comentario |
|---------|--------|------------|
| Linting | Configurado | `flutter_lints` activo |
| Estructura modular | Basica | Aun no separada por features |
| Tests widget | Deficiente | Test legacy no representa la app real |
| Manejo de errores auth | Basico | Casos principales cubiertos, faltan mensajes detallados |

### TypeScript/Functions
| Metrica | Estado | Comentario |
|---------|--------|------------|
| ESLint | Configurado | Base correcta |
| TypeScript strict | Activado | Correcto |
| Tests | Ausentes | Sin cobertura automatizada |

---

## 7. Seguridad

| Aspecto | Estado | Comentario |
|---------|--------|------------|
| Reglas Firestore | Critico | No hay archivo `firestore.rules` |
| Claves Firebase cliente | Esperado | Estan embebidas en app cliente (normal en Firebase) |
| Endurecimiento adicional (App Check, validaciones server) | Pendiente | Recomendado cuando avance el MVP |

### Advertencia clave
La ausencia de reglas de Firestore es el principal riesgo de seguridad actual. Debe resolverse antes de exponer datos reales.

---

## 8. Recomendaciones

### Prioridad alta (inmediato)
1. Crear `firestore.rules` con politica minima de acceso por usuario autenticado.
2. Reemplazar test legacy por tests de `LoginScreen` y `TeamSelectScreen`.
3. Completar flujo de auth objetivo (Google + email link) o documentar oficialmente el cambio de alcance.
4. Persistir equipo favorito del usuario en Firestore.

### Prioridad media (corto plazo)
5. Implementar Home con listado de jugadores y estado vacio/carga/error.
6. Introducir estructura por features (`auth`, `team`, `home`, `profile`).
7. Definir y versionar contrato funcional del MVP en un `SPEC.md` vigente.
8. Crear primeras funciones backend solo si hay logica sensible que no deba vivir en cliente.

### Prioridad baja (mejora continua)
9. Agregar CI para lint + tests.
10. Revisar soporte multiplataforma Firebase (web/desktop) segun roadmap real.
11. Agregar observabilidad minima (logs y trazas de errores de usuario).
12. Documentar paquete de distribucion local (APK/instalador), canal de entrega comunitario y proceso de actualizaciones manuales.

---

## 9. Metricas del Proyecto (estimadas sobre codigo propio visible)

- Flutter (`main.dart`, `login_screen.dart`, `team_select_screen.dart`): **192 lineas**
- Functions (`functions/src/index.ts`): **32 lineas**
- Tests (`app/test/widget_test.dart`): **30 lineas** (desalineados)
- Cobertura efectiva de tests: **muy baja / no representativa**

---

## 10. Conclusion

El proyecto ya no esta en "0% funcional". Tiene una base ejecutable con:
- Inicializacion Firebase
- Login/registro temporal por email/password
- Lectura de equipos activos desde Firestore

Sin embargo, el MVP objetivo sigue mayormente pendiente por falta de:
- auth final (Google + email link),
- persistencia de seleccion de equipo,
- Home/Perfil,
- reglas de seguridad de Firestore,
- y cobertura de tests util.

### Siguiente paso recomendado
Cerrar primero el frente de **seguridad + auth MVP** (reglas Firestore y flujo de autenticacion definitivo), y luego avanzar con persistencia de equipo + Home.

Para esta etapa, el release debe enfocarse en **distribucion local comunitaria**, no en publicacion en stores.

---

## Historial de Auditoria

| Fecha | Version | Autor | Cambios |
|-------|---------|-------|---------|
| 2026-02-17 | 1.3 | Auditoria tecnica | Alineacion con estrategia de distribucion local comunitaria (sin stores) |
| 2026-02-17 | 1.2 | Auditoria tecnica | Alineacion documental con `SPEC.md` vigente en raiz |
| 2026-02-17 | 1.1 | Auditoria tecnica | Correccion de estado real del repo y eliminacion de inconsistencias |
| 2026-02-17 | 1.0 | Auditoria automatica | Version inicial |
