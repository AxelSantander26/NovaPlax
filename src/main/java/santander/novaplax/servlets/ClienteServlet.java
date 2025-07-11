package santander.novaplax.servlets;

import santander.novaplax.dao.ClienteDAO;
import santander.novaplax.model.Cliente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/clientes")
public class ClienteServlet extends HttpServlet {

    ClienteDAO dao = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") == null ? "listar" : request.getParameter("action");

        switch (action) {
            case "nuevo" -> {
                request.getRequestDispatcher("/Pages/Shared/clientes.jsp").forward(request, response);
            }
            case "editar" -> {
                int id = Integer.parseInt(request.getParameter("id"));
                Cliente c = dao.buscarPorId(id);
                request.setAttribute("cliente", c);
                request.getRequestDispatcher("/Pages/Shared/clientes.jsp").forward(request, response);
            }
            case "eliminar" -> {
                int eliminarId = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(eliminarId);
                response.sendRedirect("clientes");
            }
            default -> {
                List<Cliente> lista = dao.listar();
                request.setAttribute("lista", lista);
                request.getRequestDispatcher("/Pages/Shared/clientes.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Cliente c = new Cliente();
        c.setDni(request.getParameter("dni"));
        c.setNombre(request.getParameter("nombre"));
        c.setApellido(request.getParameter("apellido"));
        c.setTelefono(request.getParameter("telefono"));
        c.setEmail(request.getParameter("email"));

        if (idStr == null || idStr.isEmpty()) {
            dao.insertar(c);
        } else {
            c.setId(Integer.parseInt(idStr));
            dao.actualizar(c);
        }

        response.sendRedirect("clientes");
    }
}
