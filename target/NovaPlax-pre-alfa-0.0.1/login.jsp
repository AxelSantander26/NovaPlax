<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login NovaPlax</title>
</head>
<body>
    <h2>Login NovaPlax</h2>

    <form action="login" method="post">
        <label for="usuario">Usuario:</label>
        <input type="text" id="usuario" name="usuario" required><br><br>

        <label for="clave">Contraseña:</label>
        <input type="password" id="clave" name="clave" required><br><br>

        <button type="submit">Ingresar</button>
    </form>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <p style="color:red;"><%= error %></p>
    <%
        }
    %>
</body>
</html>
