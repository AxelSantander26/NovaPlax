<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="santander.novaplax.model.Usuario" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuarioLogueado") == null) {
        response.sendRedirect(request.getContextPath() + "/cerrar-sesion");
        return;
    }
    Usuario user = (Usuario) sesion.getAttribute("usuarioLogueado");
%>
<style>
    .sidebar {
        width: 216px;
        background: white;
        color: #333;
        height: 100vh;
        position: fixed;
        left: 0;
        top: 0;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        z-index: 1000;
        border-right: 1px solid #e0e0e0;
        overflow-y: auto;
    }
    .main-content {
        margin-left: 216px;
        width: calc(100% - 216px);
        padding: 20px;
        min-height: 100vh;
    }
    .sidebar-header {
        padding: 1.5rem;
        border-bottom: 1px solid #e0e0e0;
    }
    .sidebar-brand {
        font-size: 1.5rem;
        font-weight: 700;
        color: #2c3e50;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .sidebar-brand i {
        color: #3498db;
    }
    .user-profile {
        padding: 1.5rem;
        display: flex;
        align-items: center;
        gap: 1rem;
        border-bottom: 1px solid #e0e0e0;
    }
    .user-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background-color: #3498db;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
        font-size: 1.25rem;
    }
    .user-details {
        flex: 1;
    }
    .user-name {
        font-weight: 600;
        margin-bottom: 0.25rem;
        color: #2c3e50;
    }
    .user-role {
        font-size: 0.8rem;
        color: #7f8c8d;
        display: block;
    }
    .user-id {
        font-size: 0.7rem;
        color: #95a5a6;
    }
    .nav-item {
        margin: 0.25rem 0;
    }
    .nav-link {
        color: #7f8c8d;
        padding: 0.75rem 1.5rem;
        border-left: 3px solid transparent;
        transition: all 0.2s;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .nav-link:hover {
        color: #2c3e50;
        background-color: #f8f9fa;
        text-decoration: none;
    }
    .nav-link.active {
        color: #3498db;
        border-left-color: #3498db;
        background-color: #f8f9fa;
    }
    .nav-link i {
        width: 20px;
        text-align: center;
    }
    .logout-link {
        color: #e74c3c !important;
    }
    .logout-link:hover {
        background-color: rgba(231, 76, 60, 0.1) !important;
    }
    @media (max-width: 768px) {
        .sidebar {
            margin-left: -280px;
        }
        .sidebar.active {
            margin-left: 0;
        }
        .main-content {
            margin-left: 0;
            width: 100%;
        }
    }
</style>
<div class="sidebar">
    <div class="sidebar-header">
        <a href="#" class="sidebar-brand">
            <i class="fas fa-cube"></i>
            <span>NovaPlax</span>
        </a>
    </div>
    
    <div class="user-profile">
        <div class="user-avatar">
            <%= user.getUsuario().substring(0, 1).toUpperCase() %>
        </div>
        <div class="user-details">
            <span class="user-name"><%= user.getUsuario() %></span>
            <span class="user-role"><%= user.getRol() %></span>
            <span class="user-id">ID: <%= user.getId() %></span>
        </div>
    </div>
    
    <ul class="nav flex-column">
        <!-- Dashboard -->
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().endsWith("/inicio") ? "active" : "" %>" 
               href="<%= request.getContextPath() %>/inicio">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>
        
        <!-- Gestión de Usuarios (solo Admin) -->
        <% if ("admin".equalsIgnoreCase(user.getRol())) { %>
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("/admin/") ? "active" : "" %>" 
               href="<%= request.getContextPath() %>/admin/usuarios">
                <i class="fas fa-users"></i>
                <span>Gestión de Usuarios</span>
            </a>
        </li>
        <% } %>
        
        <!-- Gestión de Clientes -->
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("/clientes") ? "active" : "" %>" 
               href="<%= request.getContextPath() %>/clientes">
                <i class="fas fa-user-tie"></i>
                <span>Gestión de Clientes</span>
            </a>
        </li>
        
        <!-- Gestión de Artículos (solo Admin) -->
        <% if ("admin".equalsIgnoreCase(user.getRol())) { %>
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("/articulos") ? "active" : "" %>" 
               href="<%= request.getContextPath() %>/articulos">
                <i class="fas fa-boxes"></i>
                <span>Gestión de Artículos</span>
            </a>
        </li>
        <% } %>
        
        <!-- Registro de Ventas -->
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("/ventas") ? "active" : "" %>" 
               href="<%= request.getContextPath() %>/ventas">
                <i class="fas fa-cash-register"></i>
                <span>Registro de Ventas</span>
            </a>
        </li>
        
        <!-- Reportes -->
        <li class="nav-item">
            <a class="nav-link <%= request.getRequestURI().contains("/reportes") ? "active" : "" %>" 
               href="<%= request.getContextPath() %>/reportes">
                <i class="fas fa-chart-bar"></i>
                <span>Reportes</span>
            </a>
        </li>
        
        <!-- Logout -->
        <li class="nav-item mt-4">
            <a class="nav-link logout-link" href="<%= request.getContextPath() %>/cerrar-sesion">
                <i class="fas fa-sign-out-alt"></i>
                <span>Cerrar sesión</span>
            </a>
        </li>
    </ul>
</div>