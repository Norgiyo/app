# 1Cup Backlog de Implementacion (F0-F8)

Fecha de corte: 2026-02-17  
Fuente: `SPEC.md` + skills `.agents/skills` (`flutter-architecture`, `firebase-auth`, `firebase-firestore`)

---

## Reglas del backlog

1. Cada ticket debe cerrarse con evidencia tecnica (PR, tests, logs o capturas).
2. Ningun ticket que toque datos o dinero se aprueba sin validacion de seguridad.
3. Todo ticket de Cloud Functions debe incluir manejo de error e idempotencia cuando aplique.

Estados sugeridos:
- `TODO`
- `IN PROGRESS`
- `BLOCKED`
- `DONE`

Prioridad sugerida:
- `P0` critico
- `P1` alto
- `P2` medio

---

## F0 - Fundaciones

### F0-01 - Estructura Flutter feature-first + MVVM
- Prioridad: `P0`
- Dependencias: ninguna
- Entregable: estructura base en `app/lib/features` y `app/lib/shared`
- Criterios de aceptacion:
- existe arbol `features/{auth,home,picks,profile,ranking}`
- existe `shared/{core,data,ui}`
- no quedan nuevas pantallas en raiz de `app/lib` salvo `main.dart`

### F0-02 - Config Firebase local + emuladores
- Prioridad: `P0`
- Dependencias: F0-01
- Entregable: proyecto configurado para Auth/Firestore/Functions emulator
- Criterios de aceptacion:
- script/documentacion para levantar emuladores
- app conecta a emuladores en modo dev
- prueba manual de lectura/escritura local completada

### F0-03 - Reglas Firestore base + indices iniciales
- Prioridad: `P0`
- Dependencias: F0-02
- Entregable: `firestore.rules` y `firestore.indexes.json` operativos
- Criterios de aceptacion:
- reglas en default deny
- `users`, `matches`, `picks`, `auditLogs` con permisos minimos
- deploy de rules/indexes exitoso en entorno de prueba

### F0-04 - CI minima de calidad
- Prioridad: `P1`
- Dependencias: F0-01
- Entregable: pipeline con lint y test en PR
- Criterios de aceptacion:
- job de `flutter analyze`
- job de `flutter test`
- fallo de quality gate bloquea merge

---

## F1 - Auth + Balance

### F1-01 - Auth Google Sign-In en Flutter
- Prioridad: `P0`
- Dependencias: F0-02
- Entregable: login Google funcional
- Criterios de aceptacion:
- usuario puede iniciar/cerrar sesion
- manejo de errores de popup/cancelacion sin crash
- sesion persiste al reabrir app

### F1-02 - Auth Email Link (passwordless)
- Prioridad: `P0`
- Dependencias: F0-02
- Entregable: envio y consumo de magic link
- Criterios de aceptacion:
- envio de enlace al correo funciona
- deep link retorna sesion valida
- rate limit operativo para abuso basico

### F1-03 - Bootstrap de perfil y balance inicial
- Prioridad: `P0`
- Dependencias: F1-01
- Entregable: creacion automatica de `users/{uid}` + transaccion `initial`
- Criterios de aceptacion:
- on-create crea `balance` inicial
- se registra `transactions` tipo `initial`
- no hay duplicados en reintentos

### F1-04 - UI de perfil base + historial de transacciones
- Prioridad: `P1`
- Dependencias: F1-03
- Entregable: pantalla con balance y ultimas transacciones paginadas
- Criterios de aceptacion:
- historial paginado con cursor
- estados de loading/empty/error visibles
- pruebas widget basicas de render y paginacion

---

## F2 - Jugadores + Equipos

### F2-01 - Seed inicial de equipos y jugadores
- Prioridad: `P1`
- Dependencias: F0-03
- Entregable: script de seed idempotente
- Criterios de aceptacion:
- carga de `teams` y `players` sin duplicar
- campos minimos de spec presentes
- ejecucion repetida no rompe datos

### F2-02 - Repositorio de lectura players/teams con cache
- Prioridad: `P1`
- Dependencias: F2-01
- Entregable: capa `data` con cache local (Hive)
- Criterios de aceptacion:
- primera carga desde Firestore y siguientes desde cache
- soporte modo offline para lectura reciente
- invalidacion de cache definida

