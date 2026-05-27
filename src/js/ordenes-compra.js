// espera que cargue el DOM antes de ejecutar el código
document.addEventListener("DOMContentLoaded", function () {
  const materialesAgrupados = {};
  const tablaBody = document.querySelector("#tablaOC tbody");
  const templateFila = document.querySelector(".fila-material.template");
  // carga los materiales desde la API y los agrupa por categoría
  fetch("../api/materiales.php")
    .then((res) => res.json())
    .then((data) => {
      data.forEach((mat) => {
        const cat = mat.nombre_categoria || "Sin categoría";
        // si la categoría no existe, la inicializa como un array vacío
        if (!materialesAgrupados[cat]) {
          materialesAgrupados[cat] = [];
        }
        materialesAgrupados[cat].push({
          //push es como append
          id: mat.id_material,
          nombre: mat.nombre,
          unidad: mat.unidad_medida,
          precio: parseFloat(mat.precio_compra) || 0,
        });
      });
      agregarFila();
    })
    .catch((err) => console.error("Error cargando materiales:", err));

  document
    .getElementById("agregarFilaBtn")
    .addEventListener("click", agregarFila);

  function agregarFila() {
    const nuevaFila = templateFila.cloneNode(true);
    nuevaFila.classList.remove("template");
    nuevaFila.style.display = "";

    const selectMaterial = nuevaFila.querySelector(".material-select");
    poblarSelect(selectMaterial);

    selectMaterial.addEventListener("change", function () {
      const option = this.options[this.selectedIndex];
      const precio = parseFloat(option?.dataset?.precio) || 0;
      const unidad = option?.dataset?.unidad || "";

      const fila = this.closest(".fila-material");
      fila.querySelector(".precio-cell").textContent =
        "$" + precio.toLocaleString("es-AR");
      fila.querySelector(".unidad-cell").textContent = unidad;

      fila.querySelector(".hidden-id").value = this.value;

      recalcularFila(fila);
    });

    const inputCantidad = nuevaFila.querySelector(".cantidad-input");
    inputCantidad.addEventListener("input", function () {
      const fila = this.closest(".fila-material");
      fila.querySelector(".hidden-cant").value = this.value;
      recalcularFila(fila);
    });

    nuevaFila
      .querySelector(".btn-eliminar-fila")
      .addEventListener("click", function () {
        const filas = document.querySelectorAll(
          ".fila-material:not(.template)",
        );
        if (filas.length > 1) {
          nuevaFila.remove();
          reindexarFilas();
          calcularTotal();
        }
      });

    tablaBody.insertBefore(nuevaFila, document.querySelector(".fila-agregar"));
    reindexarFilas();
  }

  function poblarSelect(selectEl) {
    selectEl.innerHTML = '<option value="">-- Seleccione --</option>';

    Object.keys(materialesAgrupados).forEach((categoria) => {
      const optgroup = document.createElement("optgroup");
      optgroup.label = categoria;

      materialesAgrupados[categoria].forEach((mat) => {
        const option = document.createElement("option");
        option.value = mat.id;
        option.dataset.precio = mat.precio;
        option.dataset.unidad = mat.unidad;
        option.textContent = mat.nombre;
        optgroup.appendChild(option);
      });

      selectEl.appendChild(optgroup);
    });
  }

  function recalcularFila(fila) {
    const select = fila.querySelector(".material-select");
    const option = select.options[select.selectedIndex];
    const precio = parseFloat(option?.dataset?.precio) || 0;
    const cant = parseInt(fila.querySelector(".cantidad-input").value) || 0;
    const subtotal = precio * cant;

    fila.querySelector(".subtotal-cell").textContent =
      "$" + subtotal.toLocaleString("es-AR", { minimumFractionDigits: 2 });
    calcularTotal();
  }

  function calcularTotal() {
    const filas = document.querySelectorAll(".fila-material:not(.template)");
    let total = 0;
    filas.forEach((fila) => {
      const select = fila.querySelector(".material-select");
      const option = select.options[select.selectedIndex];
      const precio = parseFloat(option?.dataset?.precio) || 0;
      const cant = parseInt(fila.querySelector(".cantidad-input").value) || 0;
      total += precio * cant;
    });
    document.getElementById("totalOrden").innerHTML =
      "<strong>$" +
      total.toLocaleString("es-AR", { minimumFractionDigits: 2 }) +
      "</strong>";
  }

  function reindexarFilas() {
    const filas = document.querySelectorAll(".fila-material:not(.template)");
    filas.forEach((fila, index) => {
      fila.querySelector(".num-row").textContent = index + 1;
    });
  }

  document.getElementById("ocForm").addEventListener("submit", function (e) {
    const filas = document.querySelectorAll(".fila-material:not(.template)");
    const items = [];

    filas.forEach((fila) => {
      const select = fila.querySelector(".material-select");
      if (select.value) {
        const option = select.options[select.selectedIndex];
        const cantidad =
          parseInt(fila.querySelector(".cantidad-input").value) || 0;
        if (cantidad > 0) {
          items.push({
            id_material: parseInt(select.value),
            cantidad: cantidad,
            precio_compra: parseFloat(option.dataset.precio),
          });
        }
      }
    });

    document.getElementById("materialesJson").value = JSON.stringify(items);

    if (items.length === 0) {
      e.preventDefault();
      alert("Debe agregar al menos un material con cantidad mayor a 0");
    }
  });
});
