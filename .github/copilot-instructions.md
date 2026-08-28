# Información para el sistema San Gabriel 5.4

## Memoria de Sesiones (Gemini CLI)
- **Log de Progreso:** Cada vez que inicies una nueva sesión, debes leer obligatoriamente el archivo `LOG_DESARROLLO_REDA.md`. Esto te permitirá recordar automáticamente todos los trabajos realizados anteriormente sin que el usuario tenga que repetirlos.
- **Registro de Avances:** Al finalizar una tarea importante, actualiza dicho archivo con un resumen técnico de los cambios.
- **Exportación de Conversaciones:** Para guardar el diálogo literal, utiliza el comando `/chat share last_chat_export.md` en la terminal de Gemini CLI y luego ejecuta el script `./registrar_sesion.sh` en la terminal de la aplicación.

## Estilo de Código General
- Los comentarios deben estar en español.
- Usar nombres de variables descriptivos en español.

## Estilos CSS

## JavaScript Específico
- Utiliza la sintaxis moderna de ES6+ (`const`, `let`, funciones flecha).
- Se usará javascript puro con jquery. Aprovechando al máximo jquery y cualquier otra librería de javascript que permita simplificar el código y economizar tiempo de desarrollo.

Las peticiones ajax tendrán esta estructura:
    Función llamadora:
        import { eliminarExperiencia } from './eliminarExperiencia.js';

        (function( $ ) {
        "use strict";
        const containerId = '#index_experiencias';
        if ($(containerId).length) {
            $(function() {
                $(document).on('click', '.btn-eliminar-experiencia', async function(e) {
                    e.preventDefault();
                    const respuestaEliminarExperiencia = await eliminarExperiencia(id);
                    if (respuestaEliminarExperiencia.success) {
                        //
                    } else {
                        //
                    }
                });
            });
        }
        })(jQuery);

    Función llamada:
        // import ...

        export const eliminarExperiencia = (idExperiencia) => {
            return new Promise((resolve) => {
                (function( $ ) {
                    $.ajax({
                        url: APP_URL + '/reda/experiencias/eliminar-experiencia/' + idExperiencia, // Ajusta la ruta según tu web.php
                        type: 'DELETE',
                        data: {
                            "_token": $('meta[name="csrf-token"]').attr('content'),
                        },
                        success: function(data) {
                            resolve(data);
                        },
                        error: function (x, xs, xt) {
                            // 1. Intentamos obtener el JSON que el servidor envió junto con el error 400
                            let respuestaServidor = {};
                            try {
                                // x.responseText contiene el cuerpo del JSON enviado por Laravel
                                respuestaServidor = JSON.parse(x.responseText);;
                            } catch (e) {
                                respuestaServidor = {};
                            }
                            console.log('respuestaServidor', respuestaServidor);

                            const mensajeErrorBase = window.RedaAlojamientoJson["Error en el servidor de Torbian"] || 'Error en el servidor de Torbian';
                            const detalleError = respuestaServidor.message ? `<br />${respuestaServidor.message}` : '';

                            // 2. Construimos la respuesta usando los datos reales del servidor si existen

                            let respuesta = {
                                'success': false,
                                'message' : window.RedaAlojamientoJson["Error eliminando experiencia"] || 'Error eliminando experiencia',
                                'mensaje_usuario': respuestaServidor.mensaje_usuario ?? `${mensajeErrorBase}.${detalleError}`,
                                'respuesta': respuestaServidor.respuesta || '',
                                'code': x.status !== 0 ? x.status : 504,
                            };
                            resolve(respuesta);
                        }
                    })
                })(jQuery);
            });
        }
Siempre que se haga una petición ajax se debe mostrar una animación "Espera" hasta que responda el servidor
Esas reglas de las peticiones ajax son solo para los archivos nuevos que se creen. Si los archivos originales del proyecto no cumplen con esas reglas se dejan como están.

## Herramienta de desarrollo

## PHP
- Para la conexión a base de datos, usa la librería `PDO`. Nunca uses funciones antiguas como `mysql_*`.

