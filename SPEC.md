# 1Cup - Product and Technical Spec

Version: 2.1 (documento canonico)  
Fecha: 2026-02-17  
Estado: Draft operativo

Basado en:
- Skills locales en `.agents/skills`:
- `flutter-architecture`
- `firebase-auth`
- `firebase-firestore`
- Operacion y distribucion local: `LOCAL_DISTRIBUTION.md`
---

## 1. Resumen ejecutivo

1Cup es una app de predicciones deportivas con monedas virtuales, enfoque en equipos y retencion por gamificacion.

Principios del producto:
- Control operativo interno (sin dependencia de APIs externas para resultados).
- Flujo seguro de publicacion de resultados: `Draft -> Admin Review -> Publish`.
- Procesamiento financiero atomico con auditoria y rollback.

---

## 2. Objetivo del MVP

Entregar un MVP funcional y seguro con:
1. Autenticacion (Google + Email Link).
2. Perfil de usuario con balance y equipo favorito.
3. Exploracion de jugadores/equipos.
4. Creacion de picks y cierre automatico por estado del partido.
5. Publicacion de resultados con payout optimizado.

Fuera de MVP inicial:
- Monetizacion real avanzada.
- Automatizaciones no criticas de growth.
- Features de polish no bloqueantes.

---

## 3. Stack tecnico objetivo

- App: Flutter 3.x + Dart 3.x
- Arquitectura app: feature-first + MVVM
- Estado/navegacion: Riverpod + go_router
- Red/cache: Dio + Hive
- Backend: Firebase (Auth, Firestore, Functions, Storage, FCM)
- Functions runtime: Node.js 24
- Observabilidad: Crashlytics + Sentry
- Analitica: Firebase Analytics + BigQuery export

Notas de skills:
- `firebase-auth`: mensajes de error de credenciales no deben revelar enumeracion.
- `firebase-firestore`: reglas restrictivas y validacion server-side para operaciones sensibles.
- `flutter-architecture`: separar por features y capas (`presentation/data/domain`).

---

## 4. Arquitectura del sistema

## 4.1 Capas

1. App Flutter
- UI, estado, validaciones de entrada, cache local.

2. Firebase Auth
- Google Sign-In, Email Link, claims por rol.

3. Firestore
- Fuente principal de datos transaccionales y operativos.

4. Cloud Functions
- Logica critica: payout, rewards, ranking, rollback, cron jobs.

5. Storage
- Logos, fotos y snapshots operativos.

6. Analytics + BigQuery
- KPIs de negocio y analitica historica.

## 4.2 Flujo operativo principal

1. Sistema abre jornada (`scheduled`).
2. Usuario crea pick (saldo se descuenta al crear).
3. Match pasa a `live`; picks se cierran.
4. Operador carga stats en `draft`.
5. Admin revisa impacto.
6. Admin publica (`publishMatch`), se ejecuta payout.
7. Se notifican resultados por FCM.
8. Jobs nocturnos actualizan ranking y snapshots.

---

## 5. Arquitectura Flutter (skill: flutter-architecture)

Estructura objetivo:

```text
app/lib/
  main.dart
  features/
    auth/
      data/
      domain/        # opcional
      presentation/
    home/
      data/
      domain/
      presentation/
    picks/
      data/
      domain/
      presentation/
    profile/
      data/
      domain/
      presentation/
    ranking/
      data/
      domain/
      presentation/
  shared/
    core/
    data/
    ui/
```

Reglas de arquitectura:
- View no llama servicios externos directos.
- ViewModel coordina casos de uso/repositorios.
- Repositorio es fuente de verdad de cada tipo de dato.
- Servicios son stateless.

---

## 6. Roles y permisos

Roles:
- `user`
- `operator`
- `admin`
- `superadmin`

Responsabilidades:
- `user`: uso normal de app.
- `operator`: carga stats y manejo de drafts.
- `admin`: publicacion de resultados y gestion operativa.
- `superadmin`: rollback critico, roles, configuraciones globales.

