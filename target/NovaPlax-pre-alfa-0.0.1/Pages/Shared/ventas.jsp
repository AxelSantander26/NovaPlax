<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="santander.novaplax.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%
HttpSession sesion = request.getSession(false);
if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
    response.sendRedirect(request.getContextPath() + "/cerrar-sesion");
    return;
}
Usuario user = (Usuario) sesion.getAttribute("usuarioLogueado");
String error = (String) request.getAttribute("error");
List<TicketDetalle> carrito = (List<TicketDetalle>) request.getAttribute("carrito");
List<Articulo> articulos = (List<Articulo>) request.getAttribute("articulos");
List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ventas | NovaPlax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<jsp:include page="../../Components/Sidebar.jsp" />
<div class="main-content">
    <div class="container mt-4">
        <h2>Nueva Venta</h2>
        <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
        <% } %>
        
        <form method="post" action="ventas" class="mb-4">
            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="form-label">Cliente</label>
                    <select name="cliente_id" class="form-select">
                        <option value="">-- Seleccionar Cliente --</option>
                        <% for (Cliente c : clientes) { %>
                        <option value="<%= c.getId() %>">
                            <%= c.getNombre() %> <%= c.getApellido() %> (<%= c.getDni() %>)
                        </option>
                        <% } %>
                    </select>
                </div>
            </div>
            
            <div class="card mb-3">
                <div class="card-header">Agregar Artículo</div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="form-label">Artículo</label>
                            <select name="articulo_id" class="form-select" id="articulo-select">
                                <option value="">-- Seleccionar Artículo --</option>
                                <% for (Articulo a : articulos) { %>
                                <option value="<%= a.getId() %>" data-precio="<%= a.getPrecio() %>" data-nombre="<%= a.getNombre() %>">
                                    <%= a.getNombre() %> - $<%= a.getPrecio() %> (Stock: <%= a.getStock() %>)
                                </option>
                                <% } %>
                            </select>
                            <input type="hidden" name="articulo_nombre" id="articulo-nombre">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Cantidad</label>
                            <input type="number" name="cantidad" class="form-control" min="1" value="1">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Precio Unitario</label>
                            <input type="number" step="0.01" name="precio" class="form-control" id="precio-unitario">
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" name="action" value="agregar" class="btn btn-primary w-100">
                                <i class="fas fa-plus"></i> Agregar
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>

        <% if (carrito != null && !carrito.isEmpty()) { %>
        <div class="card">
            <div class="card-header">Detalle de Venta</div>
            <div class="card-body">
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
                        <% for (int i = 0; i < carrito.size(); i++) { 
                            TicketDetalle d = carrito.get(i); %>
                        <tr>
                            <td><%= d.getArticuloNombre() %></td>
                            <td><%= d.getCantidad() %></td>
                            <td>$<%= d.getPrecioUnitario() %></td>
                            <td>$<%= d.getSubtotal() %></td>
                            <td>
                                <form method="post" action="ventas" style="display: inline;">
                                    <input type="hidden" name="action" value="eliminar">
                                    <input type="hidden" name="index" value="<%= i %>">
                                    <button type="submit" class="btn btn-sm btn-danger">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                        <tr class="table-active">
                            <td colspan="3" class="text-end"><strong>Total:</strong></td>
                            <td><strong>$<%= carrito.stream()
                                .map(TicketDetalle::getSubtotal)
                                .reduce(BigDecimal.ZERO, BigDecimal::add) %></strong></td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
                
                <form method="post" action="ventas">
                    <input type="hidden" name="action" value="finalizar">
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-check"></i> Finalizar Venta
                    </button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
</div>

<script>
document.getElementById('articulo-select').addEventListener('change', function() {
    const selectedOption = this.options[this.selectedIndex];
    document.getElementById('precio-unitario').value = selectedOption.getAttribute('data-precio');
    document.getElementById('articulo-nombre').value = selectedOption.getAttribute('data-nombre');
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>