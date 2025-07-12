package santander.novaplax.servlets;

import santander.novaplax.dao.ArticuloDAO;
import santander.novaplax.model.Articulo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/articulos")
public class ArticuloServlet extends HttpServlet {

    ArticuloDAO dao = new ArticuloDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action") == null ? "listar" : request.getParameter("action");

        switch (action) {
            case "nuevo":
                request.setAttribute("categorias", dao.listarCategorias());
                request.getRequestDispatcher("/Pages/Admin/articulos.jsp").forward(request, response);
                break;
            case "editar":
                int id = Integer.parseInt(request.getParameter("id"));
                Articulo a = dao.buscarPorId(id);
                request.setAttribute("articulo", a);
                request.setAttribute("categorias", dao.listarCategorias());
                request.getRequestDispatcher("/Pages/Admin/articulos.jsp").forward(request, response);
                break;
            case "eliminar":
                int idEliminar = Integer.parseInt(request.getParameter("id"));
                dao.eliminar(idEliminar);
                response.sendRedirect("articulos");
                break;
            default:
                List<Articulo> lista = dao.listar();
                request.setAttribute("lista", lista);
                request.getRequestDispatcher("/Pages/Admin/articulos.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        Articulo a = new Articulo();
        a.setNombre(request.getParameter("nombre"));
        a.setDescripcion(request.getParameter("descripcion"));
        a.setPrecio(new BigDecimal(request.getParameter("precio")));
        a.setStock(Integer.parseInt(request.getParameter("stock")));

        String catIdStr = request.getParameter("categoria_id");
        if (catIdStr != null && !catIdStr.isEmpty()) {
            a.setCategoriaId(Integer.parseInt(catIdStr));
        } else {
            a.setCategoriaId(null);
        }

        if (idStr == null || idStr.isEmpty()) {
            dao.insertar(a);
        } else {
            a.setId(Integer.parseInt(idStr));
            dao.actualizar(a);
        }

        response.sendRedirect("articulos");
    }
}