Control de acceso:
- Claims en Firebase Auth.
- Verificacion de claims en Cloud Functions.
- Rules Firestore con minimo privilegio.

---

## 7. Modelo de datos Firestore

Colecciones base:

## `users/{uid}`
- `displayName`, `email`, `balance`, `shields`, `tickets`
- `favoriteTeamId`, `streakDays`, `lastLoginDate`, `weekPoints`
- `isPublicProfile`, `successRate`, `role`, `createdAt`

## `teams/{teamId}`
- `name`, `logoURL`, `isActive`

## `players/{playerId}`
- `teamId`, `name`, `position`, `photoURL`, `isActive`, `odds`
- badges: `badgeHot`, `badgeCold`, `badgeGoat`, `badgeVolume`
- trazabilidad: `editedBy`, `editedAt`

## `matches/{matchId}`
- `date`, `homeTeamId`, `awayTeamId`, `homeScore`, `awayScore`
- `status`, `isDraft`, `processed`, `publishedAt`, `publishedBy`

## `matches/{matchId}/picks/{pickId}`
- `userId`, `playerId`, `amount`, `odds`, `potentialPayout`
- `status`, `createdAt`, `resolvedAt`

## `transactions/{txId}`
- `userId`, `type`, `amount`, `balanceAfter`, `relatedId`, `createdAt`

## `raffles/{raffleId}`
- `title`, `ticketCost`, `endDate`, `status`, `winnerId`, `totalEntries`

## `raffles/{raffleId}/participants/{uid}`
- participante por documento (no arrays masivos).

## `teamWeeks/{weekId_teamId}`
- `teamId`, `weekId`, `points`, `activeFans`, `bonusGiven`, `lastUpdated`

## `auditLogs/{logId}`
- `actorUid`, `actorRole`, `action`, `entityType`, `entityId`, `diff`, `createdAt`

---

## 8. Seguridad y reglas Firestore (skill: firebase-firestore)

Lineamientos minimos:
1. Default deny.
2. `users/{uid}`:
- read solo owner.
- write directo limitado; operaciones sensibles por Functions.
3. `matches/*`:
- lectura autenticada.
- escritura solo backend/admin.
4. `picks`:
- create solo owner autenticado.
- update/delete bloqueados para cliente.
5. `auditLogs`:
- lectura solo roles administrativos.

Controles criticos:
- Idempotencia en payout con `match.processed`.
- Writes atomicos (batch/transaction).
- Validacion de input en Functions.

---

## 9. Indices compuestos requeridos

Minimos operativos:
1. `matches/{id}/picks`: `userId ASC`, `createdAt DESC`
2. `matches/{id}/picks`: `userId ASC`, `status ASC`, `createdAt DESC`
3. `transactions`: `userId ASC`, `createdAt DESC`
4. `transactions`: `userId ASC`, `type ASC`, `createdAt DESC`
5. `matches`: `status ASC`, `date ASC`
6. `players`: `teamId ASC`, `isActive ASC`
7. `teamWeeks`: `weekId ASC`, `points DESC`
8. `auditLogs`: `actorUid ASC`, `createdAt DESC`

---

## 10. Modulos funcionales

## 10.1 Picks
- Limites por jornada configurables.
- Descuento de saldo al crear pick.
- Cierre automatico al pasar match a `live`.
- Draft y review antes de publicar resultados.

## 10.2 Monedas y transacciones
Tipos de transaccion:
- `initial`, `bet`, `payout`, `daily_reward`, `team_reward`
- `shield_used`, `refund`, `ranking_bonus`, `copy_commission`

## 10.3 Escudo (opcion C)
- Se activa solo si la perdida supera umbral configurable.
- Si aplica escudo: evita penalizacion y consume 1 escudo.

## 10.4 Ranking por equipos
- Ranking de equipos (no personas).
- Bonus a fans activos de top semanal.
- Reset semanal con archivo historico.

## 10.5 Tipsters con limites
- Cap de seguidores.
- Maximo de replicas por jornada.
- Cooldown por bajo rendimiento.
- Cap de comision por jornada.

---

## 11. Payout masivo optimizado (modulo critico)

