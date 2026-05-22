# API REST Despacho

API REST desarrollada con Spring Boot para administrar despachos de productos. El servicio expone operaciones CRUD sobre la entidad Despacho, integra persistencia con JPA y MySQL, documentación automática con OpenAPI y manejo centralizado de errores.

## Características

- Alta, consulta, actualización y eliminación de despachos.
- Persistencia con Spring Data JPA.
- Validación de solicitudes y respuestas de error normalizadas.
- Documentación interactiva con Swagger UI.
- Configuración de CORS para permitir consumo desde otros orígenes.
- Empaquetado con Docker mediante una imagen multietapa.

## Tecnologías

- Java 17
- Spring Boot 3.4.x
- Spring Web
- Spring Data JPA
- Spring Validation
- MySQL Connector/J
- Springdoc OpenAPI
- Lombok
- Docker

## Estructura del proyecto

```text
src/main/java/com/citt
├── config
│   ├── CorsConfig.java
│   └── OpenApiConfig.java
├── controller
│   └── DespachoController.java
├── exceptions
│   ├── DespachoNotFoundException.java
│   ├── RestResponseEntityExceptionHandler.java
│   └── dto
│       └── ErrorMessage.java
└── persistence
		├── entity
		│   └── Despacho.java
		├── repository
		│   └── DespachoRepository.java
		└── services
				├── DespachoService.java
				└── DespachoServiceImpl.java
```

## Requisitos

- Java 17 o superior.
- Maven 3.9 o superior, o el wrapper incluido en el proyecto.
- Acceso a una base de datos MySQL.
- Docker, si se va a ejecutar el servicio en contenedor.

## Configuración

La aplicación toma la configuración de base de datos desde variables de entorno.
El archivo application.properties utiliza estas variables:

```text
DB_ENDPOINT
DB_PORT
DB_NAME
DB_USERNAME
DB_PASSWORD
```

Además, el servicio arranca por defecto en el puerto 8081.

Ejemplo de archivo .env local:

```env
DB_ENDPOINT=localhost
DB_PORT=3306
DB_NAME=despacho_db
DB_USERNAME=root
DB_PASSWORD=secret
```

## Ejecución local

1. Crear la base de datos MySQL y ajustar las variables de entorno.
2. Compilar la aplicación.

```bash
./mvnw clean package
```

3. Ejecutar el servicio.

```bash
./mvnw spring-boot:run
```

La API quedará disponible en:

```text
http://localhost:8081
```

## Despliegue con Docker

El proyecto incluye un Dockerfile multietapa. La primera etapa construye el artefacto con Maven y la segunda genera una imagen liviana basada en una JRE de Java 17. El contenedor se ejecuta con un usuario no root.

### 1. Construir la imagen

Desde la raíz del proyecto:

```bash
docker build -t despacho-api:latest .
```

### 2. Ejecutar el contenedor

La aplicación escucha en el puerto 8081, por lo que el mapeo recomendado es el siguiente:

```bash
docker run -d \
	--name despacho-api \
	-p 8081:8081 \
	-e DB_ENDPOINT=host.docker.internal \
	-e DB_PORT=3306 \
	-e DB_NAME=despacho_db \
	-e DB_USERNAME=root \
	-e DB_PASSWORD=secret \
	despacho-api:latest
```

Si la base de datos también corre en Docker, puedes reemplazar DB_ENDPOINT por el nombre del servicio o contenedor MySQL en la misma red de Docker.

### 3. Verificar el servicio

Una vez iniciado el contenedor, valida la API en:

```text
http://localhost:8081/swagger-ui.html
```

## API disponible

Base path:

```text
/api/v1/despachos
```

### Endpoints

| Método | Ruta | Descripción |
| --- | --- | --- |
| GET | /api/v1/despachos | Obtiene todos los despachos. |
| GET | /api/v1/despachos/{idDespacho} | Obtiene un despacho por ID. |
| POST | /api/v1/despachos | Crea un despacho nuevo. |
| PUT | /api/v1/despachos/{idDespacho} | Actualiza un despacho existente. |
| DELETE | /api/v1/despachos/{idDespacho} | Elimina un despacho por ID. |

## Modelo de datos

La entidad principal es Despacho y contiene los siguientes campos:

- idDespacho
- fechaDespacho
- patenteCamion
- intento
- idCompra
- direccionCompra
- valorCompra
- despachado

## Manejo de errores

El proyecto centraliza respuestas de error para mantener un formato consistente:

- 404 Not Found cuando no existe un despacho con el ID solicitado.
- 400 Bad Request cuando la solicitud no cumple las validaciones esperadas.

## Documentación API

La documentación interactiva está disponible en Swagger UI y se configura desde OpenAPI en la clase OpenApiConfig.

Ruta:

```text
/swagger-ui.html
```

## Notas de implementación

- La aplicación permite CORS para facilitar el consumo desde frontends externos.
- La persistencia se apoya en JPA y MySQL con actualización automática del esquema configurada en hibernate.ddl-auto=update.
- El artefacto Docker se construye dentro de la propia imagen, por lo que no es necesario compilar manualmente antes de generar el contenedor.
