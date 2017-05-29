---
title: UEFI vs BIOS
author: Ingeniería de Servidores
date: Universidad de Granada
lang: es
mainfont: Arial
fontsize: 10pt
linestretch: 1
geometry: "a4paper, top=2.5cm, bottom=2.5cm, left=3cm, right=3cm"
colorlinks: true
bibliography: citas.bib
biblio-style: plain
link-citations: true
citation-style: estilo.csl
abstract: "El nacimiento de los sistemas operativos provocó la necesidad de la creación de gestores de arranque: programas que cargan los datos e instrucciones necesarias en memoria para la ejecución del sistema operativo. Se discute la historia de los gestores de arranque y sus distintas versiones, motivando su uso y las tecnologías necesarias para utlizarlo. A continuación se discute la creación y uso de BIOS en los sistemas IBM originales así como en los más recientes, sus características, limitaciones y posibles modificaciones y aspectos de seguridad. Se compara con el sistema unificado UEFI que permite la estandarización de los gestores de arranque y se discuten sus principales características: TODO"
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

Los primeros ordenadores como el ENIAC (1946) no necesitaban un sistema de arranque: tras conectar a la red eléctrica los distintos dispositivos y limpiar la memoria eran capaces de realizar cualquier operación[@mccartney1999eniac]. Los programas eran configurados manualmente y no se guardaban en memoria, por lo que el sistema sólo contaba con una forma de reiniciar la memoria de datos[@goldstine1946report pp.31].

Con la llegada de los primeros ordenadores comerciales, orientados al cálculo numérico en grandes empresas y agencias gubernamentales, surgió la necesidad de un sistema para cargar el programa inicial en memoria. Por ejemplo, los primeros ordenadores de IBM como el IBM 701 (1952) contaban con un botón para la carga inicial de un programa[@ibm701 pp.12 (1273)], como se describe en el manual de IBM 7030 (1962) [@ibm7030 pp.125-127]:

> El canal responsable de la interrupción lee un número de palabras específico de una zona de almacenamiento central. [...] El programa inicial [...] debe empezar con una palabra de control que especifica el número de palabras a leer y la dirección de memoria donde se halla la primera de ellas. [...] Cuando el código ha sido leído el ordenador empieza automáticamente la ejecución del nuevo programa.

En el caso de los microcomputadores orientados al uso doméstico como el Altair 8800b (1975) el programa inicial debía escribirse manualmente utilizando unos interruptores de la parte delantera en un proceso difícil y largo[@freiberger2000fire].

