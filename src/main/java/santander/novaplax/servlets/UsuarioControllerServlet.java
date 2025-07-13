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

        String action = request.getParameter("action") == null ? "listar" : request.getParameter("action");

        switch (action) {
            case "nuevo" -> {
                request.setAttribute("action", "nuevo");
                request.getRequestDispatcher("/Pages/Admin/usuarios.jsp").forward(request, response);
            }
            case "editar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Usuario u = dao.buscarPorId(id);
                request.setAttribute("usuario", u);
                request.setAttribute("action", "editar");
                request.getRequestDispatcher("/Pages/Admin/usuarios.jsp").forward(request, response);
            }
            case "eliminar" -> {
                int eliminarId = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(eliminarId);
                response.sendRedirect("usuarios");
            }
            default -> {
                List<Usuario> lista = dao.listar();
                request.setAttribute("lista", lista);
                request.getRequestDispatcher("/Pages/Admin/usuarios.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        String rol = request.getParameter("rol");

        Usuario u = new Usuario();
        u.setUsuario(usuario);
        u.setContrasena(contrasena);
        u.setRol(rol);

        if (idStr == null || idStr.isEmpty()) {
            if (dao.existeUsuario(usuario)) {
                request.setAttribute("error", "El nombre de usuario ya existe");
                request.setAttribute("action", "nuevo");
                request.getRequestDispatcher("/Pages/Admin/usuarios.jsp").forward(request, response);
                return;
            }
            dao.insertar(u);
        } else {
            u.setId(Integer.parseInt(idStr));
            dao.actualizar(u);
        }

        response.sendRedirect("usuarios");
    }
}

