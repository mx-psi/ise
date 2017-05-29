---
title: UEFI vs BIOS
subtitle: Ingeniería de Servidores
date: Universidad de Granada
lang: es
theme: Frankfurt
colortheme: beaver
header-includes:
 - \usepackage[labelformat=empty]{caption}
colorlinks: true
---

# El inicio de los gestores de arranque

![Los interruptores permitían escribir cada palabra en la memoria interna indicando su estado bit a bit.](imgs/altair8800b.png) 

# La memoria ROM

La primera BIOS apareció en el sistema **CP/M** (1975). Esta parte del software abstraía el *hardware* y gestionaba el arranque de la máquina.

El uso de la memoria ROM permitió establecer una localización fija para el código inicial del gestor de arranque. El procesador toma a primera instrucción de `FFFFFFF0H` (en la ROM).

----

![ROM de BIOS fuera de la placa base. De [Wikimedia Commons](https://en.wikipedia.org/wiki/File:Bios_chip-2011-04-11.jpg)](imgs/AwardROM.jpg)


# BIOS

Apareció por primera vez como la conocemos en la actualidad en los **PCs de IBM** en los 80. Se convirtió en un estándar *de facto*. Servía como **capa de abstracción** entre el *hardware* y el sistema operativo y como **gestor de arranque**.

---

El proceso de arranque cuenta de los siguientes pasos:

- Inicialización de los registros y toma de la primera instrucción
- Ejecución del **POST**: se comprueba e inicializa el *hardware*
- Se busca un dispositivo inicializable (**MBR**)

Podía modificarse con **ROMs opcionales**.

# POST

Del inglés *Power on self-test*. El proceso:

- Se comprueban los componentes *hardware*: CPU, ROM, DMA, RAM, teclado...
- Un fallo suele ser irrecuperable: se indica por medio de pitidos sonoros
- En BIOS recientes: se crea una lista de dispositivos (*Bios Boot Specification*)

# MBR

Del inglés *Master Boot Record*. El proceso: 

- Se comprueban los dispositivos incializables uno a uno (BBS)
- Si hay: se comprueban sus particiones
- Si no hay: fallo/BASIC/arranque por red

Si se inicia desde disco:

- Cada disco puede tener **4 particiones primarias**
- El primer sector contiene información sobre cuáles so inicializables
- Se da paso al sistema operativo o al *boot loader*

# Limitaciones

- Tamaño máximo de disco: 2 TB 
- Depende del *hardware*: arquitectura de 16 bits
- Tamaño limitado de modificaciones
- No tiene un diseño modular

# UEFI

UEFI es el estándar utilizado en la actualidad (desde 2005). **No** es un gestor de arranque: es un conjunto de protocolos sobre el que se escribe el gestor.

No depende del *hardware* y sus modificaciones son más sencillas.

# GPT

Del inglés *GUID Partition Table*. 

- Formato de tabla de particiones de UEFI. 
- Permite **8 ZB** en comparación con los 2 TB de MBR
- Incluye redundancia de datos y comprobaciones de consistencia


# Innovaciones

- Se utiliza un **modelo de controladores**, escritos en C más flexible que las ROMs opcionales
- La HII (*Human Interface Infrastructure*) permite unificar la interfaz de usuario
- Permite **Secure Boot**: un método de validación del código antes del arranque



