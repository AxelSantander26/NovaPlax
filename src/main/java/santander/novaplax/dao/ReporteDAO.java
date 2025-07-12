package santander.novaplax.dao;

import santander.novaplax.config.ConexionBD;
import santander.novaplax.model.ReporteVenta;
import santander.novaplax.model.TicketDetalle;
import santander.novaplax.model.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReporteDAO {
    public List<ReporteVenta> obtenerVentas(java.sql.Date fechaInicio, java.sql.Date fechaFin, Integer clienteId, Integer usuarioId) {
        List<ReporteVenta> reportes = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.id AS ticket_id, t.fecha, CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre, " +
            "u.usuario AS vendedor, t.total, " +
            "(SELECT SUM(td.cantidad) FROM ticket_detalle td WHERE td.ticket_id = t.id) AS cantidad_articulos " +
            "FROM ticket t LEFT JOIN cliente c ON t.cliente_id = c.id " +
            "JOIN usuario u ON t.usuario_id = u.id WHERE 1=1"
        );

        if (fechaInicio != null) sql.append(" AND t.fecha >= ?");
        if (fechaFin != null) sql.append(" AND t.fecha <= ?");
        if (clienteId != null) sql.append(" AND t.cliente_id = ?");
        if (usuarioId != null) sql.append(" AND t.usuario_id = ?");
        sql.append(" ORDER BY t.fecha DESC");

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (fechaInicio != null) stmt.setDate(paramIndex++, fechaInicio);
            if (fechaFin != null) stmt.setDate(paramIndex++, fechaFin);
            if (clienteId != null) stmt.setInt(paramIndex++, clienteId);
            if (usuarioId != null) stmt.setInt(paramIndex++, usuarioId);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ReporteVenta reporte = new ReporteVenta();
                reporte.setTicketId(rs.getInt("ticket_id"));
                reporte.setFecha(rs.getTimestamp("fecha"));
                reporte.setClienteNombre(rs.getString("cliente_nombre"));
                reporte.setVendedor(rs.getString("vendedor"));
                reporte.setTotal(rs.getBigDecimal("total"));
                reporte.setCantidadArticulos(rs.getInt("cantidad_articulos"));
                reportes.add(reporte);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reportes;
    }

    public List<TicketDetalle> obtenerDetalleVenta(int ticketId) {
        List<TicketDetalle> detalles = new ArrayList<>();
        String sql = "SELECT td.*, a.nombre AS articulo_nombre FROM ticket_detalle td " +
                     "JOIN articulo a ON td.articulo_id = a.id WHERE td.ticket_id = ?";
        
        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                TicketDetalle detalle = new TicketDetalle();
                detalle.setId(rs.getInt("id"));
                detalle.setTicketId(rs.getInt("ticket_id"));
                detalle.setArticuloId(rs.getInt("articulo_id"));
                detalle.setArticuloNombre(rs.getString("articulo_nombre"));
                detalle.setCantidad(rs.getInt("cantidad"));
                detalle.setPrecioUnitario(rs.getBigDecimal("precio_unitario"));
                detalles.add(detalle);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return detalles;
    }

    public List<Usuario> obtenerVendedores() {
        List<Usuario> vendedores = new ArrayList<>();
        String sql = "SELECT id, usuario FROM usuario WHERE rol = 'vendedor'";
        
        try (Connection conn = ConexionBD.conectar();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Usuario usuario = new Usuario();
                usuario.setId(rs.getInt("id"));
                usuario.setUsuario(rs.getString("usuario"));
                vendedores.add(usuario);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vendedores;
    }
}