### F2-03 - Pantalla explorar jugadores
- Prioridad: `P1`
- Dependencias: F2-02
- Entregable: listado con cards y filtros basicos
- Criterios de aceptacion:
- muestra nombre, equipo, posicion, odds y badges
- filtro por equipo activo
- manejo de loading/empty/error

### F2-04 - Tests de repositorio y widget de lista
- Prioridad: `P2`
- Dependencias: F2-03
- Entregable: cobertura minima en lectura de jugadores
- Criterios de aceptacion:
- unit test del repositorio
- widget test de lista y filtros
- cobertura reportada en CI

---

## F3 - Picks + Partidos

### F3-01 - Cloud Function `createPick`
- Prioridad: `P0`
- Dependencias: F1-03, F2-01
- Entregable: funcion callable para crear pick seguro
- Criterios de aceptacion:
- valida saldo, limites y estado del partido
- crea transaccion `bet` atomica con descuento
- rechaza requests invalidos con codigo controlado

### F3-02 - UI de creacion de pick
- Prioridad: `P1`
- Dependencias: F3-01
- Entregable: flujo en app para apostar con validacion local
- Criterios de aceptacion:
- calcula payout potencial en tiempo real
- bloquea montos invalidos
- confirma resultado de la operacion al usuario

### F3-03 - Job de cierre automatico de picks
- Prioridad: `P1`
- Dependencias: F3-01
- Entregable: scheduler que cierra picks al iniciar match
- Criterios de aceptacion:
- partidos vencidos pasan a estado cerrado para picks
- idempotencia en ejecuciones repetidas
- logs de ejecucion disponibles

### F3-04 - Pantalla Mis Picks
- Prioridad: `P1`
- Dependencias: F3-02
- Entregable: vista con filtros por estado
- Criterios de aceptacion:
- filtros `pending/won/lost/cancelled`
- orden por fecha descendente
- paginacion funcional

---

## F4 - Operador + Payout

### F4-01 - Panel operador/admin (web) minimo viable
- Prioridad: `P1`
- Dependencias: F1-01
- Entregable: panel con auth por rol y lista de matches
- Criterios de aceptacion:
- operador solo ve acciones permitidas
- admin ve acciones de publicacion
- superadmin puede acceder a herramientas criticas

### F4-02 - Flujo Draft -> Review -> Publish
- Prioridad: `P0`
- Dependencias: F4-01
- Entregable: estados operativos del partido con validaciones
- Criterios de aceptacion:
- stats se guardan como draft
- admin puede previsualizar impacto
- publish exige permisos de admin

### F4-03 - Cloud Function `publishMatch` optimizada
- Prioridad: `P0`
- Dependencias: F4-02
- Entregable: payout agrupado por usuario con idempotencia
- Criterios de aceptacion:
- aplica algoritmo de agregacion por usuario
- actualiza picks + balances + transactions en batches seguros
- `match.processed` impide doble pago

### F4-04 - Auditoria y notificaciones de resultados
- Prioridad: `P1`
- Dependencias: F4-03
- Entregable: `auditLogs` + FCM post-publish
- Criterios de aceptacion:
- audit log registra before/after y actor
- usuarios afectados reciben notificacion
- errores de envio quedan trazados

---

## F5 - Magic Link + Equipo Favorito

### F5-01 - Deep links moviles para Email Link
- Prioridad: `P0`
- Dependencias: F1-02
- Entregable: configuracion de enlaces en Android/iOS
- Criterios de aceptacion:
- abrir enlace autentica en app instalada
- fallback web/documentado para casos sin app
- flujo probado en ambos sistemas

### F5-02 - Onboarding de equipo favorito
- Prioridad: `P0`
- Dependencias: F2-01, F1-03
- Entregable: seleccion obligatoria para usuario sin equipo
- Criterios de aceptacion:
- lista solo equipos `isActive`
- guarda `favoriteTeamId` en `users/{uid}`
- no repite onboarding si ya existe equipo

### F5-03 - Reglas de acceso para perfil y team select
- Prioridad: `P1`
- Dependencias: F5-02, F0-03
- Entregable: endurecimiento de rules segun flujo real
- Criterios de aceptacion:
- usuario solo edita su perfil permitido
- campos sensibles protegidos para backend
- pruebas en emulator cubren denegaciones

