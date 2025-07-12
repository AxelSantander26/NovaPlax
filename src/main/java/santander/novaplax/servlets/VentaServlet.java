package santander.novaplax.servlets;

import santander.novaplax.dao.TicketDAO;
import santander.novaplax.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ventas")
public class VentaServlet extends HttpServlet {
    private final TicketDAO dao = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession sesion = request.getSession();
        @SuppressWarnings("unchecked")
        List<TicketDetalle> carrito = (List<TicketDetalle>) sesion.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            sesion.setAttribute("carrito", carrito);
        }
        request.setAttribute("articulos", dao.listarArticulosConStock());
        request.setAttribute("clientes", dao.listarClientes());
        request.setAttribute("carrito", carrito);
        request.getRequestDispatcher("/Pages/Shared/ventas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession sesion = request.getSession();
        @SuppressWarnings("unchecked")
        List<TicketDetalle> carrito = (List<TicketDetalle>) sesion.getAttribute("carrito");

        if (carrito == null) {
            carrito = new ArrayList<>();
            sesion.setAttribute("carrito", carrito);
        }

        if (null != action) switch (action) {
            case "agregar" -> {
                try {
                    int articuloId = Integer.parseInt(request.getParameter("articulo_id"));
                    int cantidad = Integer.parseInt(request.getParameter("cantidad"));
                    
                    if (dao.validarStock(articuloId, cantidad)) {
                        TicketDetalle detalle = new TicketDetalle();
                        detalle.setArticuloId(articuloId);
                        detalle.setCantidad(cantidad);
                        detalle.setPrecioUnitario(new BigDecimal(request.getParameter("precio")));
                        detalle.setArticuloNombre(request.getParameter("articulo_nombre"));
                        carrito.add(detalle);
                    } else {
                        request.setAttribute("error", "Stock insuficiente para el artículo seleccionado");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Datos inválidos");
                }   response.sendRedirect("ventas");
            }
            case "eliminar" -> {
                try {
                    int index = Integer.parseInt(request.getParameter("index"));
                    if (index >= 0 && index < carrito.size()) {
                        carrito.remove(index);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Índice inválido");
                }   response.sendRedirect("ventas");
            }
            case "finalizar" -> {
                try {
                    Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
                    String clienteIdStr = request.getParameter("cliente_id");
                    
                    BigDecimal total = BigDecimal.ZERO;
                    for (TicketDetalle detalle : carrito) {
                        total = total.add(detalle.getSubtotal());
                    }
                    
                    Ticket ticket = new Ticket();
                    ticket.setUsuarioId(usuario.getId());
                    ticket.setTotal(total);
                    if (clienteIdStr != null && !clienteIdStr.isEmpty()) {
                        ticket.setClienteId(Integer.valueOf(clienteIdStr));
                    }
                    ticket.setDetalles(new ArrayList<>(carrito));
                    
                    dao.insertar(ticket);
                    carrito.clear();
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Error al finalizar la venta");
                }   response.sendRedirect("ventas");
            }
            default -> {
            }
        }
    }
}