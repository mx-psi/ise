---
title: UEFI vs BIOS
author: Ingeniería de Servidores
date: Universidad de Granada
lang: es
fontfamily: arev
fontsize: 10pt
linestretch: 1
geometry: "a4paper, top=2.5cm, bottom=2.5cm, left=3cm, right=3cm"
colorlinks: true
bibliography: citas.bib
biblio-style: plain
link-citations: true
citation-style: estilo.csl
abstract:
  Resumen de entre 5-15 líneas. TODO.
  Praesent fringilla arcu vel urna placerat, nec pharetra nulla iaculis. Suspendisse dolor est, dapibus sed eleifend sit amet, elementum semper purus. Nam nec neque ligula. Sed convallis viverra tortor, vitae mattis lectus congue id. Pellentesque dui dui, faucibus eu tellus pellentesque, sagittis efficitur leo. Ut consequat sapien quis ipsum placerat eleifend. Nunc maximus tincidunt magna, ac tempor urna convallis vitae. Quisque at sapien est. Fusce ultrices auctor arcu vel scelerisque. Quisque sapien libero, efficitur id diam vel, sollicitudin lacinia erat. Pellentesque lobortis nunc mi. Suspendisse consectetur lacus nisi, vel tristique urna interdum at. Integer vehicula eu massa eleifend laoreet. Duis euismod velit sit amet quam sagittis, auctor feugiat ipsum volutpat. 
---

<!--
Cosas a tener en cuenta:
- Las figuras deben ir referenciadas. Las imágenes que sean estrechas deben ir a un lado.
- Las referencias bibliográficas irán numeradas y referenciadas: libros, cosas de fabricantes, revisiones de profesionales. 
- Hay que incluir transparencias.pdf con 8-12 transparencias y cuestionario.ods con 4-6 preguntas tipo test y soluciones relacionadas con el tema.
- Las referencias van entre corchetes y el nombre empieza con @: [@referencia]
-->

# Historia y visión general del arranque

## El inicio de los gestores de arranque

Los primeros ordenadores como el ENIAC (1946) no necesitaban un sistema de arranque: tras dar corriente a los distintos dispositivos y limpiar la memoria eran capaces de realizar cualquier operación[@mccartney1999eniac]. Los programas eran configurados manualmente y no se guardaban en memoria por lo que el sistema solo contaba con una forma de reiniciar la memoria de datos[@goldstine1946report pp.31].

Con la llegada de los primeros ordenadores comerciales, orientados al cálculo numérico en grandes empresas y agencias gubernamentales, surgió la necesidad de un sistema para cargar el programa inicial en memoria. Por ejemplo, los ordenadores de IBM  como el IBM 701 (1952) contaban con un botón para la carga inicial de un programa[@ibm701 pp.12 (1273)], como se describe en el manual de IBM 7030 (1962) [@ibm7030 pp.125-127]:

> El canal responsable de la interrupción lee un número de palabras específico de una zona de almacenamiento central. [...] El programa inicial [...] debe empezar con una palabra de control que especifica el número de palabras al leer y la dirección de memoria donde se halla la primera de ellas. [...] Cuando el programa ha sido leído el ordenador empieza automáticamente la ejecución del nuevo programa.

En el caso de los microcomputadores orientados al uso doméstico como el Altair 8800b (1975) el programa inicial debía escribirse manualmente utilizando unos interruptores de la parte delantera en un proceso difícil y largo[@freiberger2000fire].

