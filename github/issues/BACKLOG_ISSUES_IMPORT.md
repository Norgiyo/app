# Import de Issues desde Backlog

Generado automaticamente desde `BACKLOG.md`.

Total de issues: 35

## Lista

### [F0-01] Estructura Flutter feature-first + MVVM
- Labels: backlog,phase:F0,priority:P0
- Prioridad: P0
- Fase: F0

```markdown
## Fase
- F0 - Fundaciones

## Prioridad
- P0

## Dependencias
- ninguna

## Entregable
- estructura base en `app/lib/features` y `app/lib/shared`

## Criterios de aceptacion
- existe arbol `features/{auth,home,picks,profile,ranking}`
- existe `shared/{core,data,ui}`
- no quedan nuevas pantallas en raiz de `app/lib` salvo `main.dart`

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F0-02] Config Firebase local + emuladores
- Labels: backlog,phase:F0,priority:P0
- Prioridad: P0
- Fase: F0

```markdown
## Fase
- F0 - Fundaciones

## Prioridad
- P0

## Dependencias
- F0-01

## Entregable
- proyecto configurado para Auth/Firestore/Functions emulator

## Criterios de aceptacion
- script/documentacion para levantar emuladores
- app conecta a emuladores en modo dev
- prueba manual de lectura/escritura local completada

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F0-03] Reglas Firestore base + indices iniciales
- Labels: backlog,phase:F0,priority:P0
- Prioridad: P0
- Fase: F0

```markdown
## Fase
- F0 - Fundaciones

## Prioridad
- P0

## Dependencias
- F0-02

## Entregable
- `firestore.rules` y `firestore.indexes.json` operativos

## Criterios de aceptacion
- reglas en default deny
- `users`, `matches`, `picks`, `auditLogs` con permisos minimos
- deploy de rules/indexes exitoso en entorno de prueba

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F0-04] CI minima de calidad
- Labels: backlog,phase:F0,priority:P1
- Prioridad: P1
- Fase: F0

```markdown
## Fase
- F0 - Fundaciones

## Prioridad
- P1

## Dependencias
- F0-01

## Entregable
- pipeline con lint y test en PR

## Criterios de aceptacion
- job de `flutter analyze`
- job de `flutter test`
- fallo de quality gate bloquea merge

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F1-01] Auth Google Sign-In en Flutter
- Labels: backlog,phase:F1,priority:P0
- Prioridad: P0
- Fase: F1

```markdown
## Fase
- F1 - Auth + Balance

## Prioridad
- P0

## Dependencias
- F0-02

## Entregable
- login Google funcional

## Criterios de aceptacion
- usuario puede iniciar/cerrar sesion
- manejo de errores de popup/cancelacion sin crash
- sesion persiste al reabrir app

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F1-02] Auth Email Link (passwordless)
- Labels: backlog,phase:F1,priority:P0
- Prioridad: P0
- Fase: F1

```markdown
## Fase
- F1 - Auth + Balance

## Prioridad
- P0

## Dependencias
- F0-02

## Entregable
- envio y consumo de magic link

## Criterios de aceptacion
- envio de enlace al correo funciona
- deep link retorna sesion valida
- rate limit operativo para abuso basico

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F1-03] Bootstrap de perfil y balance inicial
- Labels: backlog,phase:F1,priority:P0
- Prioridad: P0
- Fase: F1

```markdown
## Fase
- F1 - Auth + Balance

## Prioridad
- P0

## Dependencias
- F1-01

## Entregable
- creacion automatica de `users/{uid}` + transaccion `initial`

## Criterios de aceptacion
- on-create crea `balance` inicial
- se registra `transactions` tipo `initial`
- no hay duplicados en reintentos

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F1-04] UI de perfil base + historial de transacciones
- Labels: backlog,phase:F1,priority:P1
- Prioridad: P1
- Fase: F1

```markdown
## Fase
- F1 - Auth + Balance

## Prioridad
- P1

## Dependencias
- F1-03

## Entregable
- pantalla con balance y ultimas transacciones paginadas

## Criterios de aceptacion
- historial paginado con cursor
- estados de loading/empty/error visibles
- pruebas widget basicas de render y paginacion

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F2-01] Seed inicial de equipos y jugadores
- Labels: backlog,phase:F2,priority:P1
- Prioridad: P1
- Fase: F2

