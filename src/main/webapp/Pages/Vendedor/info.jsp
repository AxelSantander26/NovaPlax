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
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración | NovaPlax</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="../../Components/Sidebar.jsp" />
    
    <div class="main-content">
        <div class="page-header mt-4">
            <h1 class="page-title">Panel de Administración</h1>
            <div class="date-time">
                <span id="current-date-time" class="text-muted"></span>
            </div>
        </div>
        
        <div class="content mt-4">
            <div class="alert alert-success">
                Bienvenido al panel de administración de NovaPlax
            </div>
            <p>este es el panel de vendedores</p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateDateTime() {
            const now = new Date();
            const options = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            };
            document.getElementById('current-date-time').textContent = now.toLocaleDateString('es-ES', options);
        }
        updateDateTime();
        setInterval(updateDateTime, 1000);
    </script>
</body>
</html>