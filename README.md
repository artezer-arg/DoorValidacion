# DL06 — Ensamblaje, validación y despacho

Proyecto local Node.js + React. Incluye fuentes TypeScript, compilación lista para ejecutar, esquema SQLite, pruebas y lanzador Windows. No requiere Supabase ni servicios cloud.

## Actualización 1.9.5 — activar SQL desde una demo iniciada

Leer programa y BOM sigue siendo una vista previa. El botón **Activar programa SQL y validar** ahora permite sustituir una DEMO ya iniciada, incluso con paneles terminados o ciclo parcial, siempre que no haya operación en curso. Conserva camión, sets y estado anterior en runtime_archives. Lee nuevamente SQL y valida el programa completo antes de cambiar el objetivo; si falla, la demo se conserva. Un programa SQL iniciado sigue protegido contra sustitución.

Al activar correctamente, la respuesta HTTP actualiza directamente el HMI y vuelve automáticamente a operación; también se emite state-change. La vista previa se etiqueta expresamente y no se confunde con el programa activo. No se requiere borrar SQLite ni reiniciar demo. Compilación y 36 pruebas aprobadas.

## Actualización 1.9.4 — simplificar etapa 4

Se retiraron únicamente el recuadro Destino asignado y la barra de selección numerada 1–8 de la etapa 4. Se conservan el contador del dolly actual, su matriz de seis columnas FR/RR, el camión con los ocho dollys y la asignación automática. Compilación y 34 pruebas aprobadas.

## Actualización 1.9.3 — logo de empresa

Se agregó el logo proporcionado por el usuario a la izquierda del título de la cabecera. Se conservan el archivo original, sus proporciones y fondo blanco. Se incluye en el frontend compilado y funciona sin conexión externa. Compilación y las 34 pruebas existentes aprobadas.

## Actualización 1.9.2 — pantalla de configuración

Rango de secuencias y Programa SQL Server se trasladaron a la pantalla **Configuración**, accesible desde el botón superior. **Volver a operación** muestra nuevamente objetivo, validaciones, dolly y camión. El lector global no procesa escaneos dentro de configuración. Se mantienen las reglas existentes de bloqueo del rango y carga SQL durante un ciclo. Conexión DB sigue accesible mediante Base de datos. Compilación y las 34 pruebas existentes aprobadas.

## Actualización 1.9.1 — restaurar dibujos

Se restauró la vista de camión con los ocho dollys y la matriz del dolly actual: seis columnas, fila FR superior y RR inferior. Se mantiene la barra compacta y el contador. El paso 4 continúa automático, sin botón ni escaneo de confirmación. El pintado sigue la validación y asignación registrada, sin confirmación física. Compilación y 34 pruebas aprobadas.

## Actualización 1.9.0 — ubicación automática y barra compacta

Compilación y 34 pruebas automatizadas aprobadas.

El paso 4 ya no pide escaneo de dolly ni confirmación: después del último componente requerido con PLC OK, registra automáticamente la celda asignada y avanza. Para paneles sin garnish, ocurre al terminar armrest. Un fallo de pieza o PLC no asigna ni avanza. La impresión sigue disparándose cada seis vehículos completos y un fallo de impresora detiene el avance. Un ciclo de la versión anterior guardado en WAITING_DOLLY se termina automáticamente al reiniciar.

La pantalla muestra solo la barra compacta numerada 1–8, verde para dollys completos, ámbar para actual, gris para pendientes, y contador del dolly actual. Se quitaron la matriz de celdas, el botón de confirmar y el dibujo general de camión/dollys. La ubicación nivel/columna sigue informándose en texto y se guarda en SQLite. El color indica validación y asignación lógica automática; no confirma la colocación física mediante sensor.

## Actualización 1.8.0 — fecha solo de la primera secuencia

Elegir la fecha de la primera secuencia y el rango de 24 vehículos. Ejemplo: fecha 18/09/2026, desde 1 hasta 24. Solo la secuencia 1 debe pertenecer al 18/09; la 23 y la 24 pueden tener otra fecha. La lectura se ancla en el primer ID_OrdenProduccion de la secuencia inicial seleccionada y se limita antes del siguiente programa que reutilice esa secuencia con otro ID_OrdenCliente. Esta delimitación usa el orden creciente de IDs de producción. No se seleccionan automáticamente registros ambiguos. La BOM se lee para los suffix de los mismos registros seleccionados. La vista previa muestra la fecha de cada secuencia.

Las 24 secuencias deben existir completas; si falta la 24 en todas las fechas del programa, sigue informando ese faltante y conserva el camión activo. No inventa órdenes ni reduce capacidad. Esta regla sustituye la restricción de fecha única de las versiones anteriores. Compilación y 33 pruebas aprobadas; conexión física desde este entorno no probada.

## Actualización 1.7.0 — fechas reales y origen visible

La pantalla consulta las fechas existentes en Orden_Produccion (`DL06`, `D%`) al abrir y al guardar configuración. En demo propone la última fecha disponible y su primera secuencia, en vez de suponer la fecha de hoy. Muestra cantidad de secuencias/paneles y permite actualizar/elegir otra fecha. No carga un camión automáticamente: pulsar **Cargar secuencias para escanear** confirma el rango de 24 vehículos elegido.

**Para los datos de la captura:** elegir **2026-09-18**, desde **1** hasta **24**. Tras cargar, si el registro 6971 es el primero, debe aparecer **D3L / LH / FR / orden 6971 / referencia 67620-0KM80-C4**. P3A / RH / SEQ-842 son datos de demo, no SQL. Se añadió un aviso visible del origen y se bloquea escanear demo cuando existe configuración SQL sin programa cargado. Errores de conexión o programa se muestran sin inventar datos.

