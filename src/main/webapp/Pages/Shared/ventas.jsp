<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="santander.novaplax.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Ventas | NovaPlax</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style></style>
    </head>
    <body>
        <jsp:include page="../../Components/Sidebar.jsp" />
        <div class="main-content">
            <div class="container mt-4">
                <h2 class="mb-4">Nueva Venta</h2>
                <form id="clienteForm" method="post" action="ventas" class="mb-4">
                    <input type="hidden" name="action" value="guardarCliente">
                    <div class="row">
                        <div class="col-md-6">
                            <label class="form-label">Cliente</label>
                            <select name="cliente_id" class="form-select" onchange="this.form.submit()">
                                <option value="">-- Seleccionar Cliente --</option>
                                <% for (Cliente c : (List<Cliente>)request.getAttribute("clientes")) { %>
                                <option value="<%= c.getId() %>" <%= (request.getAttribute("clienteSeleccionado") != null && (Integer)request.getAttribute("clienteSeleccionado") == c.getId()) ? "selected" : "" %>><%= c.getNombre() %> <%= c.getApellido() %> (<%= c.getDni() %>)</option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                </form>
                <div class="card mb-4">
                    <div class="card-header">Agregar Artículo</div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-5">
                                <label class="form-label">Artículo</label>
                                <select name="articulo_id" class="form-select" id="articulo-select">
                                    <option value="">-- Seleccionar Artículo --</option>
                                    <% for (Articulo a : (List<Articulo>)request.getAttribute("articulos")) { %>
                                    <option value="<%= a.getId() %>" data-precio="<%= a.getPrecio() %>" data-nombre="<%= a.getNombre() %>" data-stock="<%= a.getStock() %>"><%= a.getNombre() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <div id="product-info" class="product-info" style="display: none;">
                            <div class="row mb-3">
                                <div class="col-md-4">
                                    <label class="form-label">Nombre</label>
                                    <input type="text" class="form-control" id="product-name" readonly>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Precio Unitario</label>
                                    <input type="text" class="form-control" id="product-price" readonly>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label">Stock Disponible</label>
                                    <input type="text" class="form-control" id="product-stock" readonly>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4">
                                    <label class="form-label">Cantidad</label>
                                    <input type="number" name="cantidad" class="form-control" min="1" value="1" id="cantidad-input">
                                </div>
                                <div class="col-md-8 d-flex align-items-end gap-2">
                                    <button type="button" id="btn-agregar" class="btn btn-primary"><i class="fas fa-plus"></i> Agregar al carrito</button>
                                    <button type="button" id="btn-limpiar" class="btn btn-secondary"><i class="fas fa-broom"></i> Limpiar formulario</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="carrito-container">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Artículo</th>
                                <th>Cantidad</th>
                                <th>Precio Unitario</th>
                                <th>Subtotal</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (int i = 0; i < ((List<TicketDetalle>)request.getAttribute("carrito")).size(); i++) {
TicketDetalle d = ((List<TicketDetalle>)request.getAttribute("carrito")).get(i); %>
                            <tr>
                                <td><%= d.getArticuloNombre() %></td>
                                <td><%= d.getCantidad() %></td>
                                <td>S/<%= d.getPrecioUnitario() %></td>
                                <td>S/<%= d.getSubtotal() %></td>
                                <td>
                                    <form method="post" action="ventas" style="display:inline;">
                                        <input type="hidden" name="action" value="eliminar">
                                        <input type="hidden" name="index" value="<%= i %>">
                                        <button type="submit" class="btn btn-sm btn-danger"><i class="fas fa-trash"></i></button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                            <tr class="table-active">
                                <td colspan="3" class="text-end"><strong>Total:</strong></td>
                                <td><strong>S/<%= ((List<TicketDetalle>)request.getAttribute("carrito")).stream().map(TicketDetalle::getSubtotal).reduce(BigDecimal.ZERO, BigDecimal::add) %></strong></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                    <% Integer clienteSel = (Integer) request.getAttribute("clienteSeleccionado"); boolean clienteSeleccionado = clienteSel != null; boolean carritoNoVacio = !((List<TicketDetalle>)request.getAttribute("carrito")).isEmpty(); %>
                    <% if (carritoNoVacio) { %>
                    <form method="post" action="ventas">
                        <input type="hidden" name="action" value="finalizar">
                        <button type="submit" class="btn btn-success" <%= !clienteSeleccionado ? "disabled" : "" %>><i class="fas fa-check"></i> Finalizar Venta</button>
                    </form>
                    <% } %>
                </div>
            </div>
        </div>
        <script>
            let currentProduct = null;
            $('#articulo-select').change(function () {
                const selected = $(this).find('option:selected');
                if (!selected.val()) {
                    $('#product-info').hide();
                    currentProduct = null;
                    return;
                }
                currentProduct = {id: selected.val(), nombre: selected.data('nombre'), precio: parseFloat(selected.data('precio')), stock: parseInt(selected.data('stock'))};
                $('#product-name').val(currentProduct.nombre);
                $('#product-price').val('S/' + currentProduct.precio.toFixed(2));
                $('#product-stock').val(currentProduct.stock + ' unidades');
                $('#product-info').show();
            });
            $('#btn-agregar').click(function () {
                if (!currentProduct) {
                    return;
                }
                const cantidad = parseInt($('#cantidad-input').val()) || 0;
                if (cantidad <= 0) {
                    return;
                }
                const formData = {articulo_id: currentProduct.id, cantidad: cantidad, precio: currentProduct.precio, articulo_nombre: currentProduct.nombre, action: 'agregar'};
                $.ajax({url: 'ventas', type: 'POST', data: formData, dataType: 'json', success: function (response) {
                        if (response.success) {
                            $('#carrito-container').load('ventas #carrito-container > *');
                            $('#cantidad-input').val('1');
                        }
                    }});
            });
            $('#btn-limpiar').click(function () {
                $('#articulo-select').val('');
                $('#product-info').hide();
                $('#cantidad-input').val('1');
                currentProduct = null;
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
