package santander.novaplax.dao;

import java.sql.*;
import santander.novaplax.config.ConexionBD;
import santander.novaplax.model.Usuario;

public class UsuarioDAO {

    private Connection conn;

    public UsuarioDAO() throws SQLException {
        conn = ConexionBD.conectar();
    }

    public Usuario buscarPorUsuarioYClave(String usuario, String contrasena) {
        Usuario u = null;
        String sql = "SELECT * FROM usuario WHERE usuario = ? AND contrasena = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, usuario);
            stmt.setString(2, contrasena);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                u = new Usuario(
                    rs.getInt("id"),
                    rs.getString("usuario"),
                    rs.getString("contrasena"),
                    rs.getString("rol")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return u;
    }
}
