# Gradle CLI Cheat Sheet (Linux / Terminal)

Guía rápida de comandos esenciales de Gradle para trabajar desde la terminal en Linux.

---

# Verificar instalación

## Ver versión de Gradle

```bash
gradle --version
```

Si estás dentro de un proyecto con wrapper:

```bash
./gradlew --version
```

---

# Crear proyecto nuevo

## Modo interactivo

```bash
gradle init
```

## Crear proyecto Java

```bash
gradle init --type java-application
gradle init --type java-library
```

## Ejemplo completo recomendado

```bash
gradle init \
  --type java-application \
  --dsl kotlin \
  --test-framework junit-jupiter \
  --java-version 17 \
  --project-name myapp \
  --package com.example.app
```

---

# Ejecutar aplicación

```bash
./gradlew run
```

---

# Compilar proyecto

```bash
./gradlew build
```

---

# Ejecutar tests

```bash
./gradlew test
```

---

# Limpiar artefactos generados

```bash
./gradlew clean
```

---

# Limpiar y recompilar todo

```bash
./gradlew clean build
```

---

# Inspección del proyecto

## Ver tareas disponibles

```bash
./gradlew tasks
```

Ver todas las tareas:

```bash
./gradlew tasks --all
```

---

## Ver subproyectos

```bash
./gradlew projects
```

---

## Ver dependencias

```bash
./gradlew dependencies
```

---

## Ver entorno de build

```bash
./gradlew buildEnvironment
```

---

# Ayuda

## Ver ayuda de una tarea

```bash
./gradlew help --task build
```

Ejemplo:

```bash
./gradlew help --task init
```

---

# Debugging y diagnóstico

## Mostrar stacktrace si falla

```bash
./gradlew build --stacktrace
```

Stacktrace completo:

```bash
./gradlew build --full-stacktrace
```

---

## Mostrar más información

```bash
./gradlew build --info
```

Modo debug:

```bash
./gradlew build --debug
```

---

# Forzar ejecución

## Forzar tareas aunque estén "up-to-date"

```bash
./gradlew build --rerun-tasks
```

---

# Refrescar dependencias

```bash
./gradlew build --refresh-dependencies
```

---

# Simular ejecución sin ejecutar tareas

```bash
./gradlew build --dry-run
```

---

# Gradle Daemon

## Ver daemons activos

```bash
gradle --status
```

---

## Detener daemons

```bash
gradle --stop
```

---

## Ejecutar sin daemon

```bash
./gradlew build --no-daemon
```

---

# Gradle Wrapper

## Generar wrapper si el proyecto no lo tiene

```bash
gradle wrapper
```

## Especificar versión

```bash
gradle wrapper --gradle-version 9.4.0
```

---

# Archivos importantes del proyecto

```
gradlew
gradlew.bat
gradle/wrapper/
build.gradle(.kts)
settings.gradle(.kts)
src/main/java/
src/test/java/
```

---

# Flujo típico de trabajo

```bash
./gradlew clean
./gradlew build
./gradlew test
./gradlew run
```

---

# Comando universal de debugging

```bash
./gradlew clean build --stacktrace --refresh-dependencies
```

---

# Recomendación

Siempre usa:

```bash
./gradlew
```

en lugar de:

```bash
gradle
```

porque el **Gradle Wrapper garantiza que todos usen la misma versión de Gradle en el proyecto**.
