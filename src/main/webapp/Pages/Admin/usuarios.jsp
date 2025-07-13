<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="santander.novaplax.model.Usuario" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect(request.getContextPath() + "/cerrar-sesion");
        return;
    }
    Usuario user = (Usuario) sesion.getAttribute("usuarioLogueado");
    String action = request.getParameter("action") != null ? request.getParameter("action") : "listar";
    Usuario usuarioForm = (Usuario) request.getAttribute("usuario");
    List<Usuario> lista = (List<Usuario>) request.getAttribute("lista");
    boolean edicion = usuarioForm != null;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Usuarios | NovaPlax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<jsp:include page="../../Components/Sidebar.jsp" />

<div class="main-content">
    <div class="container mt-4">

        <% if (action.equals("nuevo") || action.equals("editar")) { %>
            <h2><%= edicion ? "Editar Usuario" : "Nuevo Usuario" %></h2>
            <form method="post" action="usuarios" class="mt-3">
                <input type="hidden" name="id" value="<%= edicion ? usuarioForm.getId() : "" %>"/>

                <div class="mb-3">
                    <label class="form-label">Usuario</label>
                    <input type="text" name="usuario" class="form-control" value="<%= edicion ? usuarioForm.getUsuario() : "" %>" required/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Contraseña</label>
                    <input type="password" name="contrasena" class="form-control" value="<%= edicion ? usuarioForm.getContrasena() : "" %>" required/>
                </div>

                <div class="mb-3">
                    <label class="form-label">Rol</label>
                    <select name="rol" class="form-select" required>
                        <option value="">-- Seleccionar rol --</option>
                        <option value="admin" <%= edicion && "admin".equals(usuarioForm.getRol()) ? "selected" : "" %>>Administrador</option>
                        <option value="vendedor" <%= edicion && "vendedor".equals(usuarioForm.getRol()) ? "selected" : "" %>>Vendedor</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-success">
                    <i class="fas fa-save"></i> Guardar
                </button>
                <a href="usuarios" class="btn btn-secondary">Cancelar</a>
            </form>
        <% } else { %>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2>Gestión de Usuarios</h2>
                <a href="usuarios?action=nuevo" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Nuevo Usuario
                </a>
            </div>

            <table class="table table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Usuario</th>
                        <th>Rol</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (lista != null && !lista.isEmpty()) {
                        for (Usuario u : lista) { %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td><%= u.getUsuario() %></td>
                            <td><%= u.getRol() %></td>
                            <td>
                                <a href="usuarios?action=editar&id=<%= u.getId() %>" class="btn btn-sm btn-warning">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="usuarios?action=eliminar&id=<%= u.getId() %>" class="btn btn-sm btn-danger"
                                   onclick="return confirm('¿Está seguro de eliminar este usuario?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                    <% }
                    } else { %>
                        <tr><td colspan="4" class="text-center">No hay usuarios registrados.</td></tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