**Instalar actualización:** cerrar la ventana del servidor anterior, extraer este ZIP, conservar la carpeta `config/` y `dl06_production.db` del puesto cuando corresponda y ejecutar el nuevo .bat. Recargar el navegador con Ctrl+F5 y verificar **VERSIÓN 1.7.0** en Programa SQL Server. El lanzador ahora se detiene si el puerto 3002 ya responde, para evitar abrir silenciosamente la instancia anterior. No borra la DB ni cierra otros procesos.

Se probaron 31 casos, incluido un programa de 88 paneles con orden 1/3/5/8 como en la captura. La conexión remota a HILO-000 sigue sin verificarse desde este entorno.

## Actualización 1.6.0 — carga real desde DL06

Esta versión reemplaza la limitación de vista previa de versiones anteriores. En «Base de datos», configurar SQL Server y la base **TB-L**. En «Programa SQL Server», elegir fecha, secuencia inicial (final = inicial + 23) y curado mínimo; pulsar **Cargar secuencias para escanear** antes del primer panel. Se consulta `dbo.Orden_Produccion` con `Puesto='DL06' AND SD LIKE 'D%'`, fecha y rango. No se recorta con TOP 1000. Las 24 secuencias deben existir completas (2 o 4 paneles), con BOM válida; de lo contrario se conserva el objetivo anterior y se informa el error.

Cada registro SQL crea un objetivo con su ID, referencia, SD, suffix, mano y posición. Un vehículo se completa cuando todos sus paneles están confirmados; un dolly tiene tres vehículos, hasta 12 paneles, en filas FR/RR y columnas LH/RH consecutivas. Cada seis vehículos terminados genera un cartel con todos sus paneles. Se conservan camiones anteriores y el programa activo sobrevive al reinicio; reset de demo está bloqueado en SQL.

**Formatos pendientes de confirmar en planta:** en validación estricta, el panel espera el ID_OrdenProduccion como código exacto y garnish el SD exacto de BOM. No se ha recibido el formato real de estas dos etiquetas, ni datos de color/terminación; no se infieren esas validaciones. Armrest usa `yyyyMMddHHmmss + SD + FR/RR + LH/RH`, fecha Argentina UTC-03, sin fecha para garnish. Garnish se exige en FR cuando hay fila G en BOM; RR o BOM sin G se registra NO_APLICA sin simular ACK PLC. Confirmar esta regla antes de producción. El mínimo de curado se configura para esta carga; BOM_Suffix no contiene tiempos por modelo. El modo prueba sigue siendo permisivo.

SQL Server remoto y hardware físico no se han verificado desde este entorno. Se validaron compilación y 28 pruebas automatizadas, incluyendo importación de 80 paneles / 24 vehículos, persistencia, exclusión de escaneos durante carga y pintado de celdas.

## Inicio Windows

1. Instalar Node.js **22.13 o superior** (recomendado Node 24 LTS). `node:sqlite` no existe en Node 20. Referencia: https://nodejs.org/download/release/latest-jod/docs/api/sqlite.html
2. Extraer el ZIP en una carpeta con permiso de escritura.
3. Ejecutar `iniciar_puesto_dl06.bat`. Instala dependencias de producción si faltan y abre http://localhost:3002 cuando responde el servidor.
4. La primera instalación necesita acceso a npm. Para un puesto sin Internet, preparar `node_modules` con `npm ci --omit=dev` en otra máquina y copiarlo junto con el proyecto.

El ZIP contiene `dist/` y `public/`: no hace falta compilar en el puesto.

## Desarrollo y comprobación

```sh
npm ci
npm test
npm run build
npm start
```

`npm run dev` ejecuta el servidor TypeScript; para modificar la UI, ejecutar Vite en otra terminal con `npx vite --config frontend/vite.config.ts`. Los archivos compartidos están en `shared/types.ts`; mantenerlos alineados con `server/types.ts` al cambiar el contrato.

## Configuración

El servidor lee variables de entorno (no carga `.env` automáticamente). Ejemplo en una consola Windows:

```bat
set TEST_MODE=false
set PRINTER_MODE=REAL
set ZEBRA_HOST=192.168.10.50
set ZEBRA_PORT=9100
node dist/index.js
```

| Variable | Predeterminado | Uso |
| --- | --- | --- |
| PORT | 3002 | Puerto HTTP y Socket.io |
| HOST | 127.0.0.1 | Interfaz de escucha; usar IP de LAN para HMIs remotas |
| DB_PATH | dl06_production.db | Archivo SQLite |
| TEST_MODE | true | `false` aplica validación estricta y deshabilita reset |
| PRINTER_MODE | SIMULATOR | REAL envía ZPL a TCP Zebra |
| ZEBRA_HOST | sin definir | IP de la Zebra |
| ZEBRA_PORT | 9100 | Puerto Zebra |
| PLC_DRIVER | sin definir | Módulo ESM exportando `default: PlcDriver` |

El servidor escucha en loopback de forma predeterminada. No incluye autenticación de operadores ni de comandos de diagnóstico. La apertura en LAN requiere controles de acceso del entorno o incorporar autenticación antes de uso productivo. `operatorId` registra identificación declarada; no verifica identidad.

## Modelo y criterios adoptados

- 24 sets, 8 dollys, 3 sets por dolly y 6 por par. La matriz física 2×6 muestra posiciones, no una capacidad de 12 sets. La semilla utiliza columnas 1–3, dejando el resto visible y libre. La asignación puede cambiarse en `sequences` manteniendo ubicaciones únicas.
- Se añadió **WAITING_DOLLY** para exigir el cuarto paso. Tras tres ACK PLC, leer `DOLLY-{número}-{TOP|BOTTOM}-{columna}` o pulsar Confirmar ubicación. El botón equivale a una confirmación manual; no prueba físicamente dónde se apoyó la pieza.
- Los ejemplos incoherentes del pedido se convierten en contadores vivos: PAR 2 es sets **7–12**; la carga es sobre **24 sets**; las bahías se cuentan sobre **8 dollys**.
- La semilla de demostración alterna modelos/manos y contiene 24 posiciones programadas. Un registro corresponde al ciclo descrito de panel + armrest + garnish, no a un vehículo completo de cuatro puertas. Antes de usar una orden real se debe confirmar esta definición de “set” con Producción y cargar las secuencias reales.
- P1A se usa como ejemplo sin RR. No se agrega lógica de sets con componentes opcionales: el ciclo pedido exige panel, armrest y garnish para cada registro.
- Curado mínimo configurado por secuencia (`required_curing_minutes`, 60 en la demo). Producción valida contra `components.bonded_at`, fecha ISO UTC. Los ejemplos de semilla están encolados 99 minutos antes de su creación. El servidor debe tener reloj sincronizado.
- La equivalencia exacta se valida contra el código esperado y los atributos de `components`. Color/terminación del perfil demo: NEGRO/CUERO. Para producción se requiere cargar la identificación real, timestamps y perfiles de terminación; no hay conexión al sistema maestro/JIS ni una pantalla de importación.