<!--
TODO: No sé si añadirla pero para la presentación a lo mejor
![Imagen de un anuncio de Altair8800b. Los interruptores de la parte delantera permitían escribir cada palabra en la memoria interna indicando su estado bit a bit. De [Popular Electronics, 1975](http://www.swtpc.com/mholley/PopularElectronics/Jan1975/PE_Jan1975.htm) ](imgs/altair8800b.png) 
-->

<!-- El primer gestor de arranque-->
La posterior aparición de los sistemas operativos provocó la necesidad de crear un gestor de arranque que cargara de forma autónoma los datos necesarios para la inicialización, el primero de ellos llamado BIOS (del inglés, *Basic Input/Output System*). El término **BIOS** apareció por primera vez en el sistema operativo CP/M (1975) para designar la capa software que facilitaba la abstracción entre el *hardware* y el sistema operativo[@garykildall]. Este sistema podía ejecutarse sobre el procesador Intel 8080 y soportaba únicamente 64 kB de memoria. El sistema operativo de Microsoft MS-DOS expandió CP/M para añadir nuevas funcionalidades conservando la parte análoga a la BIOS[@abraham2013operating cap. 20, pp.901].

## La memoria ROM

La memoria ROM (del inglés *Read-Only Memory*) permitió el establecimiento del código inicial del gestor de arranque en una localización fija que el procesador podía leer al inicio. Es un tipo de memoria **no volátil**: su contenido no se borra cuando el sistema no tiene energía (como ocurre en la memoria RAM) y su modificación es un proceso difícil que normalmente no es posible durante la ejecución[@william2006computer Capítulo 5].

La modificación del gestor de arranque debía hacerse modificando esta memoria cuando fuese posible, proceso que variaba según el tipo de memoria[@william2006computer Capítulo 5, Types of ROM]:

- **PROM**: ROM programable eléctricamente, lo que permite la modificación no industrial mediante la aplicación de corriente eléctrica.
- **EPROM**: ROM borrable mediante exposición a luz ultravioleta. Puede ser modificada en múltiples ocasiones pero el proceso puede durar hasta 20 minutos
- **EEPROM**: ROM borrable eléctricamente. Este tipo de memoria puede ser actualizada *in situ* pero el proceso tarda varios órdenes de magnitud más que la lectura (del orden de microsegundos)

Utilizando este tipo de tecnologías podían reprogramarse los gestores de arranque que luego eran leídos por el procesador. Este modelo es también el utilizado en la actualidad para los ordenadores personales [@guide2011intel sección 9.1.4]: los procesadores Intel x86 toman la primera instrucción de la dirección física `FFFFFFF0H` donde debe estar localizada la memoria (EP)ROM. También es el modelo utilizado por muchos sistemas embebidos (aunque estos nos necesitan un gestor de arranque: todo el código se encuentra normalmente en ROM)[@abraham2013operating].

## Los ordenadores de IBM

<!--IBM PC Compatible y hablar de clones y de cómo llegó a ser importante BIOS-->
En la década de 1980 IBM produjo sus primeros PCs (*IBM Personal Computers*). El gran éxito de estos ordenadores hizo que otras compañías utilizaran la ingeniería inversa para producir ordenadores compatibles con esta arquitectura (llamados *IBM PC Compatibles*). La arquitectura de IBM se convirtió en un estándar *de facto* y la palabra PC en un término usual[@ibmpc], trayendo consigo el uso generalizado de la estructura de la BIOS de estos ordenadores. 

Describimos la estructura y el funcionamiento de la BIOS en [la sección posterior](#bios). Esta arquitectura aunque útil para la época contaba con [grandes limitaciones](#limitaciones) y no estaba estandarizada en su totalidad, lo que hizo necesario el desarrollo de un estándar que la sustituyera: UEFI.

## La llegada de UEFI

Intel trató de desarrollar una alternativa a BIOS para su familia de procesadores Itanium, que al ser de 64 bits se verían especialmente [limitados por BIOS](#limitaciones), en el programa *Intel Boot Initiative*[@intelEFIandUEFI], que dio lugar a una nueva interfaz entre el *firmware* y el sistema operativo: la especificación *Extensible Firmware Interface* (EFI). La versión 1.10 de EFI, que terminó siendo la última desarrollada por Intel, fue publicada en 2002 [@secureBoot].

Tres años después se formó el *Unified EFI Forum*, una organización sin ánimo de lucro formada por miembros de empresas tecnológicas punteras en la época que retomó el desarrollo de la especificación EFI, renombrándola a UEFI, y trató de implementarla y hacer de UEFI un estándar para las interfaces de *firmware* [@UEFIDell] [@intelEFIandUEFI].

<!-- TODO: puede mencionarse aquí la fecha en la que se introdujeron novedades importantes en UEFI y enlazar con su sección correspondiente en UEFI si la tienen -->

UEFI fue adoptado rápidamente en el mercado [@aTaleOfTwoStandards] por [sus numerosas ventajas respecto a BIOS](#BIOSaUEFI). La especificación UEFI se describe en [su sección correspondiente](#uefi).

# BIOS {#bios}

BIOS es el *firmware* de arranque de los PCs de IBM y de la mayor parte de PCs antes del establecimiento de UEFI. Es el **componente software de más bajo nivel** de un ordenador. En términos generales consiste en una rutina que prueba los componentes del sistema y carga el sistema operativo y los *drivers* necesarios para su uso [@phoenix1989system pp. 1 (30)]. Inicialmente se incorporaba en los disquetes que traían el sistema operativo pero posteriormente se añadió a la memoria ROM de la placa base. Estaba diseñado para microprocesadores basados en la arquitectura Intel 80x86.

La BIOS servía además como una **capa de abstracción** entre el *hardware* y el sistema operativo, permitiendo modificar el hardware de manera independiente. Este era el caso de PC-DOS y MS-DOS, los sistemas operativos que predominaban en el mercado a finales de los años 80 [@phoenix1989system p. 2 (31)].

Dado que BIOS es un estándar *de facto* existen variaciones entre empresas y modelos de ordenador. Describimos en esta sección las características de forma general salvo que se indique lo contrario y listamos algunas de las variantes en la sección [*Implementaciones*](#implementaciones).

El funcionamiento general de la BIOS se basa en la interacción con las interrupciones *hardware* que proveen los procesadores Intel. Una interrupción es una señal del procesador que indica un evento que debe ser atendido inmediatamente. La CPU entonces interrumpe su ejecución y transfiere la ejecución a una localización fija[@abraham2013operating Sección 1.2.1]. Las interrupciones pueden provenir del procesador del hardware, del software o del usuario. En los sistemas con BIOS una serie de interrupciones estaban reservadas para ésta[@phoenix1989system pp. 35-36].

## El proceso de arranque {#arranqueBIOS}

Aunque existen diferencias en función de la implementación o el tipo de BIOS el proceso de arranque en ordenadores compatibles con IBM sigue en términos generales los siguientes pasos[@abraham2013operating Sección 2.10]:

- El procesador comienza **inicializando** los registros y tomando la primera instrucción de la memoria EPROM[@guide2011intel sección 9].
- Se ejecuta el [**POST**](#post) (del inglés *Power On Self-Test*) que comprueba e inicializa los dispositivos[@phoenix1989system].
- (Dependiendo del sistema operativo) se construye la información necesaria para el ACPI (del inglés *Advanced Configuration and Power Interface*), que permite que el sistema operativo se encargue de la gestión del uso de energía por los distintos componentes [@abraham2013operating sección 19.3.3.11]
- Si la comprobación ha sido correcta la BIOS [busca en una lista de dispositivos](#mbr) hasta que encuentra uno inicializable y **transfiere la ejecución** a este[@abraham2013operating].

Es posible introducir [ROMs opcionales](#modificaciones) que modifiquen alguna parte del proceso reemplazando parte del código[@phoenix1989system].

### Power on self-test {#post}

Antes de poder utilizar un IBM PC compatible hay que comprobar e inicializar sus componentes. Esta etapa es conocida como **POST**.

Los componentes de la placa base del PC se comprueban primero. Entre ellos se comprueba: la CPU, la ROM donde se guarda la BIOS, el controlador DMA (del inglés *Direct Memory Access*) del procesador, el controlador del teclado y la RAM. A continuación se comprueban otros componentes como el teclado, los discos o cualquier tipo de hardware adicional[@phoenix1989system Capítulo 6].

Un fallo del proceso POST es normalmente irrecuperable por lo que provocaría un error del sistema indicado por medio de pitidos sonoros[@phoenix1989system Capítulo 6] o por medio del puerto 80 en las placas base más recientes. 

En esta parte del proceso también se comprueban en las placas base recientes (aquellas que siguen el *BIOS Boot Specification*) los dispositivos IPL (del inglés *Initial Program Load Device*, que pueden inicializarse) y se crea una lista con prioridad de los dispositivos disponibles[@compaq1intel].

### Master Boot Record e inicialización {#mbr}

Tras realizar las comprobaciones de POST se llama a la interrupción `INT 19h` que ejecuta el código de carga del *bootstrap*.  La BIOS busca en una lista de dispositivos prefijada un dispositivo de memoria no volátil inicializable (es decir, que contenga un bloque que indique cómo debe inicializarse) hasta que encuentra uno. En las primeras versiones comprueba los CDs (y en máquinas antiguas los disquetes) y a continuación mira en los discos duros[@phoenix1989system Capítulo 16], mientras que en las más recientes sigue la *BIOS Boot Specification* descrita en la [sección anterior](#post). Si el dispositivo en cuestión tuviera su inicialización protegida por contraseña la BIOS preguntaría en este paso por la misma (ver sección de [*Seguridad*](#seguridad-bios) para más detalles en este paso).

Si la BIOS no encontrara un dispositivo que pueda inicializar llamaría a la interrupción `INT 18h` que, dependiendo del sistema, puede llamar a una rutina que permita al sistema ser inicializado vía red, inicializar un intérprete de BASIC o mostrar un mensaje indicando la falta de dispositivos inicializables.

Una vez encontrado el dispositivo la BIOS indica al controlador de este disco que lea el primer sector del disco a memoria (a una posición fija, `0000:7C00h`) y empieza a ejecutar el código. Este sector contiene el MBR (del inglés, *Master Boot Record*), que consta de una tabla de las particiones del disco que indica de dónde debe cargarse el sistema operativo[@abraham2013operating sección 10.5.2]. Contiene además código que lee esta tabla de particiones, comprueba qué particiones están *activas* (es decir, marcadas como inicializables) y lee el primer sector de la partición correspondiente[@tldpPartitions].

Este primer sector de una partición se conoce como *boot sector* y contiene el código necesario para leer los primeros bloques del sistema operativo a iniciar o de un *boot loader* como GRUB en una posición fija del disco. Finalmente se ejecutan las instrucciones leídas dando paso al sistema operativo o al *boot loader*[@tldpBoot].

### Tipos de particiones

El Master Boot Record permite hasta 4 *particiones primarias* (numeradas de 1 a 4) y particiones lógicas adicionales (a partir de 5). La tabla de la que consta especifica la localización en el disco en la que comienza cada tabla, con un formato que depende del sistema operativo[@manfdisk].

Las particiones constan de un identificador que identifica el tipo de la partición y su uso: si está vacía, qué sistema de archivos contiene o si es un partición *swap* por ejemplo[@tldpPartitions].


## La BIOS como capa de abstracción

Los sistemas operativos más recientes como los basados en GNU/Linux o las versiones recientes de Windows sólo utilizan la BIOS para su inicialización, pero los sistemas antiguos la utilizaban además como una capa de abstracción con respecto del *hardware*: por medio de las interrupciones del procesador podía interaccionarse con los distintos componentes sin necesidad de conocer o adaptarse a las características específicas del dispositivo[@phoenix1989system].

Algunos ejemplos de estas formas de interacción son el uso del teclado (`INT 09h` e `INT 16h`), del sistema de vídeo (`INT 10h`), la lectura de discos (`INT 13h`) y otros servicios como la obtención del tiempo (`INT 1Ah`). Esta interacción estaba basada en funciones que toman sus argumentos de los registros del procesador
[@phoenix1989system] [@tldpPartitions]. En sistemas más recientes es el sistema operativo el que captura estas excepciones y provee de un método para realizarlas.

## Modificaciones

La BIOS permite utilizar **ROMs opcionales** que modifican el comportamiento por defecto para añadir nuevas funcionalidades o permitir la compatibilidad con dispositivos hardware que no puedan manejarse con la BIOS por defecto[@zimmer2017beyond Foreword]. Algunas de ellas son:

- La **BBS** (del inglés, *BIOS Boot Specification*) es una de las extensiones más utilizadas. Esta es una especificación diseñada por Intel, Phoenix Tecnologies y Compaq en 1996 que permite la creación automática de una lista de dispositivos inicializables y permite cargar durante la etapa POST ROMs opcionales que añadan nuevas funcionalidades[@compaq1intel].
- La especificación **ACPI** para la gestión de la energía de los componentes de un PC también es parcialmente responsabilidad de la BIOS, que se encargaría de inicializar la memoria de las tablas ACPI y la memoria que deba ser guardada en periodos de hibernación[@hewlett2004microsoft sección 16.3.2]. Esta especificación ha sido implementada por empresas como Phoenix[@phoenixbiosRelease].
- El estándar **SCSI** permite la unificación de las interfaces de los dispositivos de almacenamiento periférico. Para permitir la inicialización por parte de uno de estos dispositivos se añade una ROM opcional que gestiona el proceso[@field2000book].

Además, mediante las opciones de configuración es posible modificar algunos aspectos de la ejecución de la BIOS. Esta configuración es específica de cada implementación y no existía en las primeras versiones. Normalmente es accesible pulsando F2 durante el arranque.

## Implementaciones {#implementaciones}

BIOS es un estándar *de facto*, es decir, no existe una especificación estándar de su funcionamiento o su implementación (salvo de algunas [tecnologías específicas](#modificaciones)), por lo que, dependiendo del fabricante, existen varias versiones del mismo. Las implementaciones más importantes son:

- **Phoenix BIOS** y **AwardBIOS**, de la empresa *Phoenix Technologies*, una de las primeras en conseguir clonar la especificación original de IBM [@phoenix1989system] [@awardbios].
- **AMI BIOS**, de *American Megatrends*, una de las BIOS más utilizadas que en la década de los 90 tenía más del 75% del mercado[@amibios].
- **SeaBIOS**, una implementación libre utilizada en la actualidad por sistemas de arranque libres como coreboot[@seabios].

## Limitaciones {#limitaciones}

El diseño de la BIOS no está estandarizado en su totalidad lo que provoca problemas de compatibilidad. Además cuenta con grandes limitaciones[@aTaleOfTwoStandards]:

- El Master Boot Record sólo permite 4 particiones primarias [@tldpPartitions] y, para un tamaño de bloque de 512 bytes, permite un tamaño máximo de partición de 2 TB, insuficiente para muchos dispositivos actuales[@ibmGPT].
- Es dependiente de la arquitectura *hardware* subyacente como la CPU: estaba basada en 16 bits cuando la arquitectura actual es de 64 bits y en el uso de interrupciones, lo que limita el diseño del *hardware*.
- Las ROMs opcionales están escritas en código ensamblador de 16 bits que asume una arquitectura tipo PC-AT [@UEFIspec sección 2.5.1]. Esto limita su tamaño a 1 MB e impide la compatibilidad con algunos dispositivos inicializables en servidores.
- La mayor parte de las implementaciones no tienen un diseño modular lo que dificulta la reutilización del código.


## Seguridad {#seguridad-bios}

Antes de la inicialización de un dispositivo puede configurarse una contraseña. La BIOS preguntará en cada inicio de este dispositivo por esta contraseña, dando un total de 3 intentos. En el caso de que esta sea introducida de forma incorrecta estas 3 veces el sistema se detiene y no podrá intentar inicializarse de nuevo hasta que se produzca un reinicio[@phoenix1989system].

Las BIOS más recientes (como por ejemplo las de los ordenadores de HP) disponen de otras opciones de seguridad como el uso de cuentas de administración y de usuario o la encriptación de discos duros[@BIOSHP]. Si se nos olvida la contraseña de la BIOS la única opción es quitar la pila de la placa base o restaurar el sistema de fábrica.


# UEFI {#uefi}

UEFI es una especificación de interfaz entre el *firmware* y el sistema operativo o cualquier otro tipo de aplicación que se ejecute prescindiendo de un sistema operativo anfitrión [@UEFIDell]. [En contraste con BIOS](#arranqueBIOS), no es un programa que ejecuta lo necesario para que arranque el sistema operativo. El arranque se gestiona a través de aplicaciones que se llaman entre ellas como se detalla en la sección de [arranque en UEFI](#arranqueUEFI).

La especificación UEFI incluye tablas de datos, servicios, protocolos y APIs con métodos disponibles para el sistema operativo y las aplicaciones y controladores que se ejecutan antes de la carga de este. Los dispositivos pueden incluir, en su propia memoria o a través de fuentes externas, sus propios controladores escritos en C [@UEFIspec sección 2.5.1], de forma que puedan funcionar bajo UEFI en cualquier arquitectura.

<!-- TODO: ¿extender? Puede no ser necesario extender si el resto de secciones explican todo en suficiente detalle -->

<!-- TODO: probablemente deberían mencionarse la EFI System Table (sección 4) y los servicios boot y runtime (secciones 6 y 7 respectivamente) -->

## Transición {#BIOSaUEFI}

El estándar UEFI cubre las [limitaciones de BIOS](#limitaciones) [@UEFIDell]:

- UEFI no requiere un tipo particular de tabla de particiones para ejecutar un sistema operativo, dado que, en lugar de esperar un formato *Master Boot Record* y leer los primeros sectores disponibles, el sistema operativo se carga a través de una aplicación UEFI. Esto permite a los sistemas operativos cargados desde UEFI usar otro tipo de tablas de particiones más extensible, como [GUID Partition Table](#gpt), descrito más adelante en su sección correspondiente.
- UEFI se basa en el uso de protocolos e interfaces de aplicación. Esto permite sustituir las interrupciones *hardware* que requiere BIOS y que dependen completamente del *hardware*.
- Los controladores UEFI, al igual que las aplicaciones UEFI, pueden estar en memorias de cualquier tipo (en el *firmware*, en unidades de almacenamiento masivo o en la memoria interna de una tarjeta PCI) y están escritos en C, de forma que son compatibles con distintas arquitecturas de 32 y 64 bits y se elimina la limitación de 1 MB de tamaño para las ROM opcionales.
- Al descomponer la rutina de inicio en aplicaciones UEFI, el código puede modularizarse sin trabas.

Todo ello, junto con la posibilidad que ofrece UEFI de desarrollar un entorno previo al arranque independiente del sistema operativo, la portabilidad de las aplicaciones y ROMs opcionales y la inclusión de [Secure Boot](#secureBoot) a partir de la versión 2.2, ha supuesto la imposición de UEFI en el mercado. La no compatibilidad de los sistemas operativos con UEFI durante los inicios de este no supuso un problema dado que UEFI dispone del *Compatibility Support Module*, CSM, que permite la carga bajo UEFI de sistemas operativos no adaptados a UEFI. <!-- TODO: hay más ventajas de UEFI que no son una respuesta directa a las limitaciones de BIOS -->

## El estándar

<!-- TODO: queda muy corto pero no sé qué más poner -->

Desde su *adopción* en 2005, el *UEFI Forum* se encarga de continuar con el desarrollo del estándar.

La última versión del estándar es la 2.6 errata A, que puede consultarse en [@UEFIspec].

## El arranque en UEFI {#arranqueUEFI}

A diferencia de lo que ocurre en BIOS, UEFI gestiona el arranque mediante una aplicación, ***Boot Manager***, que efectúa las rutinas equivalentes a las que ejecuta [BIOS](#bios) usando la interfaz proporcionada por UEFI [@UEFIDell].

El *Boot Manager* es la aplicación UEFI que se ejecuta inmediatamente después de la inicialización del *firmware* pertinente. Se encarga de ejecutar el código de los controladores y aplicaciones UEFI (estas últimas pueden incluir una aplicación que cargue un sistema operativo) en el orden definido por una variable global situada en una memoria no volátil que almacena una lista de variables también en memoria no volátil, cada una con, entre otros elementos, un puntero al dispositivo hardware implicado, un puntero a la imagen UEFI que contiene el código objeto en formato [EBC](#ebc) que debe ser ejecutado y un nombre que permite identificar el controlador o aplicación [@UEFIspec sección 3]. Estas variables permiten presentar una lista de posibles sistemas operativos que pueden ejecutarse desde el *firmware* del sistema, sin que previamente sea necesario comenzar a leer desde el dispositivo de almacenamiento que más prioridad tenga.

Tanto el *Boot Manager* como otras aplicaciones pueden ejecutar aplicaciones UEFI. Una vez que el código de una aplicación UEFI o de un controlador es cargado en memoria toma el control de la CPU, que puede devolver a la aplicación anterior en cualquier momento. Los controladores cargados en memoria pueden elegir si persisten o no según el código de finalización que devuelva su imagen. Si la aplicación es la que inicia el sistema operativo, tendrá que hacer esto mediante la interfaz que ofrece UEFI hasta que, usando la primitiva `EFI_BOOT_SERVICES.ExitBootServices()`, detiene todas las demás aplicaciones implicadas en el arranque y adquiere el control completo de la máquina [@UEFIspec sección 2.1].

### GUID Partition Table {#gpt}

Conocido como GPT, *GUID Partition Table* es un formato de tabla de particiones desarrollado por Intel para ser usado con EFI [@ibmGPT]. En el primer bloque lógico del disco se encuentra una estructura compatible con *Master Boot Record* para evitar que el disco sea interpretado erróneamente como vacío por *software* no compatible con GPT. A continuación se encuentra la tabla de particiones primaria, cada una con punteros a los bloques lógicos inicial y final de cada una de las hasta 128 particiones (por defecto) que admite GPT. Al final del disco se encuentra una copia de la tabla de particiones, de forma que si la primera es dañada puede recuperarse. [@UEFIspec sección 5.3]

Una de las novedades con más consecuencias respecto a *Master Boot Record* es el uso de punteros de 64 bits hacia los bloques lógicos, permitiendo el acceso completo a discos de 8 ZB (zettabytes) con 512 bytes como tamaño de bloque. Además, GPT incluye redundancia de datos sobre las particiones de un disco cuyo error no sería reparable (como la tabla de particiones) y sumas de verificación CRC32, no requiere el uso de particiones lógicas al permitir 128 particiones por defecto (además, el tamaño de la tabla de particiones es ampliable), utiliza 16 bytes para identificar las particiones reduciendo así la probabilidad de colisión de identificadores común en MBR (donde se usaba un byte para lo mismo) y permite la asignación de etiquetas a las particiones de forma independiente a las que use el sistema operativo (estas últimas no podrían ser usadas por otro sistema operativo o por cualquier producto *software* que trabaje fuera de un sistema operativo, como puede ser un programa de gestión de particiones tipo *gparted*) [@ibmGPT] [@UEFIspec sección 5.1].

## Modificaciones

En UEFI los controladores de los dispositivos se cargan como las aplicaciones UEFI, por lo que el concepto de *ROM opcional* aplicado a estos suele ser sustituido por el de *controladores UEFI* [@UEFIDell]. Sí conservan su nombre las ROM opcionales que hacen referencia a funcionalidades adicionales no relacionadas con la compatibilidad con dispositivos. En ambos casos, el código que ejecutan puede situarse en cualquier lugar que sea accesible desde el sistema (incluida la red local) y ser accedido en el momento del arranque que se desee modificando convenientemente las variables del *Boot Manager*.

### Modelo de controladores UEFI

UEFI usa un modelo de controladores con el objetivo de, según se describe en [@UEFIspec sección 2.5], facilitar y estandarizar el diseño y la implementación de los controladores y reducir el tamaño de las imágenes UEFI. A cambio se incrementa la complejidad de los controladores: deben ofrecer un protocolo de manejo de su dispositivo que garantice la abstracción de las operaciones que efectúa.

El modelo de controladores UEFI exige que los controladores estén escritos en C, garantizando la portabilidad de estos; facilita la relación entre el dispositivo y sus controladores (algunas ROM opcionales para BIOS pueden explorar todos los dispositivos del sistema hasta que encuentran el dispositivo con el que se corresponden) y permite ejecutar únicamente los controladores de los dispositivos requeridos para la ejecución del sistema operativo [@UEFIspec sección 2.5.1.3].

### *EFI Byte Code* {#ebc}

El procesador virtual de EFI Byte Code (EBC) permite disponer de un código objeto en formato EBC que puede utilizarse en distintos entornos *hardware* [@UEFIspec sección 21.1]. El estándar exige que el *firmware* compatible con UEFI pueda compilar desde C, enlazar e interpretar código objeto en formato EBC (y, por supuesto, describe cómo se pueden implementar estas funcionalidades dedicando para ello el capítulo 21).

### *Human Interface Infrastructure*

La configuración de la BIOS y las ROM opcionales disponían de diferentes menús. UEFI ofrece una *Human Interface Infrastructure*, HII, que permite unificar la interfaz de usuario y la lectura de los datos leídos por parte del usuario. La HII gestiona las cadenas de texto, los campos y las imágenes facilitadas por las ROM opcionales y por el menú de configuración del sistema y se encarga de mostrarlos con un formato uniforme, gestionando las fuentes, el manejo de los dispositivos de entrada y salida y la representación  de los campos, permitiendo la configuración del sistema antes y después del arranque del sistema operativo y facilitando la adaptación a distintos idiomas [@UEFIspec sección 31.1].

El estándar establece la existencia de una base de datos para HII que almacena los datos (fuentes, campos, texto e imágenes) de los distintos dispositivos y de un servicio, *Forms Browser*, que interpreta el contenido de la base de datos y prepara una vista de este en la que el usuario puede introducir cambios que serán guardados de forma permanente. El *Forms Browser* puede ser accedido y la configuración puede ser modificada antes del arranque (usando una tecla que varía entre distintos *hardware* e incluso entre distintas versiones del *firmware* de una misma máquina) y desde un programa dentro de un sistema operativo [@UEFIspec sección 31.2.11.1].

## Seguridad

### Actualización de *firmware*

El mantenimiento y actualización del *firmware* es un factor imprescindible para la seguridad del sistema. UEFI considera un protocolo de administración de *firmware* que facilita su actualización (o su reversión, según considere el operario) y la comprobación de la versión actual del mismo.

### Secure Boot {#secureBoot}

*SecureBoot* es un método de validación para el código ejecutado antes del arranque del sistema operativo. Para ello usa una base de datos de certificados digitales que coteja con los certificados que incluye cada sección del código de aplicaciones y controladores UEFI que esté a punto de ejecutar en cada momento, de forma que, en caso de discrepancia, el sistema puede omitir la ejecución del código afectado o notificar al usuario [@UEFIspec sección 30] [@secureBoot]. La propia base de datos de certificados digitales está cifrada con un par de claves pública/primaria, de forma que el conocimiento de la privada es necesario para poder modificarla.

Esta característica es opcional en la especificación UEFI y puede ser desactivada por el administrador de la máquina.

<!-- TODO: tal vez se pueden hacer más subsecciones de seguridad. ¿User Identification (sección 34 en las especificaciones UEFI)? ¿Secure Technologies (sección 35)? -->

<!--
TODO:
No he encontrado nada de nada en servidores salvo https://firmware.intel.com/sites/default/files/STTS001%20-%20SF15_STTS001_100f.pdf
En clase dijo que podíamos hablar de "Firmware de racks que controla y monitoriza el rack y sus componentes (más específico de servidores y CPD [centro de procesamiento de datos ])"
-->
# Alternativas libres: libreboot y coreboot

# Conclusiones finales

\newpage
# Referencias
