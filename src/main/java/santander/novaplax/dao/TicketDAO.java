package santander.novaplax.dao;

import santander.novaplax.config.ConexionBD;
import santander.novaplax.model.Ticket;
import santander.novaplax.model.TicketDetalle;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import santander.novaplax.model.Articulo;
import santander.novaplax.model.Cliente;

public class TicketDAO {
    public void insertar(Ticket ticket) {
        String sqlTicket = "INSERT INTO ticket (usuario_id, cliente_id, fecha, total) VALUES (?, ?, NOW(), ?)";
        String sqlDetalle = "INSERT INTO ticket_detalle (ticket_id, articulo_id, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        String sqlActualizarStock = "UPDATE articulo SET stock = stock - ? WHERE id = ?";

        try (Connection conn = ConexionBD.conectar()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmtTicket = conn.prepareStatement(sqlTicket, Statement.RETURN_GENERATED_KEYS)) {
                stmtTicket.setInt(1, ticket.getUsuarioId());
                if (ticket.getClienteId() != null) {
                    stmtTicket.setInt(2, ticket.getClienteId());
                } else {
                    stmtTicket.setNull(2, Types.INTEGER);
                }
                stmtTicket.setBigDecimal(3, ticket.getTotal());
                stmtTicket.executeUpdate();
                ResultSet rs = stmtTicket.getGeneratedKeys();
                int ticketId = 0;
                if (rs.next()) {
                    ticketId = rs.getInt(1);
                }
                try (PreparedStatement stmtDetalle = conn.prepareStatement(sqlDetalle);
                     PreparedStatement stmtStock = conn.prepareStatement(sqlActualizarStock)) {
                    for (TicketDetalle d : ticket.getDetalles()) {
                        stmtDetalle.setInt(1, ticketId);
                        stmtDetalle.setInt(2, d.getArticuloId());
                        stmtDetalle.setInt(3, d.getCantidad());
                        stmtDetalle.setBigDecimal(4, d.getPrecioUnitario());
                        stmtDetalle.executeUpdate();
                        stmtStock.setInt(1, d.getCantidad());
                        stmtStock.setInt(2, d.getArticuloId());
                        stmtStock.executeUpdate();
                    }
                }
                conn.commit();
            }
        } catch (SQLException e) {
        }
    }

    public boolean validarStock(int articuloId, int cantidad) {
        String sql = "SELECT stock FROM articulo WHERE id = ?";
        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, articuloId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int stock = rs.getInt("stock");
                return cantidad <= stock;
            }
        } catch (SQLException e) {
        }
        return false;
    }

    public List<Articulo> listarArticulosConStock() {
        List<Articulo> lista = new ArrayList<>();
        String sql = "SELECT id, nombre, precio, stock FROM articulo WHERE stock > 0";
        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Articulo a = new Articulo();
                a.setId(rs.getInt("id"));
                a.setNombre(rs.getString("nombre"));
                a.setPrecio(rs.getBigDecimal("precio"));
                a.setStock(rs.getInt("stock"));
                lista.add(a);
            }
        } catch (SQLException e) {
        }
        return lista;
    }

    public List<Cliente> listarClientes() {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT id, dni, nombre, apellido FROM cliente";
        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setId(rs.getInt("id"));
                c.setDni(rs.getString("dni"));
                c.setNombre(rs.getString("nombre"));
                c.setApellido(rs.getString("apellido"));
                lista.add(c);
            }
        } catch (SQLException e) {
        }
        return lista;
    }
}