## Simulación y lector

El lector wedge USB o serial configurado como teclado termina con Enter. La captura global agrupa teclas con separación máxima de 100 ms; no interfiere con campos editables. Un puerto COM directo necesita un puente/driver adicional.

En modo prueba, cualquier lectura avanza el paso (incluyendo confirmación dolly), con estas excepciones:

- ARMREST con `-NOCURE`: falla por curado.
- `FORCE-ERR`: simula rechazo PLC; en dolly rechaza el destino.
- Diagnóstico permite OK/FAIL/TIMEOUT, latencia y timeout configurable (5 s inicial).

Un error bloquea nuevas lecturas hasta Reconocer error; se conserva lo validado. Durante el handshake se ignoran lecturas adicionales, cambios de PLC y reset. Se permite reconectar varias HMIs: todas reciben el estado autoritativo del servidor.

## Integración PLC real

`server/plcService.ts` define el contrato:

```ts
interface PlcDriver {
  handshake(step: 1 | 2 | 3, sequence: Sequence, signal: AbortSignal): Promise<boolean>;
}
```

El driver debe exportarse por defecto desde un módulo ESM y configurarse con `PLC_DRIVER` (preferible URL `file:///C:/.../driver.js` en Windows). Seleccionar REAL desde Diagnóstico. El sistema bloquea con error si no hay driver: **no simula una aprobación en modo REAL**.

El driver EtherNet/IP específico queda pendiente del PLC físico: se necesitan fabricante/modelo, IP, tags o assemblies, definición request/ACK/NO OK, identificador de ciclo y criterio de reset. No se incluye un driver EtherNet/IP operativo ni se probó contra hardware. El implementador debe respetar AbortSignal, correlacionar ACK al ciclo y limpiar requests al abortar; una respuesta tardía no debe aprobar el siguiente ciclo.

## Zebra y recuperación

Cada set se guarda con su secuencia y actualización de contador dentro de una transacción. Cada bloque de 6 crea un único trabajo de impresión en la misma transacción (restricción UNIQUE camión/bloque).

- SIMULATOR: archivo `print-output/lote-{id}.zpl`, estado SIMULATED.
- REAL: envío TCP del ZPL, estado SENT. SENT confirma transporte, **no impresión física**.
- Fallo de impresión: detiene la carga; botón Reintentar impresión conserva los sets y el trabajo.
- Al arrancar, se recuperan estado y trabajos pendientes. Un handshake interrumpido exige reconocimiento y nueva lectura. Nunca se reinicia un camión automáticamente.
- Si el proceso se interrumpe después del envío TCP pero antes de marcar SENT, el reintento puede duplicar el cartel. Verificar la impresora antes de reimprimir. El formato es una etiqueta/cartel demo de 812 puntos, no un remito fiscal o formato TASA homologado.

`dl06_production.db` se crea automáticamente con WAL, claves foráneas, busy timeout y sincronización FULL. Conservar también el WAL durante copias activas o realizar backups SQLite consistentes con el servidor detenido. No borrar la base para reiniciar producción.

## Protocolo

Entradas Socket.io: `set-sequence-range {start, end}` y `scan {barcode, operatorId?}`, `dismiss-error {operatorId?}`, `plc-config {mode,behavior,timeoutMs?,latencyMs?}`, `reset-demo` y `retry-print`. `operatorId` de dismiss-error no genera registro de reconocimiento separado; el evento se registra sin identidad autenticada.

Salida: `state-change` con `HmiState` y `command-error` con errores de comandos. Socket.io usa WebSocket con fallback HTTP. Las nuevas conexiones reciben una instantánea persistida completa.

HTTP: `/api/health`, `/api/state`, `/api/traceability` (JSON de sets), frontend en `/`.

## Verificación realizada

26 pruebas automatizadas aprobadas (incluyendo rangos variables, persistencia, migración y protocolo de rango): 24 sets y cuatro trabajos de impresión, lecturas simultáneas, curado, rechazo/timeout PLC, validación estricta y recuperación del ciclo, bloqueo de driver real ausente, reintento de impresora, HTTP/Socket.io. TypeScript backend/frontend y build Vite aprobados.

No se verificó el layout en navegador: el entorno de construcción no dispone de Chromium. Tampoco se probó el BAT en Windows, lectores, PLC ni impresora reales. La solución se entrega como prototipo funcional para validación e integración; no como sistema industrial homologado.


## Selección del rango de secuencias

La HMI permite definir **Desde** y **Hasta** antes de iniciar la carga. Al cambiar el inicio, calcula fin = inicio + 23; al cambiar el final, calcula inicio = fin - 23. Pulsar **Aplicar rango** para guardar y sincronizar todas las HMIs. Ejemplo: **0842 → 0865**, siempre 24 secuencias. La cabecera muestra la secuencia real y el contador independiente **Cargados 0/24**.

Se admiten enteros de 0000 a 9999, en rango ascendente sin salto ni reinicio de numeración. Un rango distinto de 24 se rechaza también en el backend. El rango queda bloqueado al empezar a validar el primer panel y permanece bloqueado tras un reinicio; el reset de prueba crea de nuevo la demo 0001–0024.