Las respuestas del servidor para funciones internas y peticiones ajax tendrán esta estructura:
    $respuesta = [
        'success' => true,
        'message' => __('Experiencia eliminada'), // Un mensaje corto para uso del desarrollador o soporte técnico
        'mensaje_usuario' => __(Experiencia eliminada con exito'), // Un mensaje explicativo y traducido para el usuario
        'respuesta' => '', // La respuesta esperada por la función llamadora, puede ser '', un string, vector u objeto
        'code' => 200
    ];
    return response()->json($respuesta, $respuesta['code']);

Esa estructura de respuesta debe aplicarse para cualquier tipo de función en el servidor, en los controladores y otros archivos que ejecute funciones globales, ya que si por ejemplo se accede a la base de datos o tal vez una respuesta negativa de una API externa, puede ocurrir un error y el detalle de ese error debe ir en el atributo "respuesta" y cuando todo es positivo y la función llamadora necesita una respuesta, tal vez un string, un valor numérico, un vector u objeto eso debe ir en el atributo "respuesta" y la función llamadora accedería a ese atributo para obtener la respuesta requerida y ejecutar algún otro proceso dependiendo de la respuesta o tal vez mostrarla al usuario.
Si por ejemplo en alguna respuesta de una función el atributo "respuesta" del json no aplica o no hace falta se debe enviar entonces un cadena vacía, pero siempre deben estar todos los atributos de la estructura de la respuesta, por ejemplo:

    $respuesta = [
        'success' => true,
        'message' => __('Experiencia eliminada'),
        'mensaje_usuario' => __(Experiencia eliminada con exito'),
        'respuesta' => '', // Si no hay nada que enviar se asigna un cadena vacía, pero siempre deben estar presentes todos los atributos de la estructura de la respuesta
        'code' => 200
    ];

## Traducciones

## PC LOCAL, servidor del IDE Cloud Shell Editor y servidor VESTA DE DESARROLLO

## Escribir en el log de Cakephp

## Interacción con la IA
Por favor explicar de manera pedagógica cualquier cambio realizado en el plugin o cualquier código nuevo agregado. Cuando sean cambios particionar la pantalla, en el lado izquierdo mostrar el archivo original completo y en el lado derecho el archivo modificado completo. Resaltando con color las líneas modificadas, eliminadas o agregadas y mostrar la opción de aceptar o rechazar el cambio

## Autorización de codigo nuevo o modificado
Cuando se terminen de agregar código nuevo en un archivo o se haya modificado el existente, siempre se debe hacer una pausa y mostrar los cambios en una pantalla dividida en dos: En el lado izquierdo el archivo original y en el derecho el archivo con las sugerencias de código nuevo o modificado, con un botón de aceptar o rechazar y siempre se debe esperar que yo ACEPTE O RECHACE el código por favor

## Manipulación de imágenes

## Íconos personalizados .svg

## Paginación
Siempre que se cree una lista debe usarse la paginación de 10 en 10 en el controlador y en la vista con sus respectivos controles de paginación en la parte de abajo
Cuando se haga clic o se toquen los botones de control de paginación hacia atrás o hacia adelante de debe mostrar una animación de "Espera" hasta que responda el servidor
En todas las vistas de índice, listados se deben mostrar los controles de paginación indistintamente si existen más de 10 elementos en ese listado. Si por ejemplo en un listado hasta ahora hay guardado en la base 5 elementos que está por debajo del 10 estandar, igual se muestren los controles de paginación pero deshabilitado porque realmente no hay nada que paginear

## Creación de nuevas vistas

## Procesos de cambios masivos

## Formatos numéricos PHP

## Animación de espera en el frontend

## Subida de archivos al servidor Vesta de Desarrollo

## Documentación del sistema
Todos los archivos que se creen deben documentarse al inicio del archivo. Crear un resumen de lo que hace el archivo. Así también cada función que contenga ese archivo debe documentarse
Además de documentar individualmente cada archivo, cada vez que se cree un archivo se debe agregar un resumen de la documentación de ese archivo en manual_tecnico_sistema.md : Se coloca el nombre del archivo como un título y luego dejando una sangría se coloca el resumen.
Si se modifica el archivo se debe modificar tanto el resumen que se hace directamente en el archivo como el resumen en el archivo manual_tecnico_sistema.md
Si se modifica alguna función de un archivo Javascript o Php también debe actualizarse la documentación de la función
