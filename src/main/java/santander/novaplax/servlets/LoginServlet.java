package santander.novaplax.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import santander.novaplax.dao.UsuarioDAO;
import santander.novaplax.model.Usuario;

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

        UsuarioDAO dao = new UsuarioDAO();
        try {
            user = dao.buscarPorUsuarioYClave(usuario, clave);
        } catch (SQLException ex) {
            Logger.getLogger(LoginServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", user);

            String contexto = request.getContextPath();

            switch (user.getRol().toLowerCase()) {
                case "admin":
                    response.sendRedirect(contexto + "/Pages/Admin/info.jsp");
                    break;
                case "vendedor":
                    response.sendRedirect(contexto + "/Pages/Vendedor/info.jsp");
                    break;
                default:
                    response.sendRedirect(contexto + "/login.jsp");
            }
        } else {
            request.setAttribute("error", "Usuario o clave incorrectos");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