`sequences.sequence_number` guarda la numeración real; `load_index` conserva la posición de carga 1–24. Dollys, bloques de 6 y capacidad dependen de `load_index`, por lo que no cambian al elegir otro inicio. Los carteles y la trazabilidad incluyen la secuencia real.

El cambio de rango no altera modelos, SD ni códigos esperados existentes: esos datos siguen siendo los del programa de piezas cargado. La numeración por sí sola no consulta una orden externa ni asigna nuevos componentes.

Al abrir una base creada con la versión anterior, se migra automáticamente la tabla `sequences`, preservando IDs, sets y referencias. La migración retira la restricción de secuencia 1–24 y añade `load_index`; se verifica integridad referencial dentro de la transacción. Realizar un backup consistente antes de actualizar un puesto.


## Pintado de posiciones y dollys (v1.2)

El pintado se calcula con las secuencias asignadas a cada **dolly + nivel físico TOP/BOTTOM + columna**, sin usar la numeración de producción ni dividir el total por 3.

- **Gris vacío:** sin secuencia asignada. Nunca se marca como actual, incluso al finalizar el camión.
- **Gris con número:** posición prevista, todavía pendiente. Se muestra su secuencia real.
- **Amarillo:** destino actual; los escaneos de panel, armrest y garnish validan piezas, pero aún falta confirmar ubicación.
- **Rojo:** destino actual bloqueado por rechazo o timeout. Las posiciones ya confirmadas conservan el verde.
- **Verde con ✓:** secuencia completada y ubicación confirmada, persistida en la base.

Cada bahía muestra el progreso real 0/3, 1/3, 2/3, 3/3 y su barra de avance. El dolly queda verde cuando todas sus secuencias asignadas están confirmadas. Durante la impresión de bloque y un fallo de impresora no se marca el siguiente dolly como activo: la carga permanece detenida.

La matriz tiene botones 1–8 para consultar dollys anteriores. Sigue automáticamente el nuevo dolly al avanzar la carga, y al finalizar conserva la matriz del último dolly. El botón **Volver al dolly actual** restaura la vista activa. Confirmar ubicación se deshabilita al consultar otro dolly.

Se agregaron pruebas de los 24 ciclos y los 8 dollys, ambas filas FR/RR, fin de camión sin celdas activas fantasma, curado/error, impresión bloqueada, asignaciones intercaladas, recuperación y HTML React renderizado. Se verificaron las clases de color emitidas por los componentes; continúa pendiente una inspección visual en un navegador con hardware real.


## Fuente SQL Server DL01 y equivalencias BOM (v1.3)

Fuente confirmada por el usuario: `TB-L.dbo.Orden_Produccion`, filtro `Puesto = 'DL01'`. Se consulta por `Fecha_Secuencia` y rango de 24 números de `Secuencia`, ordenando por `Secuencia, Orden, ID_OrdenProduccion`. La consulta completa está en `sql/leer_programa_dl01.sql`; no utiliza TOP ni NOLOCK.

La definición corregida del programa de origen es **24 vehículos**, cada uno con **2 o 4 paneles**. Los registros de `Orden_Produccion` se agrupan por secuencia y se comprueba la consistencia de `ID_OrdenCliente`, `Suffix` y `SD`. La cantidad esperada de registros es de 48 a 96 según la mezcla. Se exigen FR-LH y FR-RH; si hay traseros, deben estar RR-LH y RR-RH. No se crean traseros inexistentes.

`BOM_Suffix` se lee por los mismos suffix y se resuelve aparte, para evitar que un JOIN uno-a-varios multiplique los paneles:

| Suffix de la imagen | Panel SD | Armrest SD | Garnish SD |
| --- | --- | --- | --- |
| M3CU | D3L | A3L | GDC |
| M1GR | D1H | A1H | Sin fila mostrada |
| M3GR | D3H | A3H | GDC |

La clasificación implementada es prefijo D = panel, A = armrest, G = garnish. El SD del panel debe coincidir con la fila D de BOM. Una BOM inexistente, contradictoria o con familias no reconocidas bloquea la vista previa. Un garnish ausente genera una advertencia y `garnishSd: null`; no se transforma en autorización para omitir el control.

La tabla BOM determina modelos SD compatibles, **no el código QR completo ni un número de pieza de armrest/garnish**. Tampoco contiene la fecha de encolado. El garnish asociado al vehículo todavía no se aplica automáticamente a cada panel; queda por confirmar la aplicabilidad por FR/RR.

### Uso de la vista previa

1. Copiar `configurar_sql_server.example.bat` a `configurar_sql_server.bat` y completar localmente el usuario de SQL Server con permiso SELECT en ambas tablas. No guardar credenciales en fuentes ni enviarlas por el navegador.
2. Reiniciar con `iniciar_puesto_dl06.bat`, que carga el archivo local de configuración si existe y comprueba también la nueva dependencia mssql.
3. Elegir y aplicar el rango desde la HMI.
4. Abrir **PROGRAMA SQL SERVER · DL01 + BOM_SUFFIX**, elegir fecha del programa y pulsar **Leer programa y BOM**.

`MSSQL_SERVER` sugerido por la captura: HILO-000; confirmar dirección/instancia y puerto reales. `MSSQL_DATABASE` predeterminado TB-L, puerto 1433. Se soporta autenticación SQL con `MSSQL_USER` / `MSSQL_PASSWORD`. La autenticación integrada Windows utilizada en SSMS no se implementó; requiere un driver/configuración adicional. Se usan cifrado y validación del certificado por defecto; `MSSQL_ENCRYPT=false` o `MSSQL_TRUST_CERTIFICATE=true` permiten adaptar una instalación existente, si así se decide localmente. Timeout de conexión 5 s, consultas 15 s, pool máximo 2 conexiones.