```markdown
## Fase
- F2 - Jugadores + Equipos

## Prioridad
- P1

## Dependencias
- F0-03

## Entregable
- script de seed idempotente

## Criterios de aceptacion
- carga de `teams` y `players` sin duplicar
- campos minimos de spec presentes
- ejecucion repetida no rompe datos

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F2-02] Repositorio de lectura players/teams con cache
- Labels: backlog,phase:F2,priority:P1
- Prioridad: P1
- Fase: F2

```markdown
## Fase
- F2 - Jugadores + Equipos

## Prioridad
- P1

## Dependencias
- F2-01

## Entregable
- capa `data` con cache local (Hive)

## Criterios de aceptacion
- primera carga desde Firestore y siguientes desde cache
- soporte modo offline para lectura reciente
- invalidacion de cache definida

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F2-03] Pantalla explorar jugadores
- Labels: backlog,phase:F2,priority:P1
- Prioridad: P1
- Fase: F2

```markdown
## Fase
- F2 - Jugadores + Equipos

## Prioridad
- P1

## Dependencias
- F2-02

## Entregable
- listado con cards y filtros basicos

## Criterios de aceptacion
- muestra nombre, equipo, posicion, odds y badges
- filtro por equipo activo
- manejo de loading/empty/error

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F2-04] Tests de repositorio y widget de lista
- Labels: backlog,phase:F2,priority:P2
- Prioridad: P2
- Fase: F2

```markdown
## Fase
- F2 - Jugadores + Equipos

## Prioridad
- P2

## Dependencias
- F2-03

## Entregable
- cobertura minima en lectura de jugadores

## Criterios de aceptacion
- unit test del repositorio
- widget test de lista y filtros
- cobertura reportada en CI

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F3-01] Cloud Function `createPick`
- Labels: backlog,phase:F3,priority:P0
- Prioridad: P0
- Fase: F3

```markdown
## Fase
- F3 - Picks + Partidos

## Prioridad
- P0

## Dependencias
- F1-03, F2-01

## Entregable
- funcion callable para crear pick seguro

## Criterios de aceptacion
- valida saldo, limites y estado del partido
- crea transaccion `bet` atomica con descuento
- rechaza requests invalidos con codigo controlado

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F3-02] UI de creacion de pick
- Labels: backlog,phase:F3,priority:P1
- Prioridad: P1
- Fase: F3

```markdown
## Fase
- F3 - Picks + Partidos

## Prioridad
- P1

## Dependencias
- F3-01

## Entregable
- flujo en app para apostar con validacion local

## Criterios de aceptacion
- calcula payout potencial en tiempo real
- bloquea montos invalidos
- confirma resultado de la operacion al usuario

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F3-03] Job de cierre automatico de picks
- Labels: backlog,phase:F3,priority:P1
- Prioridad: P1
- Fase: F3

```markdown
## Fase
- F3 - Picks + Partidos

## Prioridad
- P1

## Dependencias
- F3-01

## Entregable
- scheduler que cierra picks al iniciar match

## Criterios de aceptacion
- partidos vencidos pasan a estado cerrado para picks
- idempotencia en ejecuciones repetidas
- logs de ejecucion disponibles

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F3-04] Pantalla Mis Picks
- Labels: backlog,phase:F3,priority:P1
- Prioridad: P1
- Fase: F3

```markdown
## Fase
- F3 - Picks + Partidos

## Prioridad
- P1

## Dependencias
- F3-02

## Entregable
- vista con filtros por estado

## Criterios de aceptacion
- filtros `pending/won/lost/cancelled`
- orden por fecha descendente
- paginacion funcional

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F4-01] Panel operador/admin (web) minimo viable
- Labels: backlog,phase:F4,priority:P1
- Prioridad: P1
- Fase: F4

```markdown
## Fase
- F4 - Operador + Payout

## Prioridad
- P1

## Dependencias
- F1-01

## Entregable
- panel con auth por rol y lista de matches

## Criterios de aceptacion
- operador solo ve acciones permitidas
- admin ve acciones de publicacion
- superadmin puede acceder a herramientas criticas

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F4-02] Flujo Draft -> Review -> Publish
- Labels: backlog,phase:F4,priority:P0
- Prioridad: P0
- Fase: F4

```markdown
## Fase
- F4 - Operador + Payout

