# ISee

Proyecto de aplicacion para gestionar entretenimiento, capitulos de series, viendo ,vistas o viendo, además de otras categorias creadas

## Dispositivos Compatibles con la aplicación

La aplicación iSee solo se puede ejecutar en dispositivos de iPhone 6 o posterior, en dispositivos de menor tamaño u de mayor puede ejecutarse aunque los elementos no se mostrarán correctamente en algunas vistas
Para ejecutar el proyecto, dentro del archivo ejecutar el iSee.xcodeproj
El proyecto tiene persistencia de datos por lo que se guardan los cambios de una ejecución a otra y entre vistas.

## Manual de usuario

### Inicio
 En esta vista se muestran las series u elementos que el usuario ha marcado como viendo, en las celdas se muestra la imagen, el nombre de la serie u elemento arriba a la izquierda, debajo, la temporada y capitulo ultimo que marcó como visto.
Si se marcó una temporada y un capitulo, se mostrará el ultimo capitulo marcado de la ultima temporada.
Si no hay capitulo marcado, solo la ultima temporada que se esta viendo
Si no hay temporadas, se muestra “ninguna”


<img width="335" alt="Captura de pantalla 2023-09-30 a las 15 34 35" src="https://github.com/jamv0007/ISee/assets/84525141/0f97283e-091c-4908-89c8-488e439db7a9">


Después esta la puntuación y bajo esta la categoría a la que pertenece.
Al tocar una celda no lleva a ningún lado, es solo informativa

### Categorias
La vista de categorías es esta, el botón superior izquierdo permite ordenar alfabéticamente y cambia al siguiente estado, de la a-z, z-a, orden de inserción. Ademas hay una barra de búsqueda para buscar directamente.
El botón del + permite añadir una nueva categoría, mínimo hay que rellenar el campo nombre de la categoría para poder guardar. La foto se puede seleccionar tocando la imagen.

<img width="890" alt="Captura de pantalla 2023-09-30 a las 15 35 37" src="https://github.com/jamv0007/ISee/assets/84525141/b51ffd3d-a8b9-4481-8bf3-af4fc693d3c3">
<img width="277" alt="Captura de pantalla 2023-09-30 a las 15 36 11" src="https://github.com/jamv0007/ISee/assets/84525141/0d5809a2-b1a4-47d3-b2a6-f1755d50ec8f">

 Al mantener pulsado unos segundos una categoría, nos despliega un menú para editar la categoría o eliminarla, ademas al eliminar, nos muestra un mensaje de confirmación
 
 <img width="757" alt="Captura de pantalla 2023-09-30 a las 15 36 36" src="https://github.com/jamv0007/ISee/assets/84525141/f180a68b-9313-4448-82ee-d3c7aaf0d214">
 
La opción de editar abre la ventana de añadir pero autorellena con los datos de dicha categoría.

<img width="251" alt="Captura de pantalla 2023-09-30 a las 15 37 19" src="https://github.com/jamv0007/ISee/assets/84525141/eaa209a4-0b01-4162-bc94-d2520aafb63a">

Al pulsar sobre una categoría, nos lleva a la lista de series.



### Series
Aquí podemos ver la lista de series u elementos añadidos. Tenemos una flecha para volver a categorías, un icono de ordenación alfabética como en categorías, y un botón de añadir.
Hay una barra de búsqueda para filtrar por nombre. Las celdas de otro color indican que se han finalizado de ver esa serie y por lo tanto no aparecerán en inicio da igual si están marcadas como viendo o no. Los datos que aparecen son los mismos que en inicio a excepción del switch para marcar si se esta viendo o no.
El botón de + permite añadir una serie en la siguiente vista. El botón de guardar se habilita cuando se rellene el campo de nombre al menos. Se puede seleccionar una imagen pulsando sobre ella, añadir una puntuación y añadir temporadas y capítulos con el botón de abajo.

