package santander.novaplax.dao;

import santander.novaplax.config.ConexionBD;
import santander.novaplax.model.Articulo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ArticuloDAO {

    public List<Articulo> listar() {
        List<Articulo> lista = new ArrayList<>();
        String sql = "SELECT a.*, c.nombre AS categoria_nombre FROM articulo a LEFT JOIN categoria c ON a.categoria_id = c.id";

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Articulo a = new Articulo();
                a.setId(rs.getInt("id"));
                a.setNombre(rs.getString("nombre"));
                a.setDescripcion(rs.getString("descripcion"));
                a.setPrecio(rs.getBigDecimal("precio"));
                a.setStock(rs.getInt("stock"));
                int catId = rs.getInt("categoria_id");
                a.setCategoriaId(rs.wasNull() ? null : catId);
                a.setCategoriaNombre(rs.getString("categoria_nombre"));
                lista.add(a);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Articulo> listarCategorias() {
        List<Articulo> lista = new ArrayList<>();
        String sql = "SELECT id, nombre FROM categoria";

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Articulo a = new Articulo();
                a.setCategoriaId(rs.getInt("id"));
                a.setCategoriaNombre(rs.getString("nombre"));
                lista.add(a);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public Articulo buscarPorId(int id) {
        Articulo a = null;
        String sql = "SELECT a.*, c.nombre AS categoria_nombre FROM articulo a LEFT JOIN categoria c ON a.categoria_id = c.id WHERE a.id = ?";

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    a = new Articulo();
                    a.setId(rs.getInt("id"));
                    a.setNombre(rs.getString("nombre"));
                    a.setDescripcion(rs.getString("descripcion"));
                    a.setPrecio(rs.getBigDecimal("precio"));
                    a.setStock(rs.getInt("stock"));
                    int catId = rs.getInt("categoria_id");
                    a.setCategoriaId(rs.wasNull() ? null : catId);
                    a.setCategoriaNombre(rs.getString("categoria_nombre"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return a;
    }

    public void insertar(Articulo a) {
        String sql = "INSERT INTO articulo (nombre, descripcion, precio, stock, categoria_id) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, a.getNombre());
            stmt.setString(2, a.getDescripcion());
            stmt.setBigDecimal(3, a.getPrecio());
            stmt.setInt(4, a.getStock());
            if (a.getCategoriaId() != null) {
                stmt.setInt(5, a.getCategoriaId());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void actualizar(Articulo a) {
        String sql = "UPDATE articulo SET nombre = ?, descripcion = ?, precio = ?, stock = ?, categoria_id = ? WHERE id = ?";

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, a.getNombre());
            stmt.setString(2, a.getDescripcion());
            stmt.setBigDecimal(3, a.getPrecio());
            stmt.setInt(4, a.getStock());
            if (a.getCategoriaId() != null) {
                stmt.setInt(5, a.getCategoriaId());
            } else {
                stmt.setNull(5, Types.INTEGER);
            }
            stmt.setInt(6, a.getId());
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM articulo WHERE id = ?";

        try (Connection conn = ConexionBD.conectar();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}