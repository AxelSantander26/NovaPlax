package santander.novaplax.model;

import java.math.BigDecimal;
import java.util.List;

public class Ticket {
    private int id;
    private int usuarioId;
    private Integer clienteId;
    private String clienteNombre;
    private String fecha;
    private BigDecimal total;
    private List<TicketDetalle> detalles;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
    public Integer getClienteId() { return clienteId; }
    public void setClienteId(Integer clienteId) { this.clienteId = clienteId; }
    public String getClienteNombre() { return clienteNombre; }
    public void setClienteNombre(String clienteNombre) { this.clienteNombre = clienteNombre; }
    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    public List<TicketDetalle> getDetalles() { return detalles; }
    public void setDetalles(List<TicketDetalle> detalles) { this.detalles = detalles; }
}