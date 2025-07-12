package santander.novaplax.servlets;

import santander.novaplax.dao.ReporteDAO;
import santander.novaplax.dao.TicketDAO;
import santander.novaplax.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/reportes")
public class ReporteServlet extends HttpServlet {
    private final ReporteDAO reporteDAO = new ReporteDAO();
    private final TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("detalle".equals(action)) {
            mostrarDetalleVenta(request, response);
            return;
        }
        
        java.sql.Date fechaInicio = parseDate(request.getParameter("fechaInicio"));
        java.sql.Date fechaFin = parseDate(request.getParameter("fechaFin"));
        Integer clienteId = parseInteger(request.getParameter("clienteId"));
        Integer usuarioId = obtenerUsuarioId(request);

        List<ReporteVenta> reportes = reporteDAO.obtenerVentas(fechaInicio, fechaFin, clienteId, usuarioId);
        request.setAttribute("reportes", reportes);
        request.setAttribute("clientes", ticketDAO.listarClientes());
        
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuario != null && "admin".equals(usuario.getRol())) {
            request.setAttribute("vendedores", reporteDAO.obtenerVendedores());
        }
        
        request.getRequestDispatcher("/Pages/Shared/reportes.jsp").forward(request, response);
    }

    private void mostrarDetalleVenta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int ticketId = Integer.parseInt(request.getParameter("id"));
        List<TicketDetalle> detalles = reporteDAO.obtenerDetalleVenta(ticketId);
        request.setAttribute("detalles", detalles);
        request.getRequestDispatcher("/Pages/Shared/_detalleVenta.jsp").forward(request, response);
    }

    private Integer obtenerUsuarioId(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
        if (usuario != null && !"admin".equals(usuario.getRol())) {
            return usuario.getId();
        }
        return parseInteger(request.getParameter("vendedorId"));
    }

    private java.sql.Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) return null;
        try {
            Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);
            return new java.sql.Date(utilDate.getTime());
        } catch (ParseException e) {
            return null;
        }
    }

    private Integer parseInteger(String str) {
        if (str == null || str.isEmpty()) return null;
        try {
            return Integer.valueOf(str);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}