<img width="814" alt="Captura de pantalla 2023-09-30 a las 15 38 22" src="https://github.com/jamv0007/ISee/assets/84525141/c0a6edff-3fd0-4471-b787-bc3cb2e21044">


 Ese botón nos lleva la pagina para añadir temporadas, donde tenemos otro + para añadir a la lista una nueva temporada con el siguiente numero, si le damos otra vez, añadirá la 3a temporada. La papelera, borra la ultima, añadida, aunque antes nos mostrará una alerta con esta información y botón para confirmar. Podemos volver atrás con la flecha pero guarda el progreso de esta página.
Cada temporada tiene un cursor de viendo y dos botones uno para añadir capítulos y otro para la fecha de salida de la temporada.
Los capítulos nos aparece una ventana con un campo para escribir el nuevo numero de capítulos aunque también muestra el anterior para tener referencia. Los capítulos se borrarán si se pone un numero menor al que hay, si hay 100 y en el campo se introducen 80, esos 20 se borran con su contenido incluido. Por lo contrario si se aumenta, no se borraran los que hay ni su contenido solo se añade la diferencia.
Para la fecha se despliega un date picker para seleccionar la fecha y se rellena el campo.

<img width="1008" alt="Captura de pantalla 2023-09-30 a las 15 38 51" src="https://github.com/jamv0007/ISee/assets/84525141/9bf698a9-76a3-4fd7-a833-588ea6facbe4">


 Al mantener pulsado una serie obtenemos un menú, con varias opciones. Editar nos lleva a las mismas pantallas que añadir solo que ya están rellenas con esa información solo para editar dicha información. Compartir abre la ventana para coger la red social para compartirla.
 
 <img width="841" alt="Captura de pantalla 2023-09-30 a las 15 39 12" src="https://github.com/jamv0007/ISee/assets/84525141/45964be0-171c-497b-a33f-a545dad17010">

Marcar cómo terminada cambia el color de la celda a Azul y significa que esta terminada de ver. Si ya esta en este estado y se le da otra vez se desactiva.
Eliminar, nos muestra la alerta de confirmación.



### Lista de temporadas
En esta pantalla se muestran la lista de temporadas que se han añadido antes. Cada una tiene un switch para indicar si se esta viendo o no, que estará en el mismo estado que cuando se añaden. Ademas una barra de búsqueda para buscar por numero de
temporada. Podemos volver atras con la flecha.

<img width="431" alt="Captura de pantalla 2023-09-30 a las 15 39 55" src="https://github.com/jamv0007/ISee/assets/84525141/4abea817-8568-4b8c-8ab5-8386010d3b65">

### Lista de capítulos
Nos muestra la lista de capítulos de la temporada siempre que los hayamos añadido. Hay un switch para marcar si esta visto o no y una barra para buscar por numero. El botón de atrás permite ir a la pantalla anterior y el de info muestra la fecha y el numero de capítulos de la temporada.

<img width="967" alt="Captura de pantalla 2023-09-30 a las 15 41 02" src="https://github.com/jamv0007/ISee/assets/84525141/f7c45f31-7ab0-4686-918e-067e538fc5b8">


### Comentarios
Nos muestra una lista de los comentario añadidos a ese capitulo. El botón de arriba a la derecha permite añadir uno nuevo. Al pulsarlos se puede ver el contenido con claridad.
Bajo el titulo se puede escribir el texto y deben estar ambos rellenos para guardar.

<img width="938" alt="Captura de pantalla 2023-09-30 a las 15 41 35" src="https://github.com/jamv0007/ISee/assets/84525141/9fd1aba8-01ed-42ad-b469-3d6e20881e9e">


Al mantener pulsado uno, se despliega un menú para eliminar o compartir. Con la misma funcionalidad que otras pantallas.

  <img width="918" alt="Captura de pantalla 2023-09-30 a las 15 42 03" src="https://github.com/jamv0007/ISee/assets/84525141/5bb4265b-4af9-47e1-a085-1934928e4474">
