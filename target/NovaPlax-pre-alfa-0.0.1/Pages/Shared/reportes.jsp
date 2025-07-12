<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="santander.novaplax.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reportes de Ventas | NovaPlax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="../../Components/Sidebar.jsp"/>
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h2>Reportes de Ventas</h2>
                </div>

                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-filter"></i> Filtros
                    </div>
                    <div class="card-body">
                        <form method="get" action="reportes" id="filtroForm">
                            <div class="row g-3">
                                <div class="col-md-3">
                                    <label class="form-label">Fecha Desde</label>
                                    <input type="date" name="fechaInicio" class="form-control" value="${param.fechaInicio}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Fecha Hasta</label>
                                    <input type="date" name="fechaFin" class="form-control" value="${param.fechaFin}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Cliente</label>
                                    <select name="clienteId" class="form-select">
                                        <option value="">Todos los clientes</option>
                                        <% for (Cliente c : (List<Cliente>)request.getAttribute("clientes")) { %>
                                        <option value="<%= c.getId() %>" 
                                            <%= (request.getParameter("clienteId") != null && 
                                                request.getParameter("clienteId").equals(String.valueOf(c.getId()))) ? "selected" : "" %>>
                                            <%= c.getNombre() %> <%= c.getApellido() %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <% 
                                    Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
                                    if (usuario != null && "admin".equals(usuario.getRol())) { 
                                %>
                                <div class="col-md-3">
                                    <label class="form-label">Vendedor</label>
                                    <select name="vendedorId" class="form-select">
                                        <option value="">Todos los vendedores</option>
                                        <% for (Usuario v : (List<Usuario>)request.getAttribute("vendedores")) { %>
                                        <option value="<%= v.getId() %>" 
                                            <%= (request.getParameter("vendedorId") != null && 
                                                request.getParameter("vendedorId").equals(String.valueOf(v.getId()))) ? "selected" : "" %>>
                                            <%= v.getUsuario() %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <% } %>
                            </div>
                            <div class="row mt-3">
                                <div class="col-md-12 text-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-filter"></i> Aplicar Filtros
                                    </button>
                                    <button type="button" id="btnLimpiar" class="btn btn-outline-secondary">
                                        <i class="fas fa-broom"></i> Limpiar
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header bg-info text-white">
                        <i class="fas fa-chart-bar"></i> Resumen Estadístico
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="card text-white bg-primary mb-3">
                                    <div class="card-body text-center">
                                        <h5 class="card-title">Total Ventas</h5>
                                        <p class="card-text display-6"><%= ((List<ReporteVenta>)request.getAttribute("reportes")).size() %></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card text-white bg-success mb-3">
                                    <div class="card-body text-center">
                                        <h5 class="card-title">Total Ingresos</h5>
                                        <%
                                            double totalIngresos = ((List<ReporteVenta>)request.getAttribute("reportes")).stream()
                                                .mapToDouble(r -> r.getTotal().doubleValue())
                                                .sum();
                                        %>
                                        <p class="card-text display-6">S/<%= String.format("%.2f", totalIngresos) %></p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card text-white bg-warning mb-3">
                                    <div class="card-body text-center">
                                        <h5 class="card-title">Artículos Vendidos</h5>
                                        <%
                                            int totalArticulos = ((List<ReporteVenta>)request.getAttribute("reportes")).stream()
                                                .mapToInt(ReporteVenta::getCantidadArticulos)
                                                .sum();
                                        %>
                                        <p class="card-text display-6"><%= totalArticulos %></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header bg-dark text-white">
                        <i class="fas fa-table"></i> Detalle de Ventas
                    </div>
                    <div class="card-body">
                        <% if (((List<ReporteVenta>)request.getAttribute("reportes")).isEmpty()) { %>
                            <div class="alert alert-info">
                                No se encontraron ventas con los filtros aplicados
                            </div>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Ticket ID</th>
                                            <th>Fecha</th>
                                            <th>Cliente</th>
                                            <th>Vendedor</th>
                                            <th>Artículos</th>
                                            <th>Total</th>
                                            <th>Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                                            DecimalFormat df = new DecimalFormat("0.00");
                                            for (ReporteVenta r : (List<ReporteVenta>)request.getAttribute("reportes")) { 
                                        %>
                                        <tr>
                                            <td><%= r.getTicketId() %></td>
                                            <td><%= sdf.format(r.getFecha()) %></td>
                                            <td><%= r.getClienteNombre() != null ? r.getClienteNombre() : "Consumidor Final" %></td>
                                            <td><%= r.getVendedor() %></td>
                                            <td><%= r.getCantidadArticulos() %></td>
                                            <td>S/<%= df.format(r.getTotal()) %></td>
                                            <td>
                                                <button class="btn btn-sm btn-info btn-detalle" 
                                                        data-ticket-id="<%= r.getTicketId() %>"
                                                        data-bs-toggle="tooltip" title="Ver detalle">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                </div>

                <div class="modal fade" id="detalleModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title">Detalle de Venta #<span id="modalTicketId"></span></h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body" id="modalDetalleContent">
                                <div class="text-center p-4"><i class="fas fa-spinner fa-spin fa-3x"></i><p>Cargando detalle...</p></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    <i class="fas fa-times"></i> Cerrar
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            $('[data-bs-toggle="tooltip"]').tooltip();
            
            $('#btnLimpiar').click(function() {
                $('#filtroForm').find('input, select').val('');
                $('#filtroForm').submit();
            });
            
            $(document).on('click', '.btn-detalle', function() {
                const ticketId = $(this).data('ticket-id');
                $('#modalTicketId').text(ticketId);
                
                $.ajax({
                    url: 'reportes',
                    type: 'GET',
                    data: { action: 'detalle', id: ticketId },
                    success: function(data) {
                        const detalles = $(data).find('tr');
                        let html = '<div class="table-responsive"><table class="table table-striped">';
                        html += '<thead class="table-primary"><tr><th>Artículo</th><th>Cantidad</th><th>P. Unitario</th><th>Subtotal</th></tr></thead>';
                        html += '<tbody>';
                        
                        let total = 0;
                        detalles.each(function() {
                            const nombre = $(this).find('td:eq(0)').text();
                            const cantidad = $(this).find('td:eq(1)').text();
                            const precio = $(this).find('td:eq(2)').text().replace('S/', '');
                            const subtotal = (parseFloat(precio) * parseInt(cantidad)).toFixed(2);
                            total += parseFloat(subtotal);
                            
                            html += `<tr><td>${nombre}</td><td>${cantidad}</td><td>S/${precio}</td><td>S/${subtotal}</td></tr>`;
                        });
                        
                        html += `</tbody><tfoot><tr class="table-active"><th colspan="3">Total</th><th>S/${total.toFixed(2)}</th></tr></tfoot>`;
                        html += '</table></div>';
                        
                        $('#modalDetalleContent').html(html);
                    },
                    error: function() {
                        $('#modalDetalleContent').html('<div class="alert alert-danger">Error al cargar el detalle. Intente nuevamente.</div>');
                    }
                });
            });
        });
    </script>
</body>
</html>