package santander.novaplax.servlets;

import santander.novaplax.dao.UsuarioDAO;
import santander.novaplax.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/usuarios")
public class UsuarioControllerServlet extends HttpServlet {

    private final UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action") != null ? request.getParameter("action") : "listar";

        switch (action) {
            case "nuevo":
                // Solo mostramos el formulario sin datos
                request.setAttribute("action", "nuevo");
                request.getRequestDispatcher("/Pages/Admin/usuarios.jsp").forward(request, response);
                break;

            case "editar":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Usuario usuario = dao.buscarPorId(id);
                    request.setAttribute("usuario", usuario);
                    request.setAttribute("action", "editar");
                    request.getRequestDispatcher("/Pages/Admin/usuarios.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("usuarios");
                }
                break;

            case "eliminar":
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.eliminar(idEliminar);
                } catch (NumberFormatException e) {
                    // Puedes registrar el error
                }
                response.sendRedirect("usuarios");
                break;

            default:
                List<Usuario> usuarios = dao.listar();
                request.setAttribute("usuarios", usuarios);  // este nombre debe coincidir con el que usas en usuarios.jsp
                request.getRequestDispatcher("/Pages/Admin/usuarios.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        Usuario u = new Usuario();
        u.setUsuario(request.getParameter("usuario"));
        u.setContrasena(request.getParameter("contrasena"));
        u.setRol(request.getParameter("rol"));

        if (idStr == null || idStr.isEmpty()) {
            dao.insertar(u);
        } else {
            try {
                u.setId(Integer.parseInt(idStr));
                dao.actualizar(u);
            } catch (NumberFormatException e) {
                // Manejo de error
            }
        }

        response.sendRedirect("usuarios");
    }
}