La lectura se ejecuta en una transacción REPEATABLE_READ y recibe fecha/rango como parámetros tipados. No escribe ni actualiza estado en SQL Server. Endpoints: `GET /api/source/status`, `POST /api/source/preview {date,start,end}`. Las credenciales no se devuelven. Un error de datos retorna 400; falta de conexión/configuración, 503.

**Estado de integración:** esta versión incorpora conexión y vista previa real de origen; **todavía no importa esos paneles a la FSM**. El camión activo continúa siendo la demo original, con un registro por ciclo. No deben usarse los contadores de esa demo como conteo de vehículos del programa SQL. La nueva vista distingue vehículos de paneles. Antes de activar el programa real hace falta adaptar el ciclo persistido para completar una secuencia solo tras sus 2/4 paneles y confirmar formato QR, origen de curado y controles opcionales.

La vista previa propone 3 vehículos por dolly: FR en TOP, RR en BOTTOM; por cada vehículo, LH en columna impar y RH en par (1/2, 3/4, 5/6). Permite mezclar cabinas simples y dobles sin colisiones, pero **es una asignación propuesta pendiente de confirmación física**, y no modifica el pintado de la demo.

Verificación: pruebas con datos construidos a partir de las equivalencias de las capturas, mezcla 2/4 paneles, 24 grupos, posiciones únicas, rango/fecha incorrectos, filas duplicadas, BOM conflictivo y endpoints sin conexión configurada. No hubo acceso al servidor HILO-000 ni prueba con credenciales reales.

Documentación de la dependencia SQL: https://tediousjs.github.io/node-mssql/


## QR armrest y curado (v1.4)

Formato confirmado: **yyyyMMddHHmmss + SD de 3 caracteres + FR/RR + LH/RH**. Ejemplo `20260728142712A4LRRRH`: 28/07/2026 14:27:12, SD A4L, trasero, derecha.

En `TEST_MODE=false`, el paso armrest extrae fecha/hora del propio QR, interpreta la hora de planta como UTC-03:00 de Argentina y valida el SD contra `sequences.expected_armrest_sd`, además de posición y mano contra el panel esperado. No necesita una fila del QR en `components` ni usa `components.bonded_at` para el curado. Solo continúa cuando minutos transcurridos >= `required_curing_minutes`. Se rechazan códigos incompletos, fechas imposibles o futuras y piezas incompatibles.

El campo esperado SD es persistido por secuencia. Se agrega automáticamente a bases anteriores. La demo lo configura con perfiles A3L/A1H/A3H/A4L; en un programa productivo debe obtenerse de BOM_Suffix. Un SD ausente bloquea el paso. El QR completo leído queda registrado en `sets.armrest_barcode`; la fecha decodificada y minutos se muestran durante el ciclo, y los minutos quedan en la trazabilidad final. Garnish no lleva control de fecha/curado.

El modo prueba mantiene el comportamiento permisivo original y el curado ficticio de 99 minutos: para verificar el nuevo rechazo de QR usar `TEST_MODE=false`. La primera instalación de demo genera QRs armrest con fecha real 99 minutos anterior a su creación; no son etiquetas físicas válidas para planta. Las bases viejas conservan sus códigos demo anteriores, que ya no serán válidos como QR en modo estricto. El reset de demo genera códigos con el nuevo formato y borra la demo según su comportamiento existente.

**Alcance:** el lector de armrest está integrado al ciclo existente y compilado. La importación del programa SQL de 24 vehículos con múltiples paneles sigue pendiente; SQL continúa como vista previa. La conexión al servidor real, el PLC y Zebra no se probaron con hardware. No se debe interpretar esta compilación como homologación del puesto completo.


## Pantalla de configuración de DB (v1.5)

En la HMI pulsar **Base de datos** (junto a Diagnóstico). Se abre una pantalla con servidor/IP, base, puerto o instancia opcional, usuario SQL, contraseña, cifrado y confianza del certificado. Se admite `HILO-000\INSTANCIA` o servidor e instancia en campos separados. Si hay instancia, el driver resuelve su puerto; el campo de puerto TCP queda deshabilitado. La autenticación es SQL; no se agrega autenticación integrada Windows.

**Probar conexión** no guarda cambios: comprueba conexión y permisos SELECT/columnas requeridas en `dbo.Orden_Produccion` y `dbo.BOM_Suffix`. **Guardar configuración** guarda y aplica los cambios sin reiniciar, cerrando el pool anterior para que la próxima lectura use la nueva conexión. Guardar no exige conexión disponible, por lo que una configuración guardada no implica que se haya probado correctamente. No se permiten cambios durante una lectura de programa activa.

La contraseña se envía únicamente al guardar/probar y nunca se devuelve al navegador. Dejarla vacía conserva la existente; después de guardar se limpia el campo. Los valores se conservan en `config/database.json`, con contraseña cifrada AES-256-GCM y clave local en `config/database.key`. Conservar ambos archivos juntos y restringir el acceso a esa carpeta desde Windows. El cifrado no sustituye la protección de la clave local ni un gestor de secretos del sistema operativo. Estos archivos no están incluidos en el ZIP ni en git. Ruta alternativa: `DL06_CONFIG_DIR`.

La configuración guardada tiene prioridad sobre las variables MSSQL del BAT. Sin archivo guardado, se siguen usando las variables existentes. Para restablecer esa fuente, detener el servidor y retirar los archivos de configuración tras respaldarlos.

La pantalla se configura desde `http://localhost:3002` en el equipo del puesto. Sus endpoints aceptan únicamente conexiones loopback y origen local; rechazan solicitudes desde otros sitios. No introduce un sistema de login para configuración remota. Si se accede a la HMI desde otro equipo, configurar la DB en el navegador local del puesto.

Mientras está abierta la configuración, se suspende la captura global del lector para que las pulsaciones no avancen la producción. Se mantiene la conexión HMI y el estado del ciclo.

Pruebas añadidas: guardado y recuperación tras reinicio, contraseña cifrada y ausente de respuestas, conservación de contraseña en blanco, rechazo de campos inválidos, instancia nombrada y API local con rechazo de origen externo. La conexión física con HILO-000 continúa pendiente de prueba en el puesto.

