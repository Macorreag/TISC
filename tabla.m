
function tabla( matriz, espaciado = 2, alineacion = 1 )
  
  # Capturamos el numero de filas y columnas de la matriz
  dimension_xy = size( matriz );
  nfilas = dimension_xy(1);
  ncolumnas = dimension_xy(2);
  
  dato = "";
  longitud_dato = 0;
  longitud_filas = zeros( 1, nfilas );
  longitud_mayor_fila = 0;
  longitud_mayor_columna = zeros(1, ncolumnas);
  
  # Buscamos la longitud del dato más largo de cada columna.
  for j = 1 : ncolumnas
    for i = 1 : nfilas
      
      if isnumeric( matriz{i, j} )
        longitud_dato = length( mat2str( matriz{i, j} ) );
      elseif class( matriz{i, j} ) == "cell"
        dato = cast( matriz{i, j}, "char" );
      else
        longitud_dato = length( matriz{i, j} );
      endif
      
      if longitud_dato > longitud_mayor_columna(j)
          longitud_mayor_columna(j) = longitud_dato;
      endif
      
      longitud_filas(i) += longitud_dato;
      
    endfor
  endfor
  
  # Obtenemos el ancho de la tabla.
  for i = 1 : nfilas
    if longitud_filas(i) > longitud_mayor_fila
      longitud_mayor_fila = longitud_filas(i);
    endif
  endfor
  
  separador_filas = repmat( "-" , [1, longitud_mayor_fila + ncolumnas + 1 + 2 * espaciado * ncolumnas ] );
  
  # Convertimos los datos de la matriz a string,
  # calculamos la distancia entre los datos.
  for i = 1 : nfilas
    
    printf( "%s\n", separador_filas );
    
    for j = 1 : ncolumnas
      if isnumeric( matriz{i, j} )
        dato = mat2str( matriz{i, j} );
      else
        dato = matriz{i, j};
      endif

      if alineacion == 1
        longitud_dato = longitud_mayor_columna(j) - length( dato );
      else
        longitud_dato = longitud_mayor_columna(j) - length( dato ) + espaciado;
      endif
      
      #if j < ncolumnas
        if alineacion == 1
          printf( "|%s%s%s", repmat( " " , [1, longitud_dato + espaciado ] ), dato, repmat( " " , [1, espaciado ] ) );
        else
          printf( "|%s%s%s", repmat( " " , [1, espaciado ] ), dato, repmat( " " , [1, longitud_dato ] ) );
        endif
      #else
        #printf( "%s", dato );
      #endif
      
    endfor
    printf("|\n");
  endfor
  
  printf( "%s\n", separador_filas );
  
endfunction