## Prioridad
- P0

## Dependencias
- F4-01

## Entregable
- estados operativos del partido con validaciones

## Criterios de aceptacion
- stats se guardan como draft
- admin puede previsualizar impacto
- publish exige permisos de admin

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F4-03] Cloud Function `publishMatch` optimizada
- Labels: backlog,phase:F4,priority:P0
- Prioridad: P0
- Fase: F4

```markdown
## Fase
- F4 - Operador + Payout

## Prioridad
- P0

## Dependencias
- F4-02

## Entregable
- payout agrupado por usuario con idempotencia

## Criterios de aceptacion
- aplica algoritmo de agregacion por usuario
- actualiza picks + balances + transactions en batches seguros
- `match.processed` impide doble pago

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F4-04] Auditoria y notificaciones de resultados
- Labels: backlog,phase:F4,priority:P1
- Prioridad: P1
- Fase: F4

```markdown
## Fase
- F4 - Operador + Payout

## Prioridad
- P1

## Dependencias
- F4-03

## Entregable
- `auditLogs` + FCM post-publish

## Criterios de aceptacion
- audit log registra before/after y actor
- usuarios afectados reciben notificacion
- errores de envio quedan trazados

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F5-01] Deep links moviles para Email Link
- Labels: backlog,phase:F5,priority:P0
- Prioridad: P0
- Fase: F5

```markdown
## Fase
- F5 - Magic Link + Equipo Favorito

## Prioridad
- P0

## Dependencias
- F1-02

## Entregable
- configuracion de enlaces en Android/iOS

## Criterios de aceptacion
- abrir enlace autentica en app instalada
- fallback web/documentado para casos sin app
- flujo probado en ambos sistemas

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F5-02] Onboarding de equipo favorito
- Labels: backlog,phase:F5,priority:P0
- Prioridad: P0
- Fase: F5

```markdown
## Fase
- F5 - Magic Link + Equipo Favorito

## Prioridad
- P0

## Dependencias
- F2-01, F1-03

## Entregable
- seleccion obligatoria para usuario sin equipo

## Criterios de aceptacion
- lista solo equipos `isActive`
- guarda `favoriteTeamId` en `users/{uid}`
- no repite onboarding si ya existe equipo

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F5-03] Reglas de acceso para perfil y team select
- Labels: backlog,phase:F5,priority:P1
- Prioridad: P1
- Fase: F5

```markdown
## Fase
- F5 - Magic Link + Equipo Favorito

## Prioridad
- P1

## Dependencias
- F5-02, F0-03

## Entregable
- endurecimiento de rules segun flujo real

## Criterios de aceptacion
- usuario solo edita su perfil permitido
- campos sensibles protegidos para backend
- pruebas en emulator cubren denegaciones

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F6-01] Implementar Escudo Opcion C
- Labels: backlog,phase:F6,priority:P1
- Prioridad: P1
- Fase: F6

```markdown
## Fase
- F6 - Escudo + Ranking

## Prioridad
- P1

## Dependencias
- F4-03

## Entregable
- aplicacion de escudo por umbral

## Criterios de aceptacion
- consume escudo solo cuando corresponde
- crea transaccion `shield_used` o `team_reward`
- operacion atomica en un commit

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F6-02] Agregacion semanal `teamWeeks`
- Labels: backlog,phase:F6,priority:P1
- Prioridad: P1
- Fase: F6

```markdown
## Fase
- F6 - Escudo + Ranking

## Prioridad
- P1

## Dependencias
- F5-02

## Entregable
- calculo de puntos por equipo/fans activos

## Criterios de aceptacion
- puntos actualizan por eventos definidos
- documento semanal por equipo consistente
- se registra timestamp de actualizacion

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F6-03] Cierre semanal y bonus top 3
- Labels: backlog,phase:F6,priority:P1
- Prioridad: P1
- Fase: F6

```markdown
## Fase
- F6 - Escudo + Ranking

## Prioridad
- P1

## Dependencias
- F6-02

## Entregable
- scheduler dominical de cierre

## Criterios de aceptacion
- calcula top 3 equipos
- reparte bonus solo a fans activos
- resetea estado semanal sin perder historico

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F6-04] UI ranking de equipos
- Labels: backlog,phase:F6,priority:P2
- Prioridad: P2
- Fase: F6

