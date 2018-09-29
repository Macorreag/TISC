# Aplicacion de la funcion FFT de octave para generar la transformada
# analitica de 2a*(sin(wa)/wa), aplicando sobre la tansformada generada los filtros
# ideales: pasa-baja, pasa-alta, pasa-banda y suprime-banda.

# Mensajes del programa.
mensaje_titulo = "-- Funciones Periodicas y el Fenomeno de Gibbs --\n";
mensaje_intentar = "Intente de nuevo...\nPresione cualquier tecla para continuar.\n";

# Menu para solicitar funcion periodica.
while true
  
  try

    clc
    printf( mensaje_titulo );
    printf( "Ingrese la funcion periodica a evaluar, tenga en cuenta\n" );
    printf( "que la variable independiente de la funcion es t:\n" );
    cadena_funcion_periodica = input( "", "S" );
    funcion_periodica = inline( cadena_funcion_periodica, "t" );
    funcion_periodica(0);
    
    break;

  catch
    printf("\nLa funcion ingresada no es valida.\n");
    printf( mensaje_intentar );
    pause
  end_try_catch
  
endwhile

# Menu para solicitar periodo.
while true
  
  try

    clc
    printf( mensaje_titulo );
    printf( "Ingrese el periodo de la funcion:\n" );
    periodo = input( "" );

    if periodo <= 0
      rethrow( "" );
    endif
    
    break;

  catch err
  #catch
    warning(err.identifier, err.message);
    printf("\nEl valor ingresado no es valido, solo se aceptan\n");
    printf("numeros estrictamente mayores a 0.\n");
    printf( mensaje_intentar );
    pause
  end_try_catch
  
endwhile

# Menu para solicitar armonicos a calcular.
while true
  
  try

    clc
    printf( mensaje_titulo );
    printf( "Ingrese el numero de armonicos que desea calcular:\n" );
    N = input( "" );

    if N > floor(N) || N < 1
      rethrow( "" );
    endif
    
    break;

  catch
    printf("\nEl valor ingresado no es valido, solo se aceptan\n");
    printf("numeros enteros mayores o iguales a 1.\n");
    printf( mensaje_intentar );
    pause
  end_try_catch
  
endwhile

# Funcion para obtener los coeficientes a y b de la serie trigonometrica de acuerdo al armonico dado.
function [coeficiente_a, coeficiente_b] = coeficiente_fourier_trig( cadena_funcion_periodica, w_0, periodo, n )
  funcion_por_coseno = inline( strcat( cadena_funcion_periodica, " * cos(", mat2str(n) ," * ", mat2str(w_0), " * t )" ), "t" );
  funcion_por_seno = inline( strcat( cadena_funcion_periodica, " * sin(", mat2str(n) ," * ", mat2str(w_0), " * t )" ), "t" );

  coeficiente_a = ( 2 / periodo ) * quad( funcion_por_coseno, -periodo / 2, periodo / 2 );
  coeficiente_b = ( 2 / periodo ) * quad( funcion_por_seno, -periodo / 2, periodo / 2 );
  return;
endfunction

w_0 = 2 * pi / periodo;
x = 0;
t = [-periodo: 0.1 : periodo];

# Titulos de la tabla de coeficientes de la serie trigonometrica de Fourier a mostrar .
coeficientes_fourier_trig = { "n", "a_n", "b_n" };

# Calculamos los coeficientes de la serie trigonometrica de Fouerier para cada armonico.
for n = 0 : N
  [a_n, b_n] = coeficiente_fourier_trig( cadena_funcion_periodica, w_0, periodo, n );
  coeficientes_fourier_trig = [coeficientes_fourier_trig; n, a_n, b_n];
endfor

# Mostramos la tabla en la salida de la consola.
printf("\nTabla: Coeficientes de la Serie de Fourier Trigonometrica.\n");
tabla( coeficientes_fourier_trig, 1, 2 );

# Usamos los coeficientes calculados y lo aplicamos en la sumatoria de la funcion
# trigonometrica de la serie de Fourier.
for n = 1 : N
  [a_n, b_n] = coeficiente_fourier_trig( cadena_funcion_periodica, w_0, periodo, n );
  x += a_n * cos( n * w_0 * t ) + b_n * sin( n * w_0 * t );
endfor

# Graficamos la funcion periodica y la serie de Fourier calculada.
clf;
plot( t, [x; funcion_periodica(t)], ['-r'; '-g'] ); xlabel('t'); ylabel('x(t)'); title('Serie de Fourier'); legend( 'Aproximacion de la funcion', strcat( "funcion:", cadena_funcion_periodica) ); grid;