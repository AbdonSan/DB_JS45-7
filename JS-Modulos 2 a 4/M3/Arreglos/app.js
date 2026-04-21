function metodoBurbuja() {
  const listaDesordenada = [4, 2, 1, 3];
  let iteracionesForExterno = 0;
  let iteracionesForInterno = 0;

  for (let i = 0; i < listaDesordenada.length - 1; i++) {
    iteracionesForExterno++;
    
    for (let j = 0; j < listaDesordenada.length - 1 - i; j++) {
       
      iteracionesForInterno++;
      if (listaDesordenada[j] > listaDesordenada[j + 1]) {
        const temporal = listaDesordenada[j];
        listaDesordenada[j] = listaDesordenada[j + 1];
        listaDesordenada[j + 1] = temporal;
        
      }
    }
  }

  console.log("Lista ordenada:", listaDesordenada);
  console.log("Iteraciones del for externo:", iteracionesForExterno);
  console.log("Iteraciones del for interno:", iteracionesForInterno);
  console.log(
    "Total de iteraciones (suma de ambos for):",
    iteracionesForExterno + iteracionesForInterno
  );
  console.log(
    "Multiplicacion externo * interno (referencia):",
    iteracionesForExterno * iteracionesForInterno
  );
  document.body.innerHTML += `<p>Lista ordenada: ${listaDesordenada.join(", ")}</p>`;
}

metodoBurbuja();
