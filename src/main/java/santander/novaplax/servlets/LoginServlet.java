package santander.novaplax.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import santander.novaplax.model.Usuario;
import santander.novaplax.dao.UsuarioDAO;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("usuario");
        String clave = request.getParameter("clave");

        Usuario user = null;

        try {
            UsuarioDAO dao = new UsuarioDAO();
            user = dao.buscarPorUsuarioYClave(usuario, clave);
        } catch (SQLException e) {
        }

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", user);

            if ("admin".equalsIgnoreCase(user.getRol())) {
                response.sendRedirect("Pages/Admin/info.jsp");
            } else if ("vendedor".equalsIgnoreCase(user.getRol())) {
                response.sendRedirect("Pages/Vendedor/info.jsp");
            } else {
                response.sendRedirect("login.jsp");
            }

        } else {
            request.setAttribute("error", "Usuario o clave incorrectos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