---

## F6 - Escudo + Ranking

### F6-01 - Implementar Escudo Opcion C
- Prioridad: `P1`
- Dependencias: F4-03
- Entregable: aplicacion de escudo por umbral
- Criterios de aceptacion:
- consume escudo solo cuando corresponde
- crea transaccion `shield_used` o `team_reward`
- operacion atomica en un commit

### F6-02 - Agregacion semanal `teamWeeks`
- Prioridad: `P1`
- Dependencias: F5-02
- Entregable: calculo de puntos por equipo/fans activos
- Criterios de aceptacion:
- puntos actualizan por eventos definidos
- documento semanal por equipo consistente
- se registra timestamp de actualizacion

### F6-03 - Cierre semanal y bonus top 3
- Prioridad: `P1`
- Dependencias: F6-02
- Entregable: scheduler dominical de cierre
- Criterios de aceptacion:
- calcula top 3 equipos
- reparte bonus solo a fans activos
- resetea estado semanal sin perder historico

### F6-04 - UI ranking de equipos
- Prioridad: `P2`
- Dependencias: F6-03
- Entregable: pantalla ranking con contribucion personal
- Criterios de aceptacion:
- tabla completa de equipos
- indicador de posicion del equipo favorito del usuario
- refresco sin bloqueos visibles

---

## F7 - Tipsters + Sorteos

### F7-01 - Perfil tipster y metricas de rendimiento
- Prioridad: `P1`
- Dependencias: F4-03
- Entregable: campos y calculo de `successRate`
- Criterios de aceptacion:
- `successRate` actualizado por jornada
- `isPublicProfile` configurable por usuario
- lectura segura de perfil publico

### F7-02 - Replicacion con limites anti-cascada
- Prioridad: `P0`
- Dependencias: F7-01
- Entregable: funcion de replicacion con restricciones
- Criterios de aceptacion:
- limite de seguidores aplicado
- maximo de replica por jornada aplicado
- cooldown por bajo rendimiento aplicado

### F7-03 - Sorteos con participants en subcoleccion
- Prioridad: `P1`
- Dependencias: F1-03
- Entregable: modelo de raffles sin arrays gigantes
- Criterios de aceptacion:
- entries se guardan en `participants/{uid}`
- contador total consistente
- sin riesgo de limite 1MB por documento

### F7-04 - Funcion `drawRaffle` segura
- Prioridad: `P1`
- Dependencias: F7-03
- Entregable: seleccion de ganador trazable
- Criterios de aceptacion:
- ganador pertenece a participantes validos
- write final incluye estado y winnerId
- audit log generado para sorteo

---

## F8 - Polish + Launch

### F8-01 - Hardening de seguridad final
- Prioridad: `P0`
- Dependencias: fases F0-F7
- Entregable: App Check, rules finales, validaciones cerradas
- Criterios de aceptacion:
- App Check habilitado en produccion
- rules revisadas y sin permisos abiertos
- checklist de seguridad firmado

### F8-02 - Pruebas de carga y resiliencia
- Prioridad: `P0`
- Dependencias: F4-03
- Entregable: reporte de stress test y tuning
- Criterios de aceptacion:
- prueba de picks concurrentes ejecutada
- publish masivo dentro de SLA definido
- no hay inconsistencias de balance

### F8-03 - Observabilidad y control de costos
- Prioridad: `P1`
- Dependencias: F8-01
- Entregable: dashboards, alertas y runbooks
- Criterios de aceptacion:
- alertas de budget 50/80/100 activas
- alertas de errores criticos activas
- dashboard KPI minimo operativo

### F8-04 - Despliegue local comunitario
- Prioridad: `P1`
- Dependencias: F8-02, F8-03
- Entregable: despliegue local estable con operacion comunitaria
- Criterios de aceptacion:
- piloto local con usuarios reales ejecutado
- bugs criticos de flujo principal cerrados
- plan operativo local documentado (soporte, monitoreo y rollback)

---

## Orden de ejecucion sugerido

1. F0
2. F1
3. F2
4. F3
5. F4
6. F5
7. F6
8. F7
9. F8