Algoritmo obligatorio:
1. Leer picks `pending` del partido en una pasada.
2. Resolver resultados en memoria.
3. Agrupar deltas por usuario.
4. Escribir en batches (max 499 ops por batch).
5. Por usuario: 1 update de balance + 1 transaction agregada.
6. Marcar `match.processed = true`.
7. Generar audit log y disparar notificaciones.

Configuracion recomendada Function:
- `timeoutSeconds: 540`
- `memory: 512MB`
- `minInstances: 1`

---

## 12. Notificaciones, cron y observabilidad

## 12.1 FCM
Eventos:
- resultados publicados,
- pick ganado/perdido,
- reward por equipo,
- escudo activado,
- cierre ranking,
- recordatorio de racha.

## 12.2 Cron jobs
- Cada 5 min: cerrar picks de matches ya iniciados.
- Diario: rewards y validaciones de racha.
- Semanal: cierre ranking y bonus.
- Pre-jornada: snapshot de balances.
- Diario: recalculo de tipsters.
- Mensual: archivado de transacciones antiguas.

## 12.3 KPIs
- DAU/MAU y retencion D1/D7/D30.
- Picks por jornada y win rate.
- Escudos usados por jornada.
- Monedas en circulacion.
- Fans activos por equipo.
- Tasa de copia a tipsters.

---

## 13. Costos y escalabilidad

Escenario objetivo: hasta 100k usuarios con picos de concurrencia en publish.

Puntos de costo relevantes:
- Firestore reads/writes masivos.
- Storage egress.
- Functions en procesos de cierre.

Estrategias de control:
- Cache agresivo en app (Hive/offline).
- Paginacion estricta.
- Archivado de historicos.
- Budget alerts (50/80/100).
- Revision semanal de uso Firebase.

---

## 14. Roadmap por fases

F0 Fundaciones:
- Estructura base, emuladores, CI.

F1 Auth + balance:
- Login Google, perfil base, saldo inicial e historial.

F2 Jugadores + equipos:
- Seed data, cards, cache offline.

F3 Picks + partidos:
- Creacion picks, validaciones, cierre automatico.

F4 Operador + payout:
- Panel web, publish, payout optimizado, logs.

F5 Magic link + equipo favorito:
- Passwordless, onboarding por equipo.

F6 Escudo + ranking:
- Escudo opcion C y ranking semanal.

F7 Tipsters + sorteos:
- Replicas con limites y sorteo seguro.

F8 Polish + launch:
- Hardening, QA, load test y despliegue local en comunidad.

---

## 15. Riesgos y mitigaciones

1. Payout sin optimizar.
- Mitigacion: agrupacion por usuario + pruebas de carga.

2. Inconsistencia financiera.
- Mitigacion: idempotencia + batch atomico + rollback.

3. Documento sobredimensionado en sorteos.
- Mitigacion: subcoleccion `participants`.

4. Efecto cascada tipsters.
- Mitigacion: limites, cooldown y caps.

5. Costos fuera de control.
- Mitigacion: budget alerts + cache + paginacion.

6. Cold starts en rutas criticas.
- Mitigacion: `minInstances` en funciones clave.

7. Indices faltantes.
- Mitigacion: definir y desplegar antes de release.

---

## 16. Estado del repo actual vs esta especificacion

Brechas confirmadas hoy:
1. Auth actual usa email/password temporal; no Google + email link.
2. Team selection no persiste `favoriteTeamId`.
3. No existe `firestore.rules` en la raiz.
4. `functions/src/index.ts` aun sin modulos de negocio.
5. `widget_test.dart` desalineado con UI real.
6. Hay texto con encoding incorrecto en pantallas actuales.

---

## 17. Checklist inmediato

1. Crear `firestore.rules` base y probar en emulator.
2. Implementar auth objetivo (Google + Email Link).
3. Persistir `favoriteTeamId` en onboarding.
4. Reemplazar test legacy por tests de flujos reales.
5. Definir primer set de indices compuestos y deploy.
6. Preparar Function `publishMatch` con idempotencia desde el inicio.



