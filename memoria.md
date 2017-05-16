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

# Historia del arranque

## El inicio de los gestores de arranque

Los primeros ordenadores como el ENIAC (1946) no necesitaban un sistema de arranque: tras dar corriente a los distintos dispositivos y limpiar la memoria eran capaces de realizar cualquier operación[@mccartney1999eniac]. Los programas eran configurados manualmente y no se guardaban en memoria por lo que el sistema sólo contaba con una forma de reiniciar la memoria de datos[@goldstine1946report pp.31].

Con la llegada de los primeros ordenadores comerciales (orientados al cálculo numérico en grandes empresas y agencias gubernamentales) surgió la necesidad de un sistema para cargar el programa inicial de memoria. Por ejemplo los ordenadores de IBM  como el IBM 701 (1952) contaban con un botón para la carga inicial de un programa[@ibm701 pp.12 (1273)], como se describe en el manual de IBM 7030 (1962) [@ibm7030 pp.125-127]:

> El canal responsable de la interrupción lee un número de palabras específico de una zona de almacenamiento central. [...] El programa inicial [...] debe empezar con una palabra de control que especifica el número de palabras al leer y la dirección de memoria donde se halla la primera de ellas. [...] Cuando el programa ha sido leído el ordenador empieza automáticamente la ejecución del nuevo programa.

En el caso de los microcomputadores orientados al uso doméstico como el Altair 8800b (1975) el programa inicial debía escribirse manualmente utilizando unos interruptores de la parte delantera en un proceso difícil y largo[@freiberger2000fire].

![Imagen de un anuncio de Altair8800b. Los interruptores de la parte delantera permitían escribir cada palabra en la memoria interna indicando su estado bit a bit. De [Popular Electronics, 1975](http://www.swtpc.com/mholley/PopularElectronics/Jan1975/PE_Jan1975.htm) ](imgs/altair8800b.png) 

<!-- El primer gestor de arranque-->
La posterior aparición de los sistemas operativos provocó la necesidad de crear un gestor de arranque que cargara de forma autónoma los datos necesarios para la inicialización, el primero de ellos llamado BIOS. El término **BIOS** apareció por primera vez en el sistema operativo CP/M diseñado por Gary Kildall en 1975 para designar la capa software que facilitaba la abstracción entre el *hardware* y el sistema operativo[@garykildall]. Este sistema podía ejecutarse sobre el procesador Intel 8080 y soportaba únicamente 64 KB de memoria. El sistema operativo de Microsoft MS-DOS expandió CP/M para añadir nuevas funcionalidades conservando la parte análoga a la BIOS[@abraham2013operating cap. 20, pp.901].

<!--IBM PC Compatible y hablar de clones y de cómo llegó a ser importante BIOS-->

## La memoria ROM

La memoria ROM (del inglés *Read-Only Memory*) permitió el establecimiento del código inicial del gestor de arranque en una localización fija que el procesador podía leer al inicio. Es un tipo de memoria **no volátil**: su contenido no se borra cuando el sistema no tiene energía (como ocurre en la memoria RAM) y su modificación no es posible durante la ejecución y es un proceso difícil[@william2006computer Capítulo 5].

La modificación del gestor de arranque debía hacerse modificando esta memoria cuando era posible, proceso que variaba según el tipo de memoria[@william2006computer Capítulo 5, Types of ROM]:

- **PROM**: ROM programable eléctricamente lo que permite la modificación no industrial
- **EPROM**: ROM borrable mediante exposición a luz ultravioleta. Puede ser modificada en múltiples ocasiones pero el proceso puede durar hasta 20 minutos
- **EEPROM**: ROM borrable elécricamente. Este tipo de memoria puede ser actualizada *in situ* pero el proceso tarda varios órdenes de magnitud más que la lectura (del orden de microsegundos)

Utilizando este tipo de tecnologías podían reprogramarse los gestores de arranque que luego eran leídos por el procesador. Este modelo es también el utilizado en la actualidad para los ordenadores personales [@guide2011intel sección 9.1.4]: los procesadores Intel x86 toman la primera instrucción de la dirección física `FFFFFFF0H` donde debe estar localizada la memoria (EP)ROM, y también el utilizado por muchos sistemas embebidos.

## La actualidad

<!--TODO?-->

# BIOS

BIOS (del inglés *Basic Input/Ouput System*) es el *firmware* de arranque de los PCs de IBM y de la mayor parte de PCs antes del establecimiento de UEFI. Es el **componente software de más bajo nivel** de un ordenador. En términos generales consiste en una rutina que prueba los componentes del sistema y carga el sistema operativo y los *drivers* necesarios para su uso [@phoenix1989system pp. 1 (30)]. Inicialmente se incorporaba en los disquetes que traían el sistema operativo pero posteriormente se añadió a la memoria ROM de la placa base. Estaba diseñado para microprocesadores basados en la arquitectura Intel 80x86.

La BIOS servía además como una **capa de abstracción** entre el *hardware* y el sistema operativo, permitiendo modificar el hardware de manera independiente. Este era el caso de PC-DOS y MS-DOS, los sistemas operativos que predominaban en el mercado a finales de los años 80 [@phoenix1989system p. 2 (31)].

El funcionamiento general de la BIOS se basa en la interacción con las interrupciones *hardware* que proveen los procesadores Intel.

## Interrupciones

Una interrupción es una señal del procesador que indica un evento que debe ser atendido inmediatamente. La CPU entonces interrumpe su ejecución y transfiere la ejecución a una localización fija[@abraham2013operating Sección 1.2.1]. Las interrupciones pueden provenir del procesador del hardware, del software o del usuario. En los sistemas con BIOS una serie de interrupciones estaban reservadas para esta[@phoenix1989system pp. 35-36].

## El proceso de arranque en la BIOS
### POST
## Modificaciones
## Implementaciones
## Limitaciones
## Seguridad
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
# Referencias
