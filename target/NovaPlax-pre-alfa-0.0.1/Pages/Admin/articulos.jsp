<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="santander.novaplax.model.Usuario" %>
<%@ page import="santander.novaplax.model.Articulo" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect(request.getContextPath() + "/cerrar-sesion");
        return;
    }
    Usuario user = (Usuario) sesion.getAttribute("usuarioLogueado");
    String action = request.getParameter("action") != null ? request.getParameter("action") : "listar";
    Articulo articulo = (Articulo) request.getAttribute("articulo");
    List<Articulo> lista = (List<Articulo>) request.getAttribute("lista");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Artículos | NovaPlax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<jsp:include page="../../Components/Sidebar.jsp" />

<div class="main-content">
    <div class="container mt-4">
        <%
            if (action.equals("nuevo") || action.equals("editar")) {
                boolean edicion = articulo != null;
        %>
        <h2><%= edicion ? "Editar Artículo" : "Nuevo Artículo" %></h2>
        <form method="post" action="articulos" class="mt-3">
            <input type="hidden" name="id" value="<%= edicion ? articulo.getId() : "" %>"/>
            <div class="mb-3">
                <label class="form-label">Nombre</label>
                <input type="text" name="nombre" class="form-control" value="<%= edicion ? articulo.getNombre() : "" %>" required/>
            </div>
            <div class="mb-3">
                <label class="form-label">Descripción</label>
                <textarea name="descripcion" class="form-control"><%= edicion ? articulo.getDescripcion() : "" %></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Precio</label>
                <input type="number" step="0.01" name="precio" class="form-control" value="<%= edicion ? articulo.getPrecio() : "" %>" required/>
            </div>
            <div class="mb-3">
                <label class="form-label">Stock</label>
                <input type="number" name="stock" class="form-control" value="<%= edicion ? articulo.getStock() : "0" %>" required/>
            </div>
            <div class="mb-3">
                <label class="form-label">Categoría</label>
                <select name="categoria_id" class="form-select">
                    <option value="">-- Seleccionar Categoría --</option>
                    <% 
                    List<Articulo> categorias = (List<Articulo>) request.getAttribute("categorias");
                    if (categorias != null) {
                        for (Articulo cat : categorias) {
                            boolean selected = edicion && articulo.getCategoriaId() != null && articulo.getCategoriaId() == cat.getCategoriaId();
                    %>
                    <option value="<%= cat.getCategoriaId() %>" <%= selected ? "selected" : "" %>>
                        <%= cat.getCategoriaNombre() %>
                    </option>
                    <% } 
                    } %>
                </select>
            </div>
            <button type="submit" class="btn btn-success">
                <i class="fas fa-save"></i> Guardar
            </button>
            <a href="articulos" class="btn btn-secondary">Cancelar</a>
        </form>
        <% } else { %>
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Gestión de Artículos</h2>
            <a href="articulos?action=nuevo" class="btn btn-primary">
                <i class="fas fa-plus"></i> Nuevo Artículo
            </a>
        </div>
        <table class="table table-striped">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>Precio</th>
                <th>Stock</th>
                <th>Categoría</th>
                <th>Acciones</th>
            </tr>
            </thead>
            <tbody>
            <% if (lista != null) {
                for (Articulo a : lista) { %>
                <tr>
                    <td><%= a.getId() %></td>
                    <td><%= a.getNombre() %></td>
                    <td><%= a.getDescripcion() != null ? a.getDescripcion() : "" %></td>
                    <td><%= a.getPrecio() %></td>
                    <td><%= a.getStock() %></td>
                    <td><%= a.getCategoriaNombre() != null ? a.getCategoriaNombre() : "" %></td>
                    <td>
                        <a href="articulos?action=editar&id=<%= a.getId() %>" class="btn btn-sm btn-warning">
                            <i class="fas fa-edit"></i>
                        </a>
                        <a href="articulos?action=eliminar&id=<%= a.getId() %>" class="btn btn-sm btn-danger" onclick="return confirm('¿Está seguro de eliminar este artículo?')">
                            <i class="fas fa-trash"></i>
                        </a>
                    </td>
                </tr>
            <% } 
            } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>