### Versión 1.9.6
Paso 4: rack metálico dinámico con 6 posiciones FR, 12 espacios armrest (FR/RR por columna) y 6 RR. Contador por vehículos completos. Los armrest se pintan tras ACK PLC; las piezas, tras ubicación automática. Se conserva el camión de 8 dollys.

### Versión 1.9.7
Distribución operativa: objetivo, pasos 1–3 y camión en columna izquierda (75%); paso 4 con rack FR/ARMREST/RR en columna derecha (25%), a toda altura. Configuración permanece en pantalla separada.

### Versión 1.9.8
Valores de secuencia, modelo, ubicación y mano ampliados de 48 a 96 px. En pantallas menores a 1500 px las métricas se distribuyen en dos columnas para conservar legibilidad sin superposición.

### Versión 1.9.9 — corrección de asociación garnish
La instrucción actual reemplaza la asociación previa: garnish corresponde a RR cuando existe SD G en BOM; FR no aplica. Al abrir la base se actualizan solo objetivos SQL pendientes; los registros completados se conservan. Un FR esperando garnish avanza a ubicación automática al recuperar.

### Versión 1.10.0 — distribución configurable y vista doble
Configuración > Distribución de paneles en dolly: esquema estándar o por pares, selección del dolly y nivel para FR/RR y LH/RH. Por pares: seis vehículos, una columna por vehículo; rutas iniciales FR-RH y RR-LH primero, FR-LH y RR-RH segundo. Doce espacios armrest por dolly (dos por columna). Configuración persistida en SQLite, aplicación al activar SQL; no reasigna cargas ya iniciadas. Vista simultánea del par modificable durante operación. En pantallas menores de 1500 px se coloca el par debajo para mantener legibilidad.

### Versión 1.10.1
Etapas aprobadas: fondo verde, borde esmeralda, badge sólido e icono verde. Aprobación visual requiere ACK PLC. Etapa activa esperando lectura o validando PLC: pulso ámbar de 1,5 s, sin ocultar el contenido. No aplica y errores no titilan. Respeta preferencia del sistema de movimiento reducido.

### Versión 1.10.2
Distribución inicial por pares según imagen: primero FR-RH superior / RR-LH inferior; segundo FR-LH superior / RR-RH inferior; seis secuencias por par. Vista doble inicial. Configuraciones existentes se conservan; botón Usar distribución de la imagen antes de activar SQL. Labels posición/mano en cada panel y armrest. No se reubican registros de cargas iniciadas.

### Versión 1.10.3
Vista de operación ocupa todo el ancho, sin máximo de contenedor. Espaciados compactos; dos racks laterales. ResizeObserver ajusta la escala de toda la vista a la altura disponible, compensando el ancho para evitar bandas laterales. Configuración y diagnóstico conservan desplazamiento. Tipografía de objetivos adaptable hasta 96 px; texto completo del camión en cabecera y truncado en cabina.

### Versión 1.10.4
Botón Modo claro / Modo oscuro en barra superior. Preferencia guardada por navegador en localStorage. Modo claro con fondo claro y texto oscuro; aprobados verdes y activo ámbar pulsante se conservan. Racks mantienen contraste oscuro para distinguir posiciones.

### Versión 1.10.5
En modo claro los racks, compartimientos y pies usan superficies claras. Aprobados verde claro, actual ámbar claro y error rojo claro, con textos oscuros contrastantes. Modo oscuro conserva sus colores.

### Versión 1.10.6
Títulos PANEL/ARMREST/GARNISH ampliados. Detalle de panel retirado; armrest y garnish muestran únicamente SD. Se conservan indicadores de estado, colores, escaneo y validaciones del backend, incluido curado.

### Versión 1.10.7
Alarmas superpuestas al paso 4, solicitando escaneo correcto para continuar. ERROR/PLC_TIMEOUT de etapas de piezas permiten reintentar sin reconocimiento manual, repitiendo todas las validaciones y el handshake; piezas aprobadas se mantienen. Error de impresión conserva bloqueo y botón de reintento de impresión.

### Versión 1.10.8
Cartel de error con letras ampliadas, sin campo ni botón de escaneo. Indica PANEL, ARMREST o GARNISH correspondiente al paso fallido y espera lectura global del escáner.

## Dos puestos locales — v1.11.0

Cada PC mantiene su servidor y SQLite local. El avance se intercambia directamente por la red de planta cada dos segundos; no se modifica `Orden_Produccion` ni se necesitan tablas nuevas en SQL Server.

Antes de iniciar un camión, en **Configuración → Puesto · mano y posición**:

1. Elegir IDs distintos, por ejemplo `PUESTO-1` y `PUESTO-2`.
2. Asignar cada combinación a un único puesto. Ejemplo: puesto 1 `FR-RH / RR-LH`; puesto 2 `FR-LH / RR-RH`.
3. En cada PC, ingresar `http://IP-DE-LA-OTRA-PC:3002` (IPv4 privada de planta).
4. Ingresar la misma clave compartida de al menos 16 caracteres en ambas PCs. No se devuelve al navegador; vacío conserva la clave guardada.
5. Marcar **Este puesto imprime los carteles** solamente en una PC.
6. Activar el mismo programa SQL (fecha inicial, rango, curado y distribución iguales) en ambas PCs. Puede cambiar la opción visual de mostrar dos dollys sin afectar el enlace.
7. Verificar **Sincronizado con …** en ambas antes de escanear.

Cada puesto presenta los paneles asignados ordenados por secuencia y orden de origen. Puede avanzar sin esperar al otro: por ejemplo, secuencia 5 en un puesto y 3 en el otro. El camión y los dollys cuentan los paneles completos de ambos. Un puesto sin paneles propios pendientes muestra **Puesto completo · esperando al otro puesto**; el camión solo finaliza cuando ambos terminan.

