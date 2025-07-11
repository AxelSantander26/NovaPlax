package santander.novaplax.dao;

import santander.novaplax.config.ConexionBD;
import santander.novaplax.model.Cliente;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public List<Cliente> listar() {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT * FROM cliente";

        try (Connection conn = ConexionBD.conectar(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Cliente c = new Cliente();
                c.setId(rs.getInt("id"));
                c.setDni(rs.getString("dni"));
                c.setNombre(rs.getString("nombre"));
                c.setApellido(rs.getString("apellido"));
                c.setTelefono(rs.getString("telefono"));
                c.setEmail(rs.getString("email"));
                lista.add(c);
            }

        } catch (SQLException e) {
        }
        return lista;
    }

    public Cliente buscarPorId(int id) {
        Cliente c = null;
        String sql = "SELECT * FROM cliente WHERE id = ?";

        try (Connection conn = ConexionBD.conectar(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    c = new Cliente();
                    c.setId(rs.getInt("id"));
                    c.setDni(rs.getString("dni"));
                    c.setNombre(rs.getString("nombre"));
                    c.setApellido(rs.getString("apellido"));
                    c.setTelefono(rs.getString("telefono"));
                    c.setEmail(rs.getString("email"));
                }
            }

        } catch (SQLException e) {
        }
        return c;
    }

    public void insertar(Cliente c) {
        String sql = "INSERT INTO cliente (dni, nombre, apellido, telefono, email) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConexionBD.conectar(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, c.getDni());
            stmt.setString(2, c.getNombre());
            stmt.setString(3, c.getApellido());
            stmt.setString(4, c.getTelefono());
            stmt.setString(5, c.getEmail());
            stmt.executeUpdate();

        } catch (SQLException e) {
        }
    }

    public void actualizar(Cliente c) {
        String sql = "UPDATE cliente SET dni = ?, nombre = ?, apellido = ?, telefono = ?, email = ? WHERE id = ?";

        try (Connection conn = ConexionBD.conectar(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, c.getDni());
            stmt.setString(2, c.getNombre());
            stmt.setString(3, c.getApellido());
            stmt.setString(4, c.getTelefono());
            stmt.setString(5, c.getEmail());
            stmt.setInt(6, c.getId());
            stmt.executeUpdate();

        } catch (SQLException e) {
        }
    }

    public void eliminar(int id) {
        String sql = "DELETE FROM cliente WHERE id = ?";

        try (Connection conn = ConexionBD.conectar(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();

        } catch (SQLException e) {
        }
    }
}