```markdown
## Fase
- F6 - Escudo + Ranking

## Prioridad
- P2

## Dependencias
- F6-03

## Entregable
- pantalla ranking con contribucion personal

## Criterios de aceptacion
- tabla completa de equipos
- indicador de posicion del equipo favorito del usuario
- refresco sin bloqueos visibles

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F7-01] Perfil tipster y metricas de rendimiento
- Labels: backlog,phase:F7,priority:P1
- Prioridad: P1
- Fase: F7

```markdown
## Fase
- F7 - Tipsters + Sorteos

## Prioridad
- P1

## Dependencias
- F4-03

## Entregable
- campos y calculo de `successRate`

## Criterios de aceptacion
- `successRate` actualizado por jornada
- `isPublicProfile` configurable por usuario
- lectura segura de perfil publico

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F7-02] Replicacion con limites anti-cascada
- Labels: backlog,phase:F7,priority:P0
- Prioridad: P0
- Fase: F7

```markdown
## Fase
- F7 - Tipsters + Sorteos

## Prioridad
- P0

## Dependencias
- F7-01

## Entregable
- funcion de replicacion con restricciones

## Criterios de aceptacion
- limite de seguidores aplicado
- maximo de replica por jornada aplicado
- cooldown por bajo rendimiento aplicado

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F7-03] Sorteos con participants en subcoleccion
- Labels: backlog,phase:F7,priority:P1
- Prioridad: P1
- Fase: F7

```markdown
## Fase
- F7 - Tipsters + Sorteos

## Prioridad
- P1

## Dependencias
- F1-03

## Entregable
- modelo de raffles sin arrays gigantes

## Criterios de aceptacion
- entries se guardan en `participants/{uid}`
- contador total consistente
- sin riesgo de limite 1MB por documento

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F7-04] Funcion `drawRaffle` segura
- Labels: backlog,phase:F7,priority:P1
- Prioridad: P1
- Fase: F7

```markdown
## Fase
- F7 - Tipsters + Sorteos

## Prioridad
- P1

## Dependencias
- F7-03

## Entregable
- seleccion de ganador trazable

## Criterios de aceptacion
- ganador pertenece a participantes validos
- write final incluye estado y winnerId
- audit log generado para sorteo

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F8-01] Hardening de seguridad final
- Labels: backlog,phase:F8,priority:P0
- Prioridad: P0
- Fase: F8

```markdown
## Fase
- F8 - Polish + Launch

## Prioridad
- P0

## Dependencias
- fases F0-F7

## Entregable
- App Check, rules finales, validaciones cerradas

## Criterios de aceptacion
- App Check habilitado en produccion
- rules revisadas y sin permisos abiertos
- checklist de seguridad firmado

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F8-02] Pruebas de carga y resiliencia
- Labels: backlog,phase:F8,priority:P0
- Prioridad: P0
- Fase: F8

```markdown
## Fase
- F8 - Polish + Launch

## Prioridad
- P0

## Dependencias
- F4-03

## Entregable
- reporte de stress test y tuning

## Criterios de aceptacion
- prueba de picks concurrentes ejecutada
- publish masivo dentro de SLA definido
- no hay inconsistencias de balance

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F8-03] Observabilidad y control de costos
- Labels: backlog,phase:F8,priority:P1
- Prioridad: P1
- Fase: F8

```markdown
## Fase
- F8 - Polish + Launch

## Prioridad
- P1

## Dependencias
- F8-01

## Entregable
- dashboards, alertas y runbooks

## Criterios de aceptacion
- alertas de budget 50/80/100 activas
- alertas de errores criticos activas
- dashboard KPI minimo operativo

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

### [F8-04] Despliegue local comunitario
- Labels: backlog,phase:F8,priority:P1
- Prioridad: P1
- Fase: F8

```markdown
## Fase
- F8 - Polish + Launch

## Prioridad
- P1

## Dependencias
- F8-02, F8-03

## Entregable
- despliegue local estable con operacion comunitaria

## Criterios de aceptacion
- piloto local con usuarios reales ejecutado
- bugs criticos de flujo principal cerrados
- plan operativo local documentado (soporte, monitoreo y rollback)

## Checklist
- [ ] Implementacion completa
- [ ] Pruebas ejecutadas
- [ ] Documentacion actualizada
```