La sincronización requiere conexión entre las PCs por TCP 3002. Esta versión escucha en las interfaces de red (HOST=0.0.0.0 por defecto). En Windows, permitir Node/DL06 en la red privada de planta; mantener las PCs en una red confiable y no publicar este puerto en Internet. La configuración sigue accesible únicamente desde localhost. El endpoint de intercambio requiere la clave compartida.

Si falla el enlace, el programa difiere o las asignaciones se superponen, el escaneo queda bloqueado. El último avance remoto visible puede estar desactualizado hasta reconectar. El ciclo local conserva los pasos aprobados para continuar después de recuperar el enlace. Los reinicios conservan el avance local; el remoto se vuelve a consultar. Ambos puestos deben mantenerse encendidos hasta emitir los cuatro carteles.

Las asignaciones quedan bloqueadas cuando empieza la carga. Para una carga ya iniciada con una versión anterior, conservar la base anterior y comenzar un programa nuevo en ambas PCs; no repartir una carga a medias ni cambiar las combinaciones durante el proceso. Conservar `config/` y `dl06_production.db` al instalar una actualización. El ID del puesto queda registrado junto al operador en la trazabilidad local.

La verificación automática simula dos bases locales independientes, avance desparejo, conteo compartido, reinicio, rechazo de superposiciones y desconexión/reconexión. La conexión entre las PCs reales y el PLC debe verificarse en planta.

## Programa SQL progresivo — v1.11.1

No se necesitan las 24 secuencias al arrancar. Se activa la fecha inicial y el rango de capacidad (24 vehículos), importando solamente las secuencias disponibles en orden. El servidor vuelve a consultar SQL cada 5 segundos y agrega los nuevos vehículos sin reemplazar el camión ni borrar validaciones, ciclos o carteles. También existe **Actualizar programa ahora** en Configuración.

Si la siguiente secuencia todavía no existe o llega con un juego incompleto (1 o 3 paneles), se muestra **Esperando nuevas secuencias en la DB**. Las secuencias posteriores no se saltan. Se conserva la regla actual de juegos completos: dos paneles FR (LH/RH) o cuatro FR/RR (LH/RH). Las órdenes de una secuencia deben publicarse juntas en SQL para que una llegada temporal de dos FR de un vehículo de cuatro paneles no se confunda con un vehículo de dos. Si SQL agrega paneles a una secuencia ya importada, elimina órdenes o modifica sus datos, se bloquea el escaneo con aviso para revisar; no se cambia silenciosamente lo esperado o lo ya validado.

Los puestos pueden consultar SQL en momentos distintos y tener temporalmente una cantidad diferente de secuencias disponibles. El enlace identifica el mismo rango y fecha y verifica los datos de las órdenes comunes. Cada puesto mantiene su orden; el avance remoto se refleja cuando la orden también esté disponible localmente. Los dollys solo se marcan completos cuando se conocen todos los vehículos de su grupo (3 en distribución estándar o 6 por par) y están validados sus paneles. El camión conserva capacidad 24 y queda esperando datos hasta completarla.

Si la consulta SQL falla, conserva las órdenes válidas ya disponibles y avisa que volverá a intentar. La conexión con el otro puesto sigue siendo necesaria en modo sincronizado. Se conserva y recupera la selección de lectura después de reiniciar, incluso en programas SQL anteriores a esta versión.

## Configuración compacta — v1.11.3

La pantalla se organiza en tres pestañas: **Programa**, **Puesto** y **Dollys**, con acceso directo a **Base de datos**.

- **Programa:** fecha, secuencia inicial y curado en una fila; capacidad del camión y cantidad disponible visibles. El detalle de órdenes se despliega solo cuando se necesita. **Revisar secuencias** consulta la vista previa; **Activar y volver a operación** inicia el programa. **Actualizar ahora** conserva abierta la configuración. El rango de demostración está en opciones desplegables separadas.
- **Puesto:** cuatro opciones visuales FR/RR y LH/RH. El dibujo destaca los paneles habilitados en esta computadora y atenúa los del otro puesto. La dirección y clave de enlace aparecen al activar **Compartir camión con otra computadora**.
- **Dollys:** organización de 3 vehículos por dolly o 6 por par, destino de cada combinación y vista de uno/dos dollys. Los dibujos muestran inmediatamente el borrador. Elegir un destino ocupado intercambia las dos ubicaciones para conservar cuatro destinos únicos. **Usar distribución recomendada** recupera el esquema FR-RH / RR-LH en el primer dolly y FR-LH / RR-RH en el segundo.

Los dibujos son ejemplos de distribución, no el avance real de producción. Las modificaciones requieren Guardar; cambiar de pestaña conserva los borradores. La distribución guardada se aplica al activar el programa SQL, mientras la opción visual de uno/dos dollys se aplica de inmediato. Una carga iniciada conserva los bloqueos existentes. La interfaz usa el tema claro u oscuro elegido para operación.

## Formatos de QR — v1.12.0

En **Configuración → Códigos QR**, elegir PANEL, ARMREST o GARNISH. Cada componente tiene su propio formato:

- **Campos por posición:** inicio desde 1 y longitud. Longitud 0 lee hasta el final. Las posiciones corresponden al contenido después de quitar el prefijo y la terminación configurados. No se admiten campos superpuestos.
- **Campos separados:** delimitador literal (por ejemplo `;`) y columna desde 1. Al seleccionar este formato las columnas se enumeran automáticamente; pueden corregirse. No se admiten columnas repetidas.
- Prefijo, terminación y largo total opcionales (0 significa variable). Largo total incluye prefijo/terminación y excluye espacios o saltos de línea al principio y final del escaneo. Los campos extraídos se recortan y pueden compararse en mayúsculas.

PANEL admite ID_OrdenProduccion, Referencia, SD, Posicion, Mano, Secuencia y Suffix. Se exige ID, referencia o SD+posición+mano+secuencia; todos los campos incluidos deben coincidir con el objetivo SQL activo. Si la referencia no identifica una pieza de manera única, incluir también secuencia, posición y mano: el sistema solo puede distinguir la información presente en el QR.

