# Universidad Nacional de Colombia - Sede Bogota.
# Septiembre 2018.

# Metodos Numericos - Laboratorio 1: Metodo Iterativo de Jacobi.
# Docente:          Edgar Miguel Vargas.
# Equipo:           Miller A. Correa.
#                   Miguel A. Medellin.
#                   Jose M. Ramirez.

# - Descripcion del programa -
# Funcion 1: Programa que calcula la serie de Fourier Trigonomterica truncada
# sobre una funcion periodica dada con variable t y dado n armonicos.

# Funcion 2: Aplicacion de la funcion FFT de octave para generar la transformada
# analitica de 2a*(sin(wa)/wa), aplicando sobre la tansformada generada los filtros
# ideales: pasa-baja, pasa-alta, pasa-banda y suprime-banda.

clc
mensaje_titulo = "-- Laboratorio 1: Senales y Sistemas --\n";
mensaje_intentar = "Intente de nuevo...\nPresione cualquier tecla para continuar.\n";

# Menu del programa con validaciones.
while true
  
  try
    
    printf( mensaje_titulo );
    printf( "Seleccione modo de calculo:\n" );
    printf( "  1. Funciones periodicas y fenomeno Gibbs.\n" );
    printf( "  2. Transformada rapidad de Fourier (FFT) y filtros. \n" );
    opcion = input( "  " );
    
    if opcion == 1
      menu_funcion_periodica;
      break;
      
    elseif opcion == 2
      menu_filtros;
      break;
      
    else
      rethrow( "" );      

    endif
   
  catch
    printf( "\nOpcion no valida.\n" );
    printf( mensaje_intentar );
    pause
    clc
  end_try_catch
  
endwhile