<!--
TODO: No sé si añadirla pero para la presentación a lo mejor
![Imagen de un anuncio de Altair8800b. Los interruptores de la parte delantera permitían escribir cada palabra en la memoria interna indicando su estado bit a bit. De [Popular Electronics, 1975](http://www.swtpc.com/mholley/PopularElectronics/Jan1975/PE_Jan1975.htm) ](imgs/altair8800b.png) 
-->

<!-- El primer gestor de arranque-->
La posterior aparición de los sistemas operativos provocó la necesidad de crear un gestor de arranque que cargara de forma autónoma los datos necesarios para la inicialización, el primero de ellos llamado BIOS. El término **BIOS** apareció por primera vez en el sistema operativo CP/M diseñado por Gary Kildall en 1975 para designar la capa software que facilitaba la abstracción entre el *hardware* y el sistema operativo[@garykildall]. Este sistema podía ejecutarse sobre el procesador Intel 8080 y soportaba únicamente 64 KB de memoria. El sistema operativo de Microsoft MS-DOS expandió CP/M para añadir nuevas funcionalidades conservando la parte análoga a la BIOS[@abraham2013operating cap. 20, pp.901].

## La memoria ROM

La memoria ROM (del inglés *Read-Only Memory*) permitió el establecimiento del código inicial del gestor de arranque en una localización fija que el procesador podía leer al inicio. Es un tipo de memoria **no volátil**: su contenido no se borra cuando el sistema no tiene energía (como ocurre en la memoria RAM) y su modificación es un proceso difícil que no es posible durante la ejecución[@william2006computer Capítulo 5].

La modificación del gestor de arranque debía hacerse modificando esta memoria cuando fuese posible, proceso que variaba según el tipo de memoria[@william2006computer Capítulo 5, Types of ROM]:

- **PROM**: ROM programable eléctricamente, lo que permite la modificación no industrial
- **EPROM**: ROM borrable mediante exposición a luz ultravioleta. Puede ser modificada en múltiples ocasiones pero el proceso puede durar hasta 20 minutos
- **EEPROM**: ROM borrable elécricamente. Este tipo de memoria puede ser actualizada *in situ* pero el proceso tarda varios órdenes de magnitud más que la lectura (del orden de microsegundos)

Utilizando este tipo de tecnologías podían reprogramarse los gestores de arranque que luego eran leídos por el procesador. Este modelo es también el utilizado en la actualidad para los ordenadores personales [@guide2011intel sección 9.1.4]: los procesadores Intel x86 toman la primera instrucción de la dirección física `FFFFFFF0H` donde debe estar localizada la memoria (EP)ROM. También es el modelo utilizado por muchos sistemas embebidos[@abraham2013operating].

## Los ordenadores de IBM

<!--IBM PC Compatible y hablar de clones y de cómo llegó a ser importante BIOS-->
En la década de 1980 IBM produjo sus primeros PCs (*IBM Personal Computers*). El gran éxito de estos ordenadores hizo que otras compañías utilizaran la ingeniería inversa para producir ordenadores compatibles con esta arquitectura (llamados *IBM PC Compatibles*). La arquitectura de IBM se convirtió en un estándar *de facto* y la palabra PC en un término usual[@ibmpc], trayendo consigo el uso generalizado de la estructura de la BIOS de estos ordenadores. 

Describimos la estructura y el funcionamiento de la BIOS en la sección posterior.

## La llegada de UEFI

<!--TODO: Creo que mejor que hagas esto tú Josema-->

# BIOS

BIOS (del inglés *Basic Input/Ouput System*) es el *firmware* de arranque de los PCs de IBM y de la mayor parte de PCs antes del establecimiento de UEFI. Es el **componente software de más bajo nivel** de un ordenador. En términos generales consiste en una rutina que prueba los componentes del sistema y carga el sistema operativo y los *drivers* necesarios para su uso [@phoenix1989system pp. 1 (30)]. Inicialmente se incorporaba en los disquetes que traían el sistema operativo pero posteriormente se añadió a la memoria ROM de la placa base. Estaba diseñado para microprocesadores basados en la arquitectura Intel 80x86.

La BIOS servía además como una **capa de abstracción** entre el *hardware* y el sistema operativo, permitiendo modificar el hardware de manera independiente. Este era el caso de PC-DOS y MS-DOS, los sistemas operativos que predominaban en el mercado a finales de los años 80 [@phoenix1989system p. 2 (31)].

Dado que la BIOS es un estándar *de facto* hay varios tipos de la misma con variaciones entre empresas y modelos de ordenador. Describimos en esta sección las características de forma general salvo que se indique lo contrario.

El funcionamiento general de la BIOS se basa en la interacción con las interrupciones *hardware* que proveen los procesadores Intel. Una interrupción es una señal del procesador que indica un evento que debe ser atendido inmediatamente. La CPU entonces interrumpe su ejecución y transfiere la ejecución a una localización fija[@abraham2013operating Sección 1.2.1]. Las interrupciones pueden provenir del procesador del hardware, del software o del usuario. En los sistemas con BIOS una serie de interrupciones estaban reservadas para esta[@phoenix1989system pp. 35-36].

## El proceso de arranque

Aunque existen diferencias en función de la implementación o el tipo de BIOS el proceso de arranque en ordenadores compatibles con IBM sigue en términos generales los siguientes pasos[@abraham2013operating Sección 2.10]:

- El procesador comienza **inicializando** los registros y tomando la primera instrucción de la memoria EPROM[@guide2011intel sección 9].
- Se ejecuta el **POST** (del inglés *Power On Self-Test*) que comprueba e inicializa los dispositivos[@phoenix1989system].
- (Dependiendo del sistema operativo) se construye la información necesaria para el ACPI (del inglés *Advanced Configuration and Power Interface*), que permite que el sistema operativo se encargue de la gestión del uso de energía por los distintos componentes [@abraham2013operating sección 19.3.3.11]
- Si la comprobación ha sido correcta la BIOS busca en una lista de dispositivos hasta que encuentra uno inicializable y **transfiere la ejecución** a este[@abraham2013operating].

Es posible introducir ROMs opcionales que modifiquen alguna parte del proceso reemplazando el código[@phoenix1989system].

### Power on self-test

Antes de poder utilizar un IBM PC compatible hay que comprobar e inicializar sus componentes. Esta etapa es conocida como **POST**. Un fallo del proceso POST provoca un error del sistema que indica el error por medio de pitidos sonoros[@phoenix1989system Capítulo 6] o por medio del puerto 80 en las placas base más recientes. 

Los componentes de la placa base del PC se comprueban primero entre ellos se comprueba: la CPU, la ROM donde se guarda la BIOS, el controlador DMA (del inglés *Direct Memory Access*) del procesador, el controlador del teclado y la RAM. A continuación se comprueban otros componentes como el teclado, los discos o cualquier tipo de hardware adicional[@phoenix1989system Capítulo 6].

En esta parte del proceso también se comprueban en las placas base recientes (aquellas que siguen el *BIOS Boot Specification*) los dispositivos IPL (del inglés *Initial Program Load Device*, que pueden inicializarse) y se crea una lista con prioridad de los dispositivos disponibles[@compaq1intel].

### Master Boot Record e inicialización

Tras realizar las comprobaciones de POST se llama a la interrupción `INT 19h` que ejecuta el código de carga del *bootstrap*.  La BIOS busca en una lista de dispositivos prefijada un dispositivo de memoria no volátil inicializable (es decir, que contenga un bloque que indique cómo debe inicializarse) hasta que encuentra uno. En las primeras versionas comprueba los CDs (y en máquinas antiguas los disquettes) y a continuación mira en los discos duros[@phoenix1989system Capítulo 16], mientras que en las más recientes sigue la *BIOS Boot Specification* descrita en la sección anterior. Si el dispositivo en cuestión tuviera su inicialización protegida por contraseña la BIOS preguntaría en este paso por la misma (ver sección de *Seguridad* para más detalles en este paso).

Si la BIOS no encontrara un dispositivo que pueda inicializar llamaría a la interrupción `INT 18h` que puede llamar a una rutina que permita al sistema ser inicializado via red, inicializar un intérprete de BASIC o mostrar un mensaje indicando la falta de dispositivos inicializables.

Una vez encontrado la BIOS indica al controlador de este disco que lee el primer sector del disco a memoria (a una posición fija, `0000:7C00h`) y empieza a ejecutar el código. Este contiene el MBR (del inglés, *Master Boot Record*), que consta de una tabla de las particiones del disco que indica de dónde debe cargarse el sistema operativo[@abraham2013operating sección 10.5.2]. Contiene además código que lee esta tabla de particiones, comprueba qué particiones están *activas* (es decir, marcadas como inicializables) y lee el primer sector de la partición correspondiente[@tldpPartitions].

Este primer sector de una partición se conoce como *boot sector* y contiene el código necesario para leer los primeros bloques del sistema operativo a iniciar o de un *boot loader* como GRUB a una posición fija del disco. Finalmente se ejecuta las instrucciones leídas dando paso al sistema operativo o al *boot loader*[@tldpBoot].

### Tipos de particiones

El Master Boot Record permite hasta 4 *particiones primarias* (numeradas de 1 a 4) y particiones lógicas adicionales (a partir de 5). La tabla de la que consta especifica la localización en el disco en la que comienza cada tabla, con un formato que depende del sistema operativo[@manfdisk].

Las particiones constan de un identificador que identifica el tipo de la partición y su uso: si está vacía, qué sistema de archivos contiene o si es un partición *swap* por ejemplo[@tldpPartitions].


## La BIOS como capa de abstracción

Los sistemas operativos más recientes como aquellos basados en GNU/Linux o las versiones recientes de Windows sólo utilizan la BIOS para su inicialización pero los sistemas antiguos la utilizaban además como una capa de abstracción con respecto del *hardware*: por medio de las interrupciones del procesador podía interaccionarse con los distintos componentes sin necesidad de conocer o adaptarse a las características específicas del dispositivo[@phoenix1989system].

Algunos ejemplos de estas formas de interacción son el uso del teclado (`INT 09h` e `INT 16h`), del sistema de vídeo (`INT 10h`), la lectura de discos (`INT 13h`) y otros servicios como la obtención del tiempo (`INT 1Ah`). Esta interacción estaba basada en funciones que toman sus argumentos de los registros del procesador
[@phoenix1989system] [@tldpPartitions]. En sistemas más recientes es el sistema operativo el que captura estas excepciones y provee de un método para realizarlas.

## Modificaciones

## Implementaciones

BIOS es un estándar *de facto*, es decir, no existe una especificación estándar de su funcionamiento o su implementación (salvo de algunas modificaciones o tecnologías específicas que se describen en la sección *Modificaciones*), por lo que, dependiendo del fabricante, existen varias versiones del mismo. Las implementaciones más importantes son:

- **Phoenix BIOS** y **AwardBIOS**, de la empresa *Phoenix Technologies*, una de las primeras en conseguir clonar la especificación origina de IBM [@phoenix1989system] [@awardbios].
- **AMI BIOS**, de *American Megatrends*, una de las BIOS más utilizadas que en la década de los 90 tenía más del 75% del mercado[@amibios].
- **SeaBIOS**, una implementación libre utilizada en la actualidad por sistemas libres como coreboot[@seabios].

## Limitaciones
## Seguridad

Como medida de seguridad antes de la inicialización de un disco (u otro dispositivo inicializable) puede introducirse una contraseña. La BIOS preguntará en cada inicio de este dispositivo por esta contraseña, dando un total de 3 intentos. En el caso de que esta sea introducida de forma incorrecta estas 3 veces el sistema se detiene y no podrá intentar inicializarse de nuevo hasta que se produzca un reinicio[@phoenix1989system].

<!--Cómo poner una contraseña y qué hacer si se nos olvida (quitar la pila) -->

# UEFI

## Transición 
<!--Por qué hemos pasado de BIOS a UEFI-->
## El estándar
<!--Quién lo define y donde está-->
## Seguridad
<!--Cómo poner una contraseña y qué hacer si se nos olvida (quitar la pila) -->

<!--
TODO:
No he encontrado nada de nada en servidores salvo https://firmware.intel.com/sites/default/files/STTS001%20-%20SF15_STTS001_100f.pdf
En clase dijo que podíamos hablar de "Firmware de racks que controla y monitoriza el rack y sus componentes (más específico de servidores y CPD [centro de procesamiento de datos ])"
-->
# Alternativas libres: libreboot y coreboot

# Conclusiones finales

\newpage
# Referencias
