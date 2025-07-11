<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="santander.novaplax.model.Usuario" %>
<%@ page import="santander.novaplax.model.Cliente" %>
<%@ page import="java.util.List" %>
<%
HttpSession sesion = request.getSession(false);
if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
response.sendRedirect(request.getContextPath() + "/cerrar-sesion");
return;
}
Usuario user = (Usuario) sesion.getAttribute("usuarioLogueado");
String action = request.getParameter("action") != null ? request.getParameter("action") : "listar";
Cliente cliente = (Cliente) request.getAttribute("cliente");
List<Cliente> lista = (List<Cliente>) request.getAttribute("lista");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Clientes | NovaPlax</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    </head>
    <body>
        <jsp:include page="../../Components/Sidebar.jsp" />
        <div class="main-content">
            <div class="container mt-4">
                <%
                if (action.equals("nuevo") || action.equals("editar")) {
                boolean edicion = cliente != null;
                %>
                <h2><%= edicion ? "Editar Cliente" : "Nuevo Cliente" %></h2>
                <form method="post" action="clientes" class="mt-3">
                    <input type="hidden" name="id" value="<%= edicion ? cliente.getId() : "" %>"/>
                    <div class="mb-3">
                        <label class="form-label">DNI</label>
                        <input type="text" name="dni" class="form-control" value="<%= edicion ? cliente.getDni() : "" %>"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nombre</label>
                        <input type="text" name="nombre" class="form-control" value="<%= edicion ? cliente.getNombre() : "" %>"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Apellido</label>
                        <input type="text" name="apellido" class="form-control" value="<%= edicion ? cliente.getApellido() : "" %>"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Teléfono</label>
                        <input type="text" name="telefono" class="form-control" value="<%= edicion ? cliente.getTelefono() : "" %>"/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <input type="text" name="email" class="form-control" value="<%= edicion ? cliente.getEmail() : "" %>"/>
                    </div>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-save"></i> Guardar
                    </button>
                    <a href="clientes" class="btn btn-secondary">Cancelar</a>
                </form>
                <% } else { %>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2>Gestión de Clientes</h2>
                    <a href="clientes?action=nuevo" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Nuevo Cliente
                    </a>
                </div>
                <table class="table table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>DNI</th>
                            <th>Nombre</th>
                            <th>Apellido</th>
                            <th>Teléfono</th>
                            <th>Email</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (lista != null) {
for (Cliente c : lista) { %>
                        <tr>
                            <td><%= c.getId() %></td>
                            <td><%= c.getDni() %></td>
                            <td><%= c.getNombre() %></td>
                            <td><%= c.getApellido() %></td>
                            <td><%= c.getTelefono() %></td>
                            <td><%= c.getEmail() %></td>
                            <td>
                                <a href="clientes?action=editar&id=<%= c.getId() %>" class="btn btn-sm btn-warning">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="clientes?action=eliminar&id=<%= c.getId() %>" class="btn btn-sm btn-danger" onclick="return confirm('¿Está seguro de eliminar este cliente?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>
                <% } %>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
