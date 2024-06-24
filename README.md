# ETSIIValente: Una aplicación para calcular circuitos equivalentes segun el teorema de Thevenin

Proyecto TFG Grado en Ingeniería informática.
Con este TFG se quiere diseñar e implementar una aplicación de escritorio capaz de calcular el 
equivalente Thevenin de circuitos de corriente continua sencillos, similares a los que se estudian 
y tratan en las asignaturas de Física de las diferentes titulaciones de la ETSII

## Estructura del código
El código fuente se podrá encontrar en la carpeta /lib. En ella encontraremos los ficheros 
correspondientes a cada pantalla de la aplicación. Además, en las distintas carpetas dentro de 
esta carpeta lib encontraremos clases que se usan dentro de las pantallas: 
- /circuits: Clase padre Circuito y herederos de distintas mallas. Además, una clase para manejar los circuitos en memoria
- /electricsComponents: Clases que contienen la lógica de los componentes básicos de la aplicación.
- /circuitComponents: Clases que contienen la lógica de las partes del circuito
- /utils: Clases con funciones que ayudan a la lectura de ficheros y formateo de valores en circuito

## Licencia

Este proyecto está licenciado bajo la Licencia Creative Commons Attribution 4.0
International. Para más detalles, consulta el archivo [LICENSE](./LICENSE.md).

## Getting Started - Flutter

This project is a starting point for a Flutter application.
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
