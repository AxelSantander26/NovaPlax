package santander.novaplax.servlets;

import santander.novaplax.dao.TicketDAO;
import santander.novaplax.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ventas")
public class VentaServlet extends HttpServlet {

    private final TicketDAO dao = new TicketDAO();

    private List<TicketDetalle> obtenerCarrito(HttpSession sesion) {
        @SuppressWarnings("unchecked")
        List<TicketDetalle> carrito = (List<TicketDetalle>) sesion.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            sesion.setAttribute("carrito", carrito);
        }
        return carrito;
    }

    private void configurarAtributosComunes(HttpServletRequest request) throws ServletException {
        request.setAttribute("articulos", dao.listarArticulosConStock());
        request.setAttribute("clientes", dao.listarClientes());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sesion = request.getSession();
        List<TicketDetalle> carrito = obtenerCarrito(sesion);
        if ("true".equals(request.getParameter("partial"))) {
            response.setContentType("text/html");
            request.setAttribute("carrito", carrito);
            request.getRequestDispatcher("/Pages/Shared/_carrito.jsp").forward(request, response);
            return;
        }
        Integer clienteSeleccionado = (Integer) sesion.getAttribute("clienteSeleccionado");
        if (clienteSeleccionado != null) {
            request.setAttribute("clienteSeleccionado", clienteSeleccionado);
        }
        configurarAtributosComunes(request);
        request.setAttribute("carrito", carrito);
        request.getRequestDispatcher("/Pages/Shared/ventas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession sesion = request.getSession();
        List<TicketDetalle> carrito = obtenerCarrito(sesion);
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        try {
            if ("guardarCliente".equals(action)) {
                String clienteIdStr = request.getParameter("cliente_id");
                if (clienteIdStr != null && !clienteIdStr.isEmpty()) {
                    sesion.setAttribute("clienteSeleccionado", Integer.valueOf(clienteIdStr));
                }
                if (isAjax) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"redirect\":\"ventas\"}");
                    return;
                } else {
                    response.sendRedirect("ventas");
                    return;
                }
            }
            if ("agregar".equals(action)) {
                int articuloId = Integer.parseInt(request.getParameter("articulo_id"));
                int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                int cantidadTotal = carrito.stream().filter(d -> d.getArticuloId() == articuloId).mapToInt(TicketDetalle::getCantidad).sum();
                if (!dao.validarStock(articuloId, cantidadTotal + cantidad)) {
                    if (isAjax) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"error\":\"No hay suficiente stock\"}");
                        return;
                    } else {
                        request.setAttribute("error", "No hay suficiente stock");
                    }
                    return;
                }
                boolean encontrado = false;
                for (TicketDetalle detalle : carrito) {
                    if (detalle.getArticuloId() == articuloId) {
                        detalle.setCantidad(detalle.getCantidad() + cantidad);
                        encontrado = true;
                        break;
                    }
                }
                if (!encontrado) {
                    TicketDetalle detalle = new TicketDetalle();
                    detalle.setArticuloId(articuloId);
                    detalle.setCantidad(cantidad);
                    detalle.setPrecioUnitario(new BigDecimal(request.getParameter("precio")));
                    detalle.setArticuloNombre(request.getParameter("articulo_nombre"));
                    carrito.add(detalle);
                }
                if (isAjax) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\":\"Producto agregado\"}");
                    return;
                } else {
                    request.setAttribute("success", "Producto agregado");
                }
            }
            if ("eliminar".equals(action)) {
                int index = Integer.parseInt(request.getParameter("index"));
                if (index >= 0 && index < carrito.size()) {
                    carrito.remove(index);
                    if (isAjax) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\":\"Producto eliminado\"}");
                        return;
                    } else {
                        request.setAttribute("success", "Producto eliminado");
                    }
                }
            }
            if ("finalizar".equals(action)) {
                Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
                Integer clienteId = (Integer) sesion.getAttribute("clienteSeleccionado");
                if (clienteId == null) {
                    if (isAjax) {
                        response.setContentType("application/json");
                        response.getWriter().write("{\"error\":\"Debe seleccionar un cliente antes de finalizar la venta.\"}");
                    } else {
                        request.setAttribute("error", "Debe seleccionar un cliente antes de finalizar la venta.");
                    }
                    return;
                }
                BigDecimal total = carrito.stream().map(TicketDetalle::getSubtotal).reduce(BigDecimal.ZERO, BigDecimal::add);
                Ticket ticket = new Ticket();
                ticket.setUsuarioId(usuario.getId());
                ticket.setTotal(total);
                ticket.setClienteId(clienteId);
                ticket.setDetalles(new ArrayList<>(carrito));
                dao.insertar(ticket);
                carrito.clear();
                sesion.removeAttribute("clienteSeleccionado");
                request.setAttribute("success", "Venta finalizada");
            }
        } catch (NumberFormatException | SQLException e) {
            if (isAjax) {
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
                return;
            } else {
                request.setAttribute("error", e.getMessage());
            }
        }
        if (!isAjax) {
            configurarAtributosComunes(request);
            request.setAttribute("carrito", carrito);
            request.getRequestDispatcher("/Pages/Shared/ventas.jsp").forward(request, response);
        }
    }
}
