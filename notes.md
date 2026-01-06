# Notas sobre el uso de maven

#### Creacion de una plantilla de proyecto usando maven:

```bash
mvn archetype:generate
```

- Nos pediran escoger que tipo de plantilla queremos por ende escogemos:

```bash
maven-archetype-quickstart
```

#### ver dependencias del proyecto

```bash
mvn dependency:tree
```

#### ver versiones y actualizar dependencias:

```bash
mvn versions:display-dependency-updates
```

#### Siempre luego de agregar una dependencia ejecutar:

```bash
mvn compile
```

#### Ejecutar programa desde la raiz del proyecto

```bash
mvn exec:java
```
