# Funcion 1: Programa que calcula la serie de Fourier Trigonomterica truncada
# sobre una funcion periodica dada con variable t y dado n armonicos.
close all; clear all; clc

# Mensajes del programa.
mensaje_titulo = "-- Transformada Rapida de Fourier y Filtros --\n";
mensaje_intentar = "Intente de nuevo...\nPresione cualquier tecla para continuar.\n";
mensaje_continuar = "\n  Presione cualquier tecla para continuar.\n";

# Periodo
T = 6 * pi;
f0 = 1;
fs = 50 * f0;
Ts = 1 / fs;

# Menu para solicitar el valor de a.
while true
  
  try

    clc
    printf( mensaje_titulo );
    printf( "Ingrese el valor de la variable \"a\" que desea evaluar\n" );
    a = input( "" );

    if a <= 0
      rethrow( "" );
    endif
    
    break;

  catch
    printf("\nEl valor ingresado no es valido, solo se aceptan\n");
    printf("numeros estrictamente mayores a 0.\n");
    printf( mensaje_intentar );
    pause
  end_try_catch
  
endwhile

# Menu para solicitar W_c.
while true
  
  try

    clc
    printf( mensaje_titulo );
    printf( "Ingrese el valor de W_c que desea evaluar\n" );
    W_c = input( "" );

    if W_c <= 0 || W_c >= T
      rethrow( "" );
    endif
    
    break;

  catch
    printf("\nEl valor ingresado no es valido, solo se aceptan\n");
    printf("numeros entre (0, %.2f].\n", T );
    printf( mensaje_intentar );
    pause
  end_try_catch
  
endwhile

# Menu para solicitar W_low.
while true
  
  try

    clc
    printf( mensaje_titulo );
    printf( "Ingrese el valor de W_low que desea evaluar\n" );
    W_low = input( "" );

    if W_low <= 0 || W_low >= T
      rethrow( "" );
    endif
    
    break;

  catch
    printf("\nEl valor ingresado no es valido, solo se aceptan\n");
    printf("numeros entre (0, %.2f].\n", T );
    printf( mensaje_intentar );
    pause
  end_try_catch
  
endwhile

# Menu para solicitar W_high.
while true
  
  try

    clc
    printf( mensaje_titulo );
    printf( "Ingrese el valor de W_high que desea evaluar\n" );
    W_high = input( "" );

    if W_high <= W_low || W_high >= T
      rethrow( "" );
    endif
    
    break;

  catch
    printf("\nEl valor ingresado no es valido, solo se aceptan\n");
    printf("numeros entre (%.2f, %.2f].\n", W_low, T );
    printf( mensaje_intentar );
    pause
  end_try_catch
  
endwhile

# Variable para tiempo.
t = [ -T : Ts : T ];
pulso_rectangular = (t > -a) & (t < a);

# Variable para frecuencia.
w = [ -T : Ts : T ];

# Genera la función sa(x) = sin(x) / x.
sa = inline("(sin(x)+(x==0))./(x+(x==0))", 'x');
funcion_periodica = 2 * a * sa( a * w );
abs_funcion_periodica = abs( funcion_periodica );

# Definimos los filtros ideales.
filtro_para_Wc = ( w < W_c );
filtro_para_WLowHigh = ( ( w > W_low ) & ( w < W_high ) );

# filtro_para_Wc = ( w > -W_c ) & ( w < W_c );
# filtro_para_WLowHigh = ( ( w > -W_2 ) & ( w < -W_1 ) ) | ( ( w > W_1 ) & ( w < W_2 ) );

Ts_ifft = 0.15;
w_ifft = [ -T : Ts_ifft : T ];
t_ifft = w_ifft( 1 : 2 : end );

# Aplicamos tranformadas de Fourier.
funcion_periodica_ifft = 2 * a * sa( a * w_ifft );
transformada_inversa_funcion_periodica = fftshift( ifft( funcion_periodica_ifft / Ts_ifft ) )( 1 : 2 : end );

# Definimos los intervalos para las variables de tiempo y frecuencia
# para uso de la funcion FFT.
Ts_fft = 0.15;
t_fft = [ -T : Ts_fft : T ];
w_fft = t_fft( 1 : 2 : end );

# Definimos los pulsos para la funcion FFT.
xfft = ( t_fft < a ) & ( t_fft > -a );

# Calculamos la transformada de cada pulso con la funcion FFT.
tranformada_pulso_rectangular = fftshift( fft(xfft) * Ts_fft )( 1 : 2 : end );

clf;
leyenda_a = strcat( "a=", mat2str( a ) );

# Generamos graficas del pulso rectangular, su funcion periodica analitica y sus transformadas.
subplot(4,2,1); plot( t, pulso_rectangular, '-r' ); xlabel('\w'); ylabel('X(\w)'); title('Pulso Rectangular de a'); legend( leyenda_a ); grid;
subplot(4,2,3); plot( w, funcion_periodica, '-r' ); xlabel('\w'); ylabel('X(\w)'); title('Transformada Analitica de Fourier del Pulso Rectangular'); legend( leyenda_a ); grid;
subplot(4,2,5); plot( t_ifft, transformada_inversa_funcion_periodica, '-r' ); xlabel('\w'); ylabel('X(\w)'); title('Transformada Inversa de Fourier de la Funcion Periodica Analitica'); legend(leyenda_a); grid;
subplot(4,2,7); plot( w_fft, tranformada_pulso_rectangular, '-r' ); xlabel('\w'); ylabel('X(\w)'); title('Transformada de Fourier del Pulso Rectangular'); legend( leyenda_a ); grid;

# Generamos graficas para aplicacion de filtros ideales.
subplot(4,2,2); plot( w, abs_funcion_periodica .*  filtro_para_Wc, '-r' ); xlabel('\w'); ylabel('X(\w)'); title('Transformada de Fourier del Pulso Rectangular con filtro Pasa Baja'); legend(leyenda_a); grid;
subplot(4,2,4); plot( w, abs_funcion_periodica .* ~filtro_para_Wc, '-r' ); xlabel('\w'); ylabel('X(\w)'); title('Transformada de Fourier del Pulso Rectangular con filtro Pasa Alta'); legend(leyenda_a); grid;
subplot(4,2,6); plot( w, abs_funcion_periodica .*  filtro_para_WLowHigh, '-r' ); xlabel('\w'); ylabel('X(\w)'); title('Transformada de Fourier del Pulso Rectangular con filtro Pasa Banda'); legend(leyenda_a); grid;
subplot(4,2,8); plot( w, abs_funcion_periodica .* ~filtro_para_WLowHigh, '-r' ); xlabel('\w'); ylabel('X(\w)'); title('Transformada de Fourier del Pulso Rectangular con filtro Suprime Banda'); legend(leyenda_a); grid;