ARMREST requiere fecha/hora, SD, posición y mano. La fecha sigue el formato `yyyyMMddHHmmss` y hora Argentina. Se rechazan fechas imposibles/futuras y curado menor al configurado para el programa. El formato inicial es fecha (inicio 1, 14), SD (15, 3), posición (18, 2), mano (20, 2), total 21: `20260728142712A4LRRRH`.

GARNISH requiere SD contra la BOM del panel RR; opcionalmente compara mano y posición cuando estén presentes en su etiqueta. Nunca lleva validación de fecha o curado.

**Interpretar y comprobar** lee el ejemplo sin cambiar el avance ni solicitar validación al PLC. Muestra los campos extraídos y compara con el objetivo actual; un código con formato correcto pero incompatible conserva la lectura visible y explica la diferencia. El lector puede ingresar el ejemplo en ese campo y finalizar con Enter.

**Guardar formatos QR** aplica la configuración entre paneles; no permite modificarla durante un ciclo iniciado. Se conserva después de reiniciar y se registra el cambio en el historial. La configuración inicial mantiene ID completo para panel, el formato conocido de armrest y SD completo para garnish.

En producción (`TEST_MODE=false`) los QR SQL siempre se validan. Para comprobar contenido manteniendo el PLC en simulación/modo prueba, activar **Validar los QR también en modo prueba** y guardar. Una demo sin IDs SQL no puede validar el formato de ID de orden: activar primero un programa SQL. Los ciclos y aprobaciones previas se conservan ante un error. Con dos puestos sincronizados, guardar los mismos formatos y la misma opción de validación en ambas PCs para continuar; su enlace verifica esa coincidencia.

## Cambiar secuencia inicial — v1.12.1

En **Configuración → Programa**, usar **Cambiar secuencia inicial** para editar fecha, inicio y curado de un nuevo programa. Marcar **Archivar el programa actual e iniciar el nuevo desde la secuencia indicada**, revisar las órdenes y pulsar **Iniciar nuevo programa**.

El programa anterior conserva sus paneles completos, trabajos de impresión y ciclo parcial en el historial. El nuevo programa comienza sin validaciones y mantiene conexión SQL, formatos QR, distribución y configuración del puesto. Cancelar cambio no modifica el programa activo. Una lectura SQL fallida también conserva el estado anterior.

Con dos PCs sincronizadas, seleccionar la misma fecha y rango en ambas: el enlace bloquea el escaneo mientras sus programas no coincidan. Para evitar mezclar el avance de un reinicio con el del otro puesto, este flujo exige una fecha o inicio diferente cuando hay sincronización habilitada.

Si el primer QR se rechaza antes de aprobar pasos o iniciar un ciclo, la secuencia inicial puede corregirse sin activar el modo de archivo.

## Identificación del panel — v1.12.2

La validación del QR de PANEL utiliza exclusivamente **Secuencia, Mano y Posición**. El ID de Orden_Produccion, SD, Suffix y Referencia siguen disponibles para programa y trazabilidad, pero no se comparan con el QR del panel.

El formato inicial de ejemplo es `0001;RH;FR` (secuencia, mano, posición separadas por `;`); no presupone el formato real de las etiquetas. En **Configuración → Códigos QR → PANEL** indicar las columnas o posiciones de esos tres campos según el código real. Los tres son obligatorios. Configuraciones anteriores que solo leían ID se sustituyen automáticamente por el ejemplo nuevo. Si el perfil anterior ya contenía los tres campos, se conservan sus ubicaciones y se excluyen los datos adicionales de la comparación.

Los escaneos previos y sus IDs SQL se conservan. ARMREST mantiene SD, mano, posición y curado; GARNISH mantiene SD y los campos opcionales configurados. Actualizar ambas PCs sincronizadas y ajustar el mismo formato en ambas.

## SD del panel — v1.12.3

PANEL compara **Secuencia + Mano + Posición + SD**; los cuatro son obligatorios. El ID SQL se conserva para trazabilidad. El ejemplo de formato separado es `0001;RH;FR;D3L`; ajustar columnas o posiciones al QR real en **Configuración → Códigos QR → PANEL**. Un SD distinto al esperado rechaza el escaneo sin avanzar.

Los perfiles que ya contienen los cuatro campos conservan sus ubicaciones. Los perfiles anteriores sin SD pasan al ejemplo nuevo y deben ajustarse al formato real antes de continuar; se conserva el avance y la opción de validar en modo prueba. Actualizar ambas PCs y guardar el mismo formato en las dos.

## BOM de producción con otras familias — v1.12.4

La BOM puede contener otros componentes además de los validados en DL06. Se seleccionan paneles `D…`, armrest `A` seguido de un modelo numérico (por ejemplo A3S/A3G/A3L) y garnish `G…`. `ACE` no se trata como armrest; `T3A/T3B/T3D` y demás familias ajenas se informan en la vista previa y quedan fuera de esta validación.

El caso de producción **EP24 → ACE / T3A / D3L / GDC / A3S** se interpreta como **Panel D3L, Armrest A3S, Garnish GDC**. Se mantiene el filtro de órdenes `Puesto='DL06' AND SD LIKE 'D%'`: las filas GDC de DL06 no se cuentan como paneles ni duplican la secuencia. Sigue siendo obligatorio un único armrest, un panel compatible con la orden y como máximo un garnish por suffix; no se ocultan datos requeridos ausentes o ambiguos.

En las capturas de producción la fecha de secuencia es **01/01/2026**, aunque la fecha de proceso sea 16/10/2026. Elegir la fecha de secuencia para el inicio. Si el nuevo programa había fallado por la BOM, volver a pulsar **Revisar secuencias** y **Iniciar nuevo programa**. El programa anterior conserva su historial. La conexión y consulta reales al servidor de planta requieren comprobación desde el puesto.
