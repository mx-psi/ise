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
- Entre apartados o entre secciones solo puede mediar, como mucho, una línea en blanco
- Las figuras deben ir referenciadas. Las imágenes que sean estrechas deben ir a un lado.
- Las referencias bibliográficas irán numeradas y referenciadas: libros, cosas de fabricantes, revisiones de profesionales. 
- Hay que incluir transparencias.pdf con 8-12 transparencias y cuestionario.ods con 4-6 preguntas tipo test y soluciones relacionadas con el tema.
- Las referencias van entre corchetes y el nombre empieza con @: [@referencia]
-->

# Historia del arranque


## Por qué una BIOS?
## La primera BIOS

# BIOS

BIOS (del inglés *Basic Input/Ouput System*) es el *firmware* de arranque de los PCs de IBM y de la mayor parte de PCs antes del establecimiento de UEFI. Es el componente software de más bajo nivel de un ordenador. En términos generales consiste en una rutina que prueba los componentes del sistema y carga el sistema operativo y los *drivers* necesarios para su uso [@phoenix1989system p. 1 (30)]. Inicialmente se incorporaba en los disquetes que traían el sistema operativo pero posteriormente se añadió a la memoria ROM de la placa base. Estaba diseñado para microprocesadores basados en la arquitectura Intel 80x86.

La BIOS servía además como una **capa de abstracción** entre el *hardware* y el sistema operativo, permitiendo modificar el hardware de manera independiente. Este era el caso de PC-DOS y MS-DOS, los sistemas operativos que predominaban en el mercado a finales de los años 80 [@phoenix1989system p. 2 (31)].

El funcionamiento general de la BIOS se basa en la interacción con las interrupciones *hardware* que proveen los procesadores Intel.

## Arranque en la BIOS
### POST
## Configuración: Memoria EEPROM
## Modificaciones
## Implementaciones
## Limitaciones
## Seguridad

# UEFI

## Transición 
<!--Por qué hemos pasado de BIOS a UEFI-->
## El estándar
<!--Quién lo define y donde está-->
## Seguridad

# En servidores
# Alternativas libres: libreboot y coreboot